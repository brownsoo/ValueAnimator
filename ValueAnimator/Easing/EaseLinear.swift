// 
// Created by brownsoo han on 2018. 3. 12..
// from Adobe flash easing package

public class EaseLinear {
    
    /// The easeNone method defines a constant motion with no acceleration.
    public static func easeNone() -> Easing {
        return { t, b, c, d in
            return c * t / d + b
        }
    }
    
    /// The easeIn method defines a constant motion with no acceleration.
    public static func easeIn() -> Easing {
        return { t, b, c, d in
            return c * t / d + b
        }
    }
    /// The easeOut method defines a constant motion with no acceleration.
    public static func easeOut() -> Easing {
        return { t, b, c, d in
            return c * t / d + b
        }
    }
    /// The easeNone method defines a constant motion with no acceleration.
    public static func easeInOut() -> Easing {
        return { t, b, c, d in
            return c * t / d + b
        }
    }
}
