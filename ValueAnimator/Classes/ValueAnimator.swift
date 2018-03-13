//
// Created by brownsoo han on 2018. 3. 12..
//

import Foundation

public class ValueAnimator: Hashable {
    
    public struct Option {
        let yoyo: Bool
        let repeatCount: Int
        let delay: TimeInterval
        
        public class Builder {
            var yoyo: Bool = false
            var repeatCount: Int = 0
            var delay: TimeInterval = 0
            
            public func setYoyo(v: Bool) {
                yoyo = v
            }
            public func setRepeatCount(v: Int) {
                repeatCount = v
            }
            public func setDelay(v: TimeInterval) {
                delay = v
            }
            public func build() -> Option {
                return Option(yoyo: yoyo, repeatCount: repeatCount, delay: delay)
            }
        }
    }
    
    public typealias EndFunction = () -> Void
    public typealias ChangeFunction = (String, Double) -> Void
    
    private lazy var objectIdentifier = ObjectIdentifier(self)
    private var props = [String]()
    /// millisecond
    private var startMillis: TimeInterval = 0
    private var initials = [String: Double]()
    private var changes = [String: Double]()
    /// second
    private var duration = TimeInterval(1)
    private var easing: EasingFunction = EaseLinear.easeInOut
    
    /// seconds in corvered on timeline
    private var corvered: TimeInterval = 0 // second
    /// seconds to delay
    private var delay: TimeInterval = 0  // second
    /// yoyo animation
    public private(set) var yoyo = false
    /// how many it repeat animation.
    public private(set) var repeatCount: Int = 0
    /// animated count
    public private(set) var count: Int = 0
    public private(set) var isAnimating = false
    public private(set) var isFinished = false
    public private(set) var isDisposed = false
    
    /// callback for animation updates
    public var changeFunction: ChangeFunction = { prop, value in print("default changeFunction \(prop): \(value)")}
    /// callback for animation finishes
    public var endFunction: EndFunction? = nil
    
    public var hashValue: Int {
        return self.objectIdentifier.hashValue
    }
    public static func ==(left: ValueAnimator, right: ValueAnimator) -> Bool {
        return left.objectIdentifier == right.objectIdentifier
    }
    
    public init() {
    }
    
    public func resume() {
        isAnimating = true
    }
    
    public func pause() {
        isAnimating = false
    }
    
    public func finish() {
        isFinished = true
    }
    public func dispose() {
        isDisposed = true
    }
    
    
    // MARK: class values
    
    static public var debug = false
    static private var aniList = Set<ValueAnimator>()
    static private var nowMillis: TimeInterval = 0
    static private var renderer: Thread? = nil
    
    static public func finishAll() {
        aniList.forEach { $0.finish() }
    }
    
    static public func disposeAll() {
        aniList.removeAll()
    }
    
    static public func of(_ prop: String, from: Double, to: Double, duration: TimeInterval, onChanged: @escaping ChangeFunction) -> ValueAnimator {
        let ani = animateCore(props: [prop], from: [from], to: [to], changeFunction: onChanged,
                              duration: duration)
        aniList.insert(ani)
        if debug {
            print("aniList added id: \(ani.hashValue)")
        }
        // TODO start runLoop if not running
        if renderer == nil || renderer?.isFinished == true {
            renderer = Thread(target: self, selector: #selector(onProgress), object: nil)
            renderer?.name = "renderer"
            renderer?.qualityOfService = .default
            renderer?.start()
        }
        return ani
    }
    
    static private func animateCore(props: [String],
                                    from: [Double],
                                    to: [Double],
                                    changeFunction: @escaping ChangeFunction,
                                    duration: TimeInterval = 1,
                                    easing: @escaping EasingFunction = EaseCircular.easeOut,
                                    endFunction: EndFunction? = nil,
                                    option: Option? = nil) -> ValueAnimator {
        let ani = ValueAnimator()
        ani.props = props
        for (i, p) in props.enumerated() {
            ani.initials[p] = from[i]
            ani.changes[p] = to[i] - from[i]
        }
        ani.duration = duration
        ani.easing = easing
        ani.endFunction = endFunction
        if let option = option {
            ani.yoyo = option.yoyo
            ani.repeatCount = option.repeatCount
            ani.delay = option.delay
        }
        if ani.yoyo && ani.repeatCount > 0 {
            ani.repeatCount *= 2
        }
        ani.changeFunction = changeFunction
        
        return ani
    }
    
    @objc
    static private func onProgress() {
        while aniList.count > 0 {
            print("onProgress Thread.isMainThread: \(Thread.isMainThread)")
            for ani in aniList {
                update(ani)
            }
            Thread.sleep(forTimeInterval: 1)
        }
        if debug {
            print("nothing to animate")
            print("renderer?.isFinished: \(renderer?.isFinished ?? false)")
        }
        
    }
    
    static private func update(_ ani: ValueAnimator) {
        if ani.isDisposed {
            dispose(ani)
            return
        }
        if ani.isFinished {
            finish(ani)
            return
        }
        nowMillis = Date().timeIntervalSince1970
        if !ani.isAnimating {
            ani.startMillis = nowMillis - ani.corvered * 1000
            return
        }
        if ani.delay > 0 {
            ani.delay -= (nowMillis - ani.startMillis)
            ani.startMillis = nowMillis
            return
        }
        // 시간 계산
        ani.corvered = (nowMillis - ani.startMillis) * 0.001
        if ani.corvered >= ani.duration {
            if ani.yoyo {
                if ani.repeatCount <= 0 || ani.repeatCount > ani.count {
                    for p in ani.props {
                        if let initial = ani.initials[p],
                            let change = ani.changes[p] {
                            ani.changeFunction(p, initial + change)
                            ani.initials[p]! += change
                            ani.changes[p]! *= -1
                        }
                    }
                    ani.startMillis = nowMillis
                    ani.count += 1
                    return
                }
            }
            if ani.count < ani.repeatCount {
                for p in ani.props {
                    if let initial = ani.initials[p]{
                        ani.changeFunction(p, initial)
                    }
                }
                ani.startMillis = nowMillis
                ani.count += 1
                return
            }
            
            finish(ani)
        } else {
            // call updates in progress
            for p in ani.props {
                ani.changeFunction(p, ani.easing(ani.corvered, ani.initials[p]!, ani.changes[p]!, ani.duration))
            }
        }
    }
    
    
    /// finish animation and update value with target
    static private func finish(_ ani: ValueAnimator) {
        aniList.remove(ani)
        for p in ani.props {
            if let initial = ani.initials[p],
                let change = ani.changes[p] {
                ani.changeFunction(p, initial + change)
            }
        }
        ani.isFinished = true
        ani.endFunction?()
    }
    
    /// finish animation during animation
    static private func dispose(_ ani: ValueAnimator) {
        aniList.remove(ani)
        ani.isFinished = true
    }
    
    
    
    
    
    
}
