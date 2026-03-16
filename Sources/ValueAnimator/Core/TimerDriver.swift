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

    private static let timerQueue = DispatchQueue(
        label: "com.hansoolabs.valueanimator.timer",
        qos: .userInteractive
    )

    func start() {
        guard timer == nil else { return }
        let t = DispatchSource.makeTimerSource(queue: TimerDriver.timerQueue)
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

/// Portable monotonic clock.
/// On platforms with QuartzCore, `QuartzCore.CACurrentMediaTime()` is available globally.
/// On other platforms (e.g. watchOS without QuartzCore), provide a fallback.
#if canImport(QuartzCore)
import QuartzCore
#else
func CACurrentMediaTime() -> TimeInterval {
    return ProcessInfo.processInfo.systemUptime
}
#endif
