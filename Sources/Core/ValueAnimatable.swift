//
//  ValueAnimatable.swift
//  ValueAnimator
//
//  Created by hyonsoo han on 2018. 4. 3..
//  Copyright © 2018년 hansoo-labs. All rights reserved.
//

import CoreGraphics // CGFloat
import Foundation

public protocol AnimatableValueType {
    func toAnimatable() -> ValueAnimatable
}

public struct ValueAnimatable {
    public var value: Double

    public init(_ value: Int) {
        self.value = Double(value)
    }

    public init(_ value: Float) {
        self.value = Double(value)
    }

    public init(_ value: CGFloat) {
        self.value = Double(value)
    }

    public init(_ value: Double) {
        self.value = value
    }

    public var timeInterval: Foundation.TimeInterval {
        return TimeInterval(value)
    }
}

extension ValueAnimatable {
    public var cg: CGFloat {
        return CGFloat(value)
    }
    public var i: Int {
        return Int(value)
    }
    public var f: Float {
        return Float(value)
    }
    public var d: Double {
        return value
    }
}

extension ValueAnimatable: Hashable {

    public static func ==(lhs: ValueAnimatable, rhs: ValueAnimatable) -> Bool {
        return lhs.value == rhs.value
    }
    #if swift(<4.0)
    var hashValue: Int {
        return self.timeInterval
    }
    #endif

}

extension ValueAnimatable {

    public static func <(lhs: ValueAnimatable, rhs: ValueAnimatable) -> Bool {
        return lhs.value < rhs.value
    }

    public static func <=(lhs: ValueAnimatable, rhs: ValueAnimatable) -> Bool {
        return lhs.value <= rhs.value
    }

    public static func >(lhs: ValueAnimatable, rhs: ValueAnimatable) -> Bool {
        return lhs.value >= rhs.value
    }

    public static func >=(lhs: ValueAnimatable, rhs: ValueAnimatable) -> Bool {
        return lhs.value >= rhs.value
    }
}

extension ValueAnimatable {

    public prefix static func -(lhs: ValueAnimatable) -> ValueAnimatable {
        return ValueAnimatable(-lhs.value)
    }

    public static func +(lhs: ValueAnimatable, rhs: ValueAnimatable) -> ValueAnimatable {
        let inValue = lhs.value + rhs.value
        return ValueAnimatable(inValue)
    }

    public static func -(lhs: ValueAnimatable, rhs: ValueAnimatable) -> ValueAnimatable {
        return lhs + (-rhs)
    }

    public static func +=(lhs: inout ValueAnimatable, rhs: ValueAnimatable) {
        lhs = lhs + rhs
    }

    public static func -=(lhs: inout ValueAnimatable, rhs: ValueAnimatable) {
        lhs = lhs - rhs
    }

    public static func *=(lhs: inout ValueAnimatable, rhs: Double) {
        lhs = lhs * rhs
    }

    public static func *(lhs: ValueAnimatable, rhs: Double) -> ValueAnimatable {
        return ValueAnimatable(lhs.value * rhs)
    }

    public static func /(lhs: ValueAnimatable, rhs: Double) -> ValueAnimatable {
        return ValueAnimatable(lhs.value / rhs)
    }
}

extension Int: AnimatableValueType {
    public func toAnimatable() -> ValueAnimatable {
        return ValueAnimatable(self)
    }
}

extension Float: AnimatableValueType {
    public func toAnimatable() -> ValueAnimatable {
        return ValueAnimatable(self)
    }
}

extension CGFloat: AnimatableValueType {
    public func toAnimatable() -> ValueAnimatable {
        return ValueAnimatable(self)
    }
}

extension Double: AnimatableValueType {
    public func toAnimatable() -> ValueAnimatable {
        return ValueAnimatable(self)
    }
}
