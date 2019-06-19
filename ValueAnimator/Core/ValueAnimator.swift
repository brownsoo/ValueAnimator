//
// Created by brownsoo han on 2018. 3. 12..
//

import Foundation

public class ValueAnimator: Hashable {

    public struct Option {
        let yoyo: Bool
        let repeatCount: Int
        let delay: TimeInterval
        let repeatInfinitely: Bool
    }

    public class OptionBuilder {
        var yoyo: Bool = false
        var repeatCount: Int = 0
        var delay: TimeInterval = 0
        var repeatInfinitely: Bool = false

        public init() {
        }

        public func setYoyo(_ v: Bool) -> OptionBuilder {
            yoyo = v
            return self
        }

        public func setRepeatCount(_ v: Int) -> OptionBuilder {
            repeatCount = v
            return self
        }

        public func setDelay(_ v: TimeInterval) -> OptionBuilder {
            delay = v
            return self
        }

        public func setRepeatInfinitely(_ b: Bool) -> OptionBuilder {
            repeatInfinitely = b
            return self
        }

        public func build() -> Option {
            return Option(yoyo: yoyo, repeatCount: repeatCount, delay: delay, repeatInfinitely: repeatInfinitely)
        }
    }

    public typealias EndFunction = () -> Void
    public typealias ChangeFunction = (String, ValueAnimatable) -> Void

    private lazy var objectIdentifier = ObjectIdentifier(self)

    #if swift(>=5.0)
    public func hash(into hasher: inout Hasher) {
        hasher.combine(objectIdentifier)
    }
    #elseif swift(>=4.2)
        #if compiler(>=5.0)
        public func hash(into hasher: inout Hasher) {
            hasher.combine(objectIdentifier)
        }
        #else
        var hashValue: Int {
            return self.objectIdentifier.hashValue
        }
        #endif
    #else
    public var hashValue: Int {
        return self.objectIdentifier.hashValue
    }
    #endif

    private var props = [String]()
    private var startTime: TimeInterval = 0
    private var initials = [String: ValueAnimatable]()
    private var changes = [String: ValueAnimatable]()
    private var duration: TimeInterval = 1

    /// seconds in covered on timeline
    private var covered: TimeInterval = 0
    /// seconds to delay
    private var delay: TimeInterval = 0
    /// yoyo animation
    public private(set) var yoyo = false
    /// how many it repeat animation.
    public private(set) var repeatCount: Int = 0
    /// animated count
    public private(set) var counted: Int = 0 {
        didSet {
#if DEBUG
            print("ValueAnimator--- counted: \(counted)")
#endif
        }
    }
    private lazy var easingCapture: Easing = EaseSine.easeInOut()
    public var easing: Easing! {
        set {
            if !isAnimating {
                easingCapture = newValue
            }
        }
        get {
            return easingCapture
        }
    }
    /// whether if it repeat infinitely or not.
    /// if true, animation ignores repeatCount
    public private(set) var isInfinitely = false
    public private(set) var isAnimating = false
    public private(set) var isFinished = false
    public private(set) var isDisposed = false

    /// callback for animation updates
    public var changeFunction: ChangeFunction? = nil
    /// callback for animation finishes
    public var endFunction: EndFunction? = nil

    public var callbackOnMainThread: Bool = true

    public static func ==(left: ValueAnimator, right: ValueAnimator) -> Bool {
        return left.objectIdentifier == right.objectIdentifier
    }

