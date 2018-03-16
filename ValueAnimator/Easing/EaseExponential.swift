// 
// Created by brownsoo han on 2018. 3. 15..
// from Adobe flash easing package
//

import Foundation

///  It produces an effect similar to the popular
///  "Zeno's paradox" style of scripted easing,
///  where each interval of time decreases the remaining
///  distance by a constant proportion.
public class EaseExponential {
    ///  The <code>easeIn()</code> method starts motion slowly
    ///  and then accelerates motion as it executes.
    ///
    ///  - Parameters:
    ///    - t: Specifies the current time, between 0 and duration inclusive.
    ///    - b: Specifies the initial position of a component.
    ///    - c: Specifies the total change in position of the component.
    ///    - d: Specifies the duration of the effect, in milliseconds.
    ///
    ///  - Returns: Number corresponding to the position of the component.
    public func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        if t == 0 {
            return b
        }
        return c * pow(2, 10 * (t / d - 1)) + b
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
    public func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        if t == d {
            return b + c
        }
        return c * (-pow(2, -10 * t / d) + 1) + b
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
    public func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        if t == 0 {
            return 0
        }
        if t == d {
            return b + c
        }
        var t = t / (d / 2)
        if t < 1 {
            return c / 2 * pow(2, 10 * (t - 1)) + b
        }
        t -= 1
        return c / 2 * (-pow(2, -10 * t) + 2) + b
    }
}