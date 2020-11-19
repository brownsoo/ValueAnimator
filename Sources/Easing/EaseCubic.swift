// 
// Created by brownsoo han on 2018. 3. 15..
// from Adobe flash easing package

import Foundation

/// The acceleration of motion for a Cubic easing
/// equation is greater than for a Quadratic easing equation.
///
/// strength : Sine < Quadratic < Cubic < Quartic < Strong

public class EaseCubic {

    public static let strength = 3

    ///  The <code>easeIn()</code> method starts motion from zero velocity
    ///  and then accelerates motion as it executes.
    public static func easeIn() -> Easing {
        return { t, b, c, d in
            let t = t / d
            return c * t * t * t + b
        }
    }

    ///  The <code>easeOut()</code> method starts motion fast
    ///  and then decelerates motion to a zero velocity as it executes.
    public static func easeOut() -> Easing {
        return { t, b, c, d in
            let t = t / d - 1
            return c * (t * t * t + 1) + b
        }
    }

    ///  The <code>easeInOut()</code> method combines the motion
    ///  of the <code>easeIn()</code> and <code>easeOut()</code> methods
    ///  to start the motion from a zero velocity, accelerate motion,
    ///  then decelerate to a zero velocity.
    public static func easeInOut() -> Easing {
        return { t, b, c, d in
            var t = t / (d / 2)
            if t < 1 {
                return c / 2 * t * t * t + b
            }
            t = t - 2
            return c / 2 * (t * t * t + 2) + b
        }
    }

}
