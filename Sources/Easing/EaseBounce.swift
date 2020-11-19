// 
// Created by brownsoo han on 2018. 3. 15..
// from Adobe flash easing package
//

///  The Bounce class defines three easing functions to implement
///  bouncing motion with ActionScript animation, similar to a ball
///  falling and bouncing on a floor with several decaying rebounds.

import Foundation

public class EaseBounce {

    ///  The <code>easeIn()</code> method starts the bounce motion slowly
    ///  and then accelerates motion as it executes.
    public static func easeIn() -> Easing {
        return { t, b, c, d in
            return c - easeOut()(d - t, 0, c, d) + b
        }
    }

    ///  The <code>easeOut()</code> method starts the bounce motion fast
    ///  and then decelerates motion as it executes.
    public static func easeOut() -> Easing {
        return { t, b, c, d in
            let t = t / d
            if t < (1.0 / 2.75) {
                return c * (7.5625 * t * t) + b
            } else if t < (2.0 / 2.75) {
                let t = t - (1.5 / 2.75)
                return c * (7.5625 * t * t + 0.75) + b
            } else if t < (2.5 / 2.75) {
                let t = t - (2.25 / 2.75)
                return c * (7.5625 * t * t + 0.9375) + b
            } else {
                let t = t - (2.625 / 2.75)
                return c * (7.5625 * t * t + 0.984375) + b
            }
        }
    }

    ///  The <code>easeInOut()</code> method combines the motion
    ///  of the <code>easeIn()</code> and <code>easeOut()</code> methods
    ///  to start the bounce motion slowly, accelerate motion, then decelerate.
    public static func easeInOut() -> Easing {
        return { t, b, c, d in
            if t < d / 2 {
                return easeIn()(t * 2, 0, c, d) * 0.5 + b
            } else {
                return easeOut()(t * 2, 0, c, d) * 0.5 + c * 0.5 + b
            }
        }
    }
}