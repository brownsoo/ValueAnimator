// 
// Created by brownsoo han on 2018. 3. 15..
// from Adobe flash easing package

import Foundation

/// the motion is defined by an exponentially decaying sine wave.
public class EaseElastic {

    ///  The <code>easeIn()</code> method starts motion slowly
    ///  and then accelerates motion as it executes.
    ///
    ///  - Parameters:
    ///    - amplitude: Specifies the amplitude of the sine wave.
    ///    - period: Specifies the period of the sine wave.
    public static func easeIn(_ period: Double = 0, _ amplitude: Double = 0) -> Easing {
        return { t, b, c, d in
            if t == 0 {
                return b
            }
            var t = t / d
            if t == 1 {
                return b + c
            }
            var p = period
            if p == 0 {
                p = d * 0.3
            }
            var a = amplitude
            var s: Double
            if a == 0 || a < abs(c) {
                a = c
                s = p / 4
            } else {
                s = p / (2 * Double.pi) * asin(c / a)
            }
            t = t - 1
            return -(a * pow(2, 10 * t)
                * sin((t * d - s) * (2 * Double.pi) / p)) + b
        }

    }

    ///  The <code>easeOut()</code> method starts motion fast
    ///  and then decelerates motion as it executes.
    ///
    ///  - Parameters:
    ///    - amplitude: Specifies the amplitude of the sine wave.
    ///    - period: Specifies the period of the sine wave.
    public static func easeOut(_ period: Double = 0, _ amplitude: Double = 0) -> Easing {
        return { t, b, c, d in
            if t == 0 {
                return b
            }
            let t = t / d
            if t == 1 {
                return b + c
            }
            var p = period
            if p == 0 {
                p = d * 0.3
            }
            var a = amplitude
            var s: Double
            if a == 0 || a < abs(c) {
                a = c
                s = p / 4
            } else {
                s = p / (2 * Double.pi) * asin(c / a)
            }
            return a * pow(2, -10 * t)
                * sin((t * d - s) * (2 * Double.pi) / p) + c + b
        }
    }

    ///  The <code>easeInOut()</code> method combines the motion
    ///  of the <code>easeIn()</code> and <code>easeOut()</code> methods
    ///  to start the motion slowly, accelerate motion, then decelerate.
    ///
    ///  - Parameters:
    ///    - amplitude: Specifies the amplitude of the sine wave.
    ///    - period: Specifies the period of the sine wave.
    public static func easeInOut(_ period: Double = 0, _ amplitude: Double = 0) -> Easing {
        return { t, b, c, d in
            if t == 0 {
                return b
            }
            var t = t / (d / 2)
            if t == 2 {
                return b + c
            }
            var p = period
            if p == 0 {
                p = d * (0.3 * 1.5)
            }
            var a = amplitude
            var s: Double
            if a == 0 || a < abs(c) {
                a = c
                s = p / 4
            } else {
                s = p / (2 * Double.pi) * asin(c / a)
            }
            t = t - 1
            if t < 1 {
                return -0.5 * (a * pow(2, 10 * t)
                    * sin((t * d - s) * (2 * Double.pi) / p)) + b
            }
            return a * pow(2, -10 * t)
                * sin((t * d - s) * (2 * Double.pi) / p) * 0.5 + c + b
        }
    }
}