    private init() {
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
    static public var frameRate: Int = 40 {
        didSet {
            sleepTime = 1 / Double(frameRate)
        }
    }
    static private var nowTime: TimeInterval = 0
    static private var renderer: Thread? = nil
    static private var aniList = Set<ValueAnimator>()
    static private var sleepTime: TimeInterval = 0.02

    static public var count: Int {
        return aniList.count
    }

    static public func finishAll() {
        aniList.forEach {
            $0.finish()
        }
    }

    static public func disposeAll() {
        aniList.removeAll()
    }

    static public func hasAnimation(_ prop: String) -> Bool {
        return aniList.first{ $0.props.contains(prop) } != nil
    }

    @discardableResult
    static public func animate(_ prop: String,
                               from: AnimatableValueType,
                               to: AnimatableValueType,
                               duration: TimeInterval,
                               easing: Easing? = nil,
                               onChanged: ChangeFunction? = nil) -> ValueAnimator {
        return animate(props: [prop],
                       from: [from],
                       to: [to],
                       duration: duration,
                       easing: easing,
                       onChanged: onChanged,
                       option: nil,
                       onEnd: nil)
    }
    
    @discardableResult
    static public func animate(_ prop: String,
                               from: AnimatableValueType,
                               to: AnimatableValueType,
                               duration: TimeInterval,
                               onChanged: ChangeFunction? = nil) -> ValueAnimator {
        return animate(props: [prop],
                       from: [from],
                       to: [to],
                       duration: duration,
                       easing: nil,
                       onChanged: onChanged,
                       option: nil,
                       onEnd: nil)
    }
    
    @discardableResult
    static public func animate(_ prop: String,
                               from: AnimatableValueType,
                               to: AnimatableValueType,
                               duration: TimeInterval,
                               easing: Easing? = nil,
                               onChanged: ChangeFunction? = nil,
                               option: Option? = nil) -> ValueAnimator {
        return animate(props: [prop],
                       from: [from],
                       to: [to],
                       duration: duration,
                       easing: easing,
                       onChanged: onChanged,
                       option: option,
                       onEnd: nil)
    }

    @discardableResult
    static public func animate(props: [String],
                               from: [AnimatableValueType],
                               to: [AnimatableValueType],
                               duration: TimeInterval,
                               easing: Easing? = nil,
                               onChanged: ChangeFunction? = nil,
                               option: Option? = nil,
                               onEnd: EndFunction? = nil) -> ValueAnimator {
        let ani = ValueAnimator()
        ani.props = props
        for (i, p) in props.enumerated() {
            ani.initials[p] = from[i].toAnimatable()
            ani.changes[p] = to[i].toAnimatable() - from[i].toAnimatable()
        }
        ani.duration = duration
        if let easingFn = easing {
            ani.easing = easingFn
        }
        ani.endFunction = onEnd
        if let option = option {
            ani.yoyo = option.yoyo
            ani.repeatCount = option.repeatCount
            ani.delay = option.delay
            ani.isInfinitely = option.repeatInfinitely
        }
        if ani.yoyo && ani.repeatCount > 0 {
            ani.repeatCount *= 2
        }
        ani.changeFunction = onChanged
        ani.startTime = Date().timeIntervalSince1970

        aniList.insert(ani)
        if debug {
            print("ValueAnimator -----------: aniList added id: \(ani.hashValue)")
        }
        // start runLoop if not running
        if renderer == nil || renderer?.isFinished == true {
            renderer = Thread(target: self, selector: #selector(onProgress), object: nil)
            renderer?.name = "renderer"
            renderer?.qualityOfService = .userInteractive
            renderer?.start()
        }

        return ani
    }

    @objc
    static private func onProgress() {

        while renderer != nil && !renderer!.isFinished {
            let list = aniList
            if list.isEmpty {
                Thread.exit()
                break
            }
            for ani in list {
                update(ani)
            }
            Thread.sleep(forTimeInterval: sleepTime)
        }
        if debug {
            print("ValueAnimator nothing to animate")
        }
        Thread.exit()
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
        nowTime = Date().timeIntervalSince1970
        if !ani.isAnimating {
            ani.startTime = nowTime - ani.covered * 1000.0
            return
        }
        if ani.delay > 0 {
            ani.delay -= (nowTime - ani.startTime)
            ani.startTime = nowTime
            return
        }
        // 시간 계산
        ani.covered = nowTime - ani.startTime
        // repeating
        if ani.covered >= ani.duration {
            if ani.yoyo {
                if ani.repeatCount <= 0 || ani.repeatCount > ani.counted || ani.isInfinitely {
                    for p in ani.props {
                        if let initial = ani.initials[p],
                           let changeEnd = ani.changes[p] {
                            let changed = initial + changeEnd
                            change(ani, p, changed)
                            ani.initials[p] = changed
                            ani.changes[p]! *= -1.0
                        }
                    }
                    ani.startTime = nowTime
                    ani.counted += 1
                    return
                }
            }
            if ani.counted < ani.repeatCount || ani.isInfinitely {
                for p in ani.props {
                    if let initial = ani.initials[p] {
                        change(ani, p, initial)
                    }
                }
                ani.startTime = nowTime
                ani.counted += 1
                return
            }

            finish(ani)
        } else {
            // call updates in progress
            for p in ani.props {
                change(ani, p, ani.easing(ani.covered, ani.initials[p]!.value, ani.changes[p]!.value, ani.duration).toAnimatable())
            }
        }
    }

    static private func change(_ ani: ValueAnimator, _ p: String, _ v: ValueAnimatable) {
        if ani.callbackOnMainThread {
            DispatchQueue.main.async {
                ani.changeFunction?(p, v)
            }
        } else {
            ani.changeFunction?(p, v)
        }
    }

    /// finish animation and update value with target
    static private func finish(_ ani: ValueAnimator) {
        aniList.remove(ani)
        for p in ani.props {
            if let initial = ani.initials[p],
               let amount = ani.changes[p] {
                change(ani, p, initial + amount)
            }
        }
        ani.isAnimating = false
        ani.isFinished = true
        if ani.callbackOnMainThread {
            DispatchQueue.main.async {
                ani.endFunction?()
            }
        } else {
            ani.endFunction?()
        }
    }

    /// finish animation during animation
    static private func dispose(_ ani: ValueAnimator) {
        aniList.remove(ani)
        ani.isDisposed = true
        ani.isAnimating = false
    }
}
