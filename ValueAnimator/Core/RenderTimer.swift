//
//  RenderTimer.swift
//  ValueAnimator
//
//  Created by hyonsoo han on 2018. 8. 16..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//
// ref: https://medium.com/@danielgalasko/a-background-repeating-timer-in-swift-412cecfd2ef9

import Foundation

final class RenderTimer {
    
    let timeInterval: TimeInterval
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    var eventHandler: (() -> Void)?
    
    enum State: String {
        case suspended
        case resumed
    }
    
    private(set) var state: State = .suspended
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
