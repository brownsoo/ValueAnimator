//
//  CADisplayLinkDriver.swift
//  ValueAnimator
//
//  Created on 2026. 3. 16..
//

import Foundation
import QuartzCore

// MARK: - iOS / tvOS (CADisplayLink via UIKit)

#if canImport(UIKit) && !os(watchOS)

final class CADisplayLinkDriver: DisplayLinkDriver {
    var onTick: ((TimeInterval) -> Void)?
    private var displayLink: CADisplayLink?

    func start() {
        guard displayLink == nil else { return }
        let link = CADisplayLink(target: self, selector: #selector(handleTick(_:)))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func handleTick(_ link: CADisplayLink) {
        onTick?(link.timestamp)
    }

    deinit {
        stop()
    }
}

#endif


