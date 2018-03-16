// 
// Created by brownsoo han on 2018. 3. 12..
// from Adobe flash easing package
//

import Foundation

/// The Circular class defines three easing functions to implement motion.
/// The acceleration of motion for a Circular easing equation produces an abrupt change in velocity.
public class EaseCircular {
    /// The <code>easeIn()</code> method starts motion from zero velocity
    /// and then accelerates motion as it executes.
    ///
    /// - Parameters:
    ///   - t: Specifies the current time, between 0 and duration inclusive.
    ///   - b: Specifies the initial value of the animation property.
    ///   - c: Specifies the total change in the animation property.
    ///   - d: Specifies the duration of the motion.
    ///
    /// - Returns: The value of the interpolated property at the specified time.
    public func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t = t / d
        return -c * (sqrt(1 - t * t) - 1) + b
    }

    /// The <code>easeOut()</code> method starts motion fast
    /// and then decelerates motion to a zero velocity as it executes.
    ///
    /// - Parameters:
    ///   - t: Specifies the current time, between 0 and duration inclusive.
    ///   - b: Specifies the initial value of the animation property.
    ///   - c: Specifies the total change in the animation property.
    ///   - d: Specifies the duration of the motion.
    ///
    /// - Returns: The value of the interpolated property at the specified time.
    public func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        let t = t / d - 1
        return c * sqrt(1 - t * t) + b
    }

    /// The easeInOut method combines the motion of the easeIn and easeOut methos to start the motion from a zero velocity, accelerate motion, then decelerate to a zero velocity.
    ///
    /// - Parameters:
    ///   - t: Specifies the current time, between 0 and duration inclusive.
    ///   - b: Specifies the initial value of the animation property.
    ///   - c: Specifies the total change in the animation property.
    ///   - d: Specifies the duration of the motion.
    ///
    /// - Returns: The value of the interpolated property at the specified time.
    public func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        var t = t / (d / 2)
        if t < 1 {
            return -c / 2 * (sqrt(1 - t * t) - 1) + b
        }
        t = t - 2
        return c / 2 * (sqrt(1 - t * t) + 1) + b
    }
}
