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

    func start() {
        guard displayLink == nil else { return }
        var link: CVDisplayLink?
        CVDisplayLinkCreateWithActiveCGDisplays(&link)
        guard let link = link else { return }
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
        guard let link = displayLink else { return }
        CVDisplayLinkStop(link)
        displayLink = nil
    }

    deinit {
        stop()
    }
}

#endif
