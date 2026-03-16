//
//  CVDisplayLinkDriver.swift
//  ValueAnimator
//
//  Created on 2026. 3. 16..
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import Foundation
import CoreVideo

/// macOS < 14 frame driver using CVDisplayLink.
final class CVDisplayLinkDriver: DisplayLinkDriver {
    var onTick: ((TimeInterval) -> Void)?
    private var displayLink: CVDisplayLink?

    /// Falls back to a timer if CVDisplayLink cannot be created (headless / CI).
    private var fallback: TimerDriver?

    func start() {
        guard displayLink == nil, fallback == nil else { return }
        var link: CVDisplayLink?
        CVDisplayLinkCreateWithActiveCGDisplays(&link)
        guard let link = link else {
            // No display available — use timer fallback
            let timer = TimerDriver()
            timer.onTick = { [weak self] ts in self?.onTick?(ts) }
            timer.start()
            fallback = timer
            return
        }
        displayLink = link

        CVDisplayLinkSetOutputHandler(link) { [weak self] _, inNow, _, _, _ -> CVReturn in
            let timestamp = Double(inNow.pointee.videoTime) / Double(inNow.pointee.videoTimeScale)
            DispatchQueue.main.async {
                self?.onTick?(timestamp)
            }
            return kCVReturnSuccess
        }
        CVDisplayLinkStart(link)
    }

    func stop() {
        if let link = displayLink {
            CVDisplayLinkStop(link)
            displayLink = nil
        }
        fallback?.stop()
        fallback = nil
    }

    deinit {
        stop()
    }
}

#endif
