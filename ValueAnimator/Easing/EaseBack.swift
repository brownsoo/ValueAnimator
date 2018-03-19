// 
// Created by brownsoo han on 2018. 3. 15..
// from Adobe flash easing package
//

import Foundation

/// The motion for going to over target and backing to target
public class EaseBack {

    ///  The <code>easeIn()</code> method starts
    ///  the motion by backtracking and
    ///  then reversing direction and moving toward the target.
    ///
    ///  - Parameters:
    ///    - overshoot: Specifies the amount of overshoot, where the higher the value,
    ///      the greater the overshoot.
    public static func easeIn(_ overshoot: Double = 1.70158) -> Easing {
        return { t, b, c, d in
            let t = t / d
            return c * t * t * ((overshoot + 1) * t - overshoot) + b
        }
    }

    ///  The <code>easeOut()</code> method starts the motion by
    ///  moving towards the target, overshooting it slightly,
    ///  and then reversing direction back toward the target.
    ///
    ///  - Parameters:
    ///    - overshoot: Specifies the amount of overshoot, where the higher the value,
    ///      the greater the overshoot.
    public static func easeOut(_ overshoot: Double = 1.70158) -> Easing {
        return { t, b, c, d in
            let t = t / d - 1
            return c * (t * t * ((overshoot + 1) * t + overshoot) + 1) + b
        }
    }

    ///  The <code>easeInOut()</code> method combines the motion
    ///  of the <code>easeIn()</code> and <code>easeOut()</code> methods
    ///  to start the motion by backtracking, then reversing direction and
    ///  moving toward the target, overshooting the target slightly, reversing
    ///  direction again, and then moving back toward the target.
    ///
    ///  - Parameters:
    ///    - overshoot: Specifies the amount of overshoot, where the higher the value,
    ///      the greater the overshoot.
    public static func easeInOut(_ overshoot: Double = 1.70158) -> Easing {
        return { t, b, c, d in
            var s = overshoot
            s = s * 1.525
            var t = t / (d / 2)
            if t < 1 {
                return c / 2 * (t * t * ((s + 1) * t - s)) + b
            }
            t = t - 2
            return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
        }
    }
}