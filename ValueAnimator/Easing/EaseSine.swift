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
    public static func easeIn() -> Easing {
        return { t, b, c, d in
            return -c * cos(t / d * (Double.pi / 2)) + c + b
        }
    }

    ///  The <code>easeOut()</code> method starts motion fast
    ///  and then decelerates motion to a zero velocity as it executes.
    public static func easeOut() -> Easing {
        return { t, b, c, d in
            return c * sin(t / d * (Double.pi / 2)) + b
        }
    }

    ///  The <code>easeInOut()</code> method combines the motion
    ///  of the <code>easeIn()</code> and <code>easeOut()</code> methods
    ///  to start the motion from a zero velocity, accelerate motion,
    ///  then decelerate to a zero velocity.
    public static func easeInOut() -> Easing {
        return { t, b, c, d in
            return -c / 2 * (cos(Double.pi * t / d) - 1) + b
        }
    }
}
