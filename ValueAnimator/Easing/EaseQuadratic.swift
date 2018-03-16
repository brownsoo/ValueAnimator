// 
// Created by brownsoo han on 2018. 3. 15..
// from Adobe flash easing package

import Foundation

///  The acceleration of motion for a Quadratic easing equation
///  is the same as for a timeline tween at 100% easing
///  and is less dramatic than for the Cubic easing equation.
///
/// strength : Sine < Quadratic < Cubic < Quartic < Strong

public class EaseQuadratic {

    public static let strength = 2

    ///  The <code>easeIn()</code> method starts motion from a zero velocity
    ///  and then accelerates motion as it executes.
    ///
    ///  - Parameters:
    ///    - t: Specifies the current time, between 0 and duration inclusive.
    ///    - b: Specifies the initial value of the animation property.
    ///    - c: Specifies the total change in the animation property.
    ///    - d: Specifies the duration of the motion.
    ///  - Returns: The value of the interpolated property at the specified time.
    public func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t = t / d
        return c * t * t + b
    }

    ///  The <code>easeOut()</code> method starts motion fast
    ///  and then decelerates motion to a zero velocity as it executes.
    ///
    ///  - Parameters:
    ///    - t: Specifies the current time, between 0 and duration inclusive.
    ///    - b: Specifies the initial value of the animation property.
    ///    - c: Specifies the total change in the animation property.
    ///    - d: Specifies the duration of the motion.
    ///  - Returns: The value of the interpolated property at the specified time.
    public func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t = t / d
        return -c * t * (t - 2) + b
    }

    ///  The <code>easeInOut()</code> method combines the motion
    ///  of the <code>easeIn()</code> and <code>easeOut()</code> methods
    ///  to start the motion from a zero velocity,
    ///  accelerate motion, then decelerate to a zero velocity.
    ///
    ///  - Parameters:
    ///    - t: Specifies the current time, between 0 and duration inclusive.
    ///    - b: Specifies the initial value of the animation property.
    ///    - c: Specifies the total change in the animation property.
    ///    - d: Specifies the duration of the motion.
    ///  - Returns: The value of the interpolated property at the specified time.
    public func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        var t = t / (d / 2)
        if t < 1 {
            return c / 2 * t * t + b
        }
        t -= 1
        return -c / 2 * (t * (t - 2) - 1) + b
    }
}
