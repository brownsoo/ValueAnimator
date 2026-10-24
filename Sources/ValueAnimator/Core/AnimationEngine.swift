//
//  AnimationEngine.swift
//  ValueAnimator
//
//  Created on 2026. 3. 16..
//

import Foundation

/// Central actor that owns the animation list and drives frame updates.
/// Replaces the previous Thread + NSRecursiveLock approach with actor isolation.
actor AnimationEngine {

    static let shared = AnimationEngine()

    private var animations = Set<ValueAnimator>()
    private var driver: DisplayLinkDriver?

    /// Thread-safe animation count — updated atomically on every add/remove.
    nonisolated let animationCount = AtomicInt(0)

    var count: Int {
        animations.count
    }

    // MARK: - List management

    func add(_ ani: ValueAnimator) {
        animations.insert(ani)
        animationCount.store(animations.count)
        #if DEBUG
        if ValueAnimator.debug {
            print("ValueAnimator -----------: aniList added id: \(ani.hashValue)")
        }
        #endif
        startDriverIfNeeded()
    }

    func finishAll() {
        let snapshot = animations
        for ani in snapshot {
            finishAnimation(ani)
        }
    }

    func disposeAll() {
        let snapshot = animations
        for ani in snapshot {
            disposeAnimation(ani)
        }
    }

    func hasAnimation(_ prop: String) -> Bool {
        animations.contains { $0.props.contains(prop) }
    }

    // MARK: - Per-frame update

    /// Called by the DisplayLinkDriver on every frame.
    nonisolated func handleTick(_ timestamp: TimeInterval) {
        Task { await tick(timestamp) }
    }

    private func tick(_ timestamp: TimeInterval) {
        let snapshot = animations
        if snapshot.isEmpty {
            stopDriver()
            return
        }
        for ani in snapshot {
            update(ani, now: timestamp)
        }
    }

    // MARK: - Animation update (ported from the old static methods)

    private func update(_ ani: ValueAnimator, now: TimeInterval) {
        if ani.isDisposed {
            disposeAnimation(ani)
            return
        }
        if ani.isFinished {
            finishAnimation(ani)
            return
        }
        if !ani.isAnimating {
            ani.startTime = now - ani.covered
            return
        }
        if ani.delay > 0 {
            ani.delay -= (now - ani.startTime)
            ani.startTime = now
            return
        }
        // 시간 계산
        ani.covered = now - ani.startTime
        // repeating
        if ani.covered >= ani.duration {
            if ani.yoyo {
                if ani.repeatCount <= 0 || ani.repeatCount > ani.counted || ani.isInfinitely {
                    for p in ani.props {
                        if let initial = ani.initials[p],
                           let changeEnd = ani.changes[p] {
                            let changed = initial + changeEnd
                            notifyChange(ani, p, changed)
                            ani.initials[p] = changed
                            ani.changes[p]! *= -1.0
                        }
                    }
                    ani.startTime = now
                    ani.counted += 1
                    return
                }
            }
            if ani.counted < ani.repeatCount || ani.isInfinitely {
                for p in ani.props {
                    if let initial = ani.initials[p] {
                        notifyChange(ani, p, initial)
                    }
                }
                ani.startTime = now
                ani.counted += 1
                return
            }

            finishAnimation(ani)
        } else {
            // call updates in progress
            for p in ani.props {
                let value = ani.easing(
                    ani.covered,
                    ani.initials[p]!.value,
                    ani.changes[p]!.value,
                    ani.duration
                ).toAnimatable()
                notifyChange(ani, p, value)
            }
        }
    }

    // MARK: - Callbacks

    private func notifyChange(_ ani: ValueAnimator, _ p: String, _ v: ValueAnimatable) {
        if ani.callbackOnMainThread {
            if Thread.isMainThread {
                ani.changeCallback?(p, v)
            } else {
                DispatchQueue.main.async {
                    ani.changeCallback?(p, v)
                }
            }
        } else {
            ani.changeCallback?(p, v)
        }
    }

    // MARK: - Finish / Dispose

    private func finishAnimation(_ ani: ValueAnimator) {
        animations.remove(ani)
        animationCount.store(animations.count)
        for p in ani.props {
            if let initial = ani.initials[p],
               let amount = ani.changes[p] {
                notifyChange(ani, p, initial + amount)
            }
        }
        ani.isAnimating = false
        ani.isFinished = true
        if ani.callbackOnMainThread {
            DispatchQueue.main.async {
                ani.endCallback?()
            }
        } else {
            ani.endCallback?()
        }
        stopDriverIfEmpty()
    }

    private func disposeAnimation(_ ani: ValueAnimator) {
        animations.remove(ani)
        animationCount.store(animations.count)
        ani.isDisposed = true
        ani.isAnimating = false
        stopDriverIfEmpty()
    }

    // MARK: - Driver lifecycle

    private func startDriverIfNeeded() {
        guard driver == nil else { return }
        let d = DisplayLinkDriverFactory.makeDriver()
        d.onTick = { [weak self] timestamp in
            self?.handleTick(timestamp)
        }
        d.start()
        driver = d
    }

    private func stopDriver() {
        driver?.stop()
        driver = nil
        #if DEBUG
        if ValueAnimator.debug {
            print("ValueAnimator nothing to animate")
        }
        #endif
    }

    private func stopDriverIfEmpty() {
        if animations.isEmpty {
            stopDriver()
        }
    }
}
