//
//  Easing.swift
//  ValueAnimator
//
//  Created by brownsoo han on 2018. 3. 19..
//

/// Easing method
///
/// - Parameters:
///   - t: Specifies the current time, between 0 and duration inclusive.
///   - b: Specifies the initial value of the animation property.
///   - c: Specifies the total change in the animation property.
///   - d: Specifies the duration of the motion.
/// - Returns: The value of the interpolated property at the specified time.
public typealias Easing = (_ t: Double, _ b: Double, _ c: Double, _ d: Double) -> Double
