// 
// Created by brownsoo han on 2018. 3. 15..
// from Adobe flash easing package

import Foundation

/// The acceleration of motion for a Sine
/// easing equation is less than that for a Quadratic equation.
///
/// strength : Sine < Quadratic < Cubic < Quartic < Strong

public class EaseSine {

    public static let strength = 1

    ///  The <code>easeIn()</code> method starts motion from zero velocity
    ///  and then accelerates motion as it executes.
    ///
    ///  - Parameters:
    ///    - t: Specifies the current time, between 0 and duration inclusive.
    ///    - b: Specifies the initial value of the animation property.
    ///    - c: Specifies the total change in the animation property.
    ///    - d: Specifies the duration of the motion.
    ///
    ///  - Returns: The value of the interpolated property at the specified time.
    public static func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        return -c * cos(t / d * (Double.pi / 2)) + c + b
    }

    ///  The <code>easeOut()</code> method starts motion fast
    ///  and then decelerates motion to a zero velocity as it executes.
    ///
    ///  - Parameters:
    ///    - t: Specifies the current time, between 0 and duration inclusive.
    ///    - b: Specifies the initial value of the animation property.
    ///    - c: Specifies the total change in the animation property.
    ///    - d: Specifies the duration of the motion.
    ///
    ///  - Returns: The value of the interpolated property at the specified time.
    public static func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c * sin(t / d * (Double.pi / 2)) + b
    }

    ///  The <code>easeInOut()</code> method combines the motion
    ///  of the <code>easeIn()</code> and <code>easeOut()</code> methods
    ///  to start the motion from a zero velocity, accelerate motion,
    ///  then decelerate to a zero velocity.
    ///
    ///  - Parameters:
    ///    - t: Specifies the current time, between 0 and duration inclusive.
    ///    - b: Specifies the initial value of the animation property.
    ///    - c: Specifies the total change in the animation property.
    ///    - d: Specifies the duration of the motion.
    ///
    ///  - Returns: The value of the interpolated property at the specified time.
    public static func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        return -c / 2 * (cos(Double.pi * t / d) - 1) + b
    }
}
