// 
// Created by brownsoo han on 2018. 3. 15..
// from Adobe flash easing package
//

import Foundation

/// The motion for going to over target and backing to target
public class EaseBack {

    private var overshoot: (() -> Double)? = nil

    /// - overshoot: Specifies the amount of overshoot, where the higher the value,
    ///  the greater the overshoot.
    public init(_ overshoot: (() -> Double)? = nil) {
        self.overshoot = overshoot
    }

    ///  The <code>easeIn()</code> method starts
    ///  the motion by backtracking and
    ///  then reversing direction and moving toward the target.
    ///
    ///  - Parameters:
    ///    - t Specifies the current time, between 0 and duration inclusive.
    ///    - b Specifies the initial value of the animation property.
    ///    - c Specifies the total change in the animation property.
    ///    - d Specifies the duration of the motion.
    ///
    ///  - Returns: The value of the interpolated property at the specified time.
    public func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        let s = overshoot?() ?? Double(1.70158)
        let t = t / d
        return c * t * t * ((s + 1) * t - s) + b
    }

    ///  The <code>easeOut()</code> method starts the motion by
    ///  moving towards the target, overshooting it slightly,
    ///  and then reversing direction back toward the target.
    ///
    ///  - Parameters:
    ///    - t Specifies the current time, between 0 and duration inclusive.
    ///    - b Specifies the initial value of the animation property.
    ///    - c Specifies the total change in the animation property.
    ///    - d Specifies the duration of the motion.
    ///
    ///  - Returns: The value of the interpolated property at the specified time.
    public func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        let s = overshoot?() ?? Double(1.70158)
        let t = t / d - 1
        return c * (t * t * ((s + 1) * t + s) + 1) + b
    }

    ///  The <code>easeInOut()</code> method combines the motion
    ///  of the <code>easeIn()</code> and <code>easeOut()</code> methods
    ///  to start the motion by backtracking, then reversing direction and
    ///  moving toward the target, overshooting the target slightly, reversing
    ///  direction again, and then moving back toward the target.
    ///
    ///  - Parameters:
    ///    - t Specifies the current time, between 0 and duration inclusive.
    ///    - b Specifies the initial value of the animation property.
    ///    - c Specifies the total change in the animation property.
    ///    - d Specifies the duration of the motion.
    ///
    ///  - Returns: The value of the interpolated property at the specified time.
    public func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        var s = overshoot?() ?? Double(1.70158)
        s = s * 1.525
        var t = t / (d / 2)
        if t < 1 {
            return c / 2 * (t * t * ((s + 1) * t - s)) + b
        }
        t = t - 2
        return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
    }
}