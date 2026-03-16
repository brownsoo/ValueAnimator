//
//  TimerDriver.swift
//  ValueAnimator
//
//  Created on 2026. 3. 16..
//

import Foundation

/// Fallback frame driver using DispatchSourceTimer.
/// Used on watchOS and any platform without CADisplayLink / CVDisplayLink.
final class TimerDriver: DisplayLinkDriver {
    var onTick: ((TimeInterval) -> Void)?
    private var timer: DispatchSourceTimer?
    private let interval: TimeInterval

    init(fps: Int = 60) {
        self.interval = 1.0 / Double(fps)
    }

    func start() {
        guard timer == nil else { return }
        let t = DispatchSource.makeTimerSource(queue: .main)
        t.schedule(deadline: .now(), repeating: interval, leeway: .milliseconds(1))
        t.setEventHandler { [weak self] in
            self?.onTick?(CACurrentMediaTime())
        }
        t.resume()
        timer = t
    }

    func stop() {
        timer?.cancel()
        timer = nil
    }

    deinit {
        stop()
    }
}

/// Portable monotonic clock — uses QuartzCore when available, falls back to Foundation.
func CACurrentMediaTime() -> TimeInterval {
    #if canImport(QuartzCore)
    return QuartzCore.CACurrentMediaTime()
    #else
    return ProcessInfo.processInfo.systemUptime
    #endif
}
