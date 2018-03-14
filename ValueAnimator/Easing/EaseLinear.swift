// 
// Created by brownsoo han on 2018. 3. 12..
//

public class EaseLinear {
    /// The easeNone method defines a constant motion with no acceleration.
    ///
    /// - Parameters:
    ///   - t: Specifies the current time, between 0 and duration inclusive.
    ///   - b: Specifies  the initial value of the animation property.
    ///   - c: Specifies the total change in the animation property.animation
    ///   - d: Specifies the duration of the motion.
    /// - Returns: The value of the interpolated property at the specified time.
    static func easeNone(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c * t / d + b
    }
    
    /// The easeIn method defines a constant motion with no acceleration.
    ///
    /// - Parameters:
    ///   - t: Specifies the current time, between 0 and duration inclusive.
    ///   - b: Specifies  the initial value of the animation property.
    ///   - c: Specifies the total change in the animation property.animation
    ///   - d: Specifies the duration of the motion.
    /// - Returns: The value of the interpolated property at the specified time.
    static func easeIn(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c * t / d + b
    }
    /// The easeOut method defines a constant motion with no acceleration.
    ///
    /// - Parameters:
    ///   - t: Specifies the current time, between 0 and duration inclusive.
    ///   - b: Specifies  the initial value of the animation property.
    ///   - c: Specifies the total change in the animation property.animation
    ///   - d: Specifies the duration of the motion.
    /// - Returns: The value of the interpolated property at the specified time.
    static func easeOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c * t / d + b
    }
    /// The easeNone method defines a constant motion with no acceleration.
    ///
    /// - Parameters:
    ///   - t: Specifies the current time, between 0 and duration inclusive.
    ///   - b: Specifies  the initial value of the animation property.
    ///   - c: Specifies the total change in the animation property.animation
    ///   - d: Specifies the duration of the motion.
    /// - Returns: The value of the interpolated property at the specified time.
    static func easeInOut(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c * t / d + b
    }
}
