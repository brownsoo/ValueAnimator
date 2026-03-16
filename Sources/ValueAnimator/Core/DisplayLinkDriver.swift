//
//  DisplayLinkDriver.swift
//  ValueAnimator
//
//  Created on 2026. 3. 16..
//

import Foundation

/// Abstraction for a frame-rate driver that delivers periodic ticks.
/// Each platform provides a concrete implementation.
protocol DisplayLinkDriver: AnyObject {
    /// Called on every frame with the current timestamp (seconds).
    var onTick: ((TimeInterval) -> Void)? { get set }
    /// Start delivering ticks.
    func start()
    /// Stop delivering ticks and release resources.
    func stop()
}

/// Factory that returns the best available driver for the current platform.
enum DisplayLinkDriverFactory {
    static func makeDriver() -> DisplayLinkDriver {
        #if canImport(UIKit) && !os(watchOS)
        // iOS / tvOS — and macOS Catalyst
        return CADisplayLinkDriver()
        #elseif canImport(AppKit)
        // macOS native — uses CVDisplayLink for vsync
        return CVDisplayLinkDriver()
        #else
        // watchOS and any other platform
        return TimerDriver()
        #endif
    }
}
