//
// Created by brownsoo han on 2018. 3. 12..
//

import Foundation
#if canImport(QuartzCore)
import QuartzCore
#endif

public class ValueAnimator: Hashable, @unchecked Sendable {

    public struct Option {
        public let yoyo: Bool
        public let repeatCount: Int
        public let delay: TimeInterval
        public let repeatInfinitely: Bool
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

    public func hash(into hasher: inout Hasher) {
        hasher.combine(objectIdentifier)
    }

    // MARK: - Internal state (mutated only by AnimationEngine)

    internal var props = [String]()
    internal var startTime: TimeInterval = 0
    internal var initials = [String: ValueAnimatable]()
    internal var changes = [String: ValueAnimatable]()
    /// animation duration of one cycle in seconds
    public internal(set) var duration: TimeInterval = 1
    /// seconds covered on timeline
    public internal(set) var covered: TimeInterval = 0
    /// seconds to delay
    public internal(set) var delay: TimeInterval = 0
    /// yoyo animation
    public internal(set) var yoyo = false
    /// how many it repeat animation.
    public internal(set) var repeatCount: Int = 0
    /// animated count
    public internal(set) var counted: Int = 0 {
        didSet {
            if ValueAnimator.debug {
                print("ValueAnimator- \(props)-- counted: \(counted)")
            }
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
    public internal(set) var isInfinitely = false
    public internal(set) var isAnimating = false
    public internal(set) var isFinished = false
    public internal(set) var isDisposed = false

    /// callback for animation updates
    public var changeCallback: ChangeFunction? = nil

    /// callback for animation finishes
    public var endCallback: EndFunction? = nil

    public var callbackOnMainThread: Bool = true

    public static func ==(left: ValueAnimator, right: ValueAnimator) -> Bool {
        return left.objectIdentifier == right.objectIdentifier
    }

    internal init() {
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

    // MARK: - Static API (delegates to AnimationEngine)

    static public var debug = false

    @available(*, deprecated, message: "frameRate is ignored when using CADisplayLink. Only affects watchOS TimerDriver.")
    static public var frameRate: Int = 60

    static public var count: Int {
        AnimationEngine.shared.animationCount.load()
    }

    static public func finishAll() {
        Task { await AnimationEngine.shared.finishAll() }
    }

    static public func disposeAll() {
        Task { await AnimationEngine.shared.disposeAll() }
    }

    static public func hasAnimation(_ prop: String) async -> Bool {
        await AnimationEngine.shared.hasAnimation(prop)
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
        ani.endCallback = onEnd
        if let option = option {
            ani.yoyo = option.yoyo
            ani.repeatCount = option.repeatCount
            ani.delay = option.delay
            ani.isInfinitely = option.repeatInfinitely
        }
        if ani.yoyo && ani.repeatCount > 0 {
            ani.repeatCount *= 2
        }
        ani.changeCallback = onChanged
        ani.startTime = CACurrentMediaTime()

        Task { await AnimationEngine.shared.add(ani) }

        return ani
    }
}
