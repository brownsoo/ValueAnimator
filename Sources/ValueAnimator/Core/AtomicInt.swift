//
//  AtomicInt.swift
//  ValueAnimator
//
//  Created on 2026. 3. 16..
//

import Foundation

/// A simple lock-free atomic integer using os_unfair_lock for thread-safe reads/writes.
final class AtomicInt: @unchecked Sendable {
    private var _value: Int
    private var _lock = os_unfair_lock()

    init(_ value: Int) {
        _value = value
    }

    func load() -> Int {
        os_unfair_lock_lock(&_lock)
        let v = _value
        os_unfair_lock_unlock(&_lock)
        return v
    }

    func store(_ newValue: Int) {
        os_unfair_lock_lock(&_lock)
        _value = newValue
        os_unfair_lock_unlock(&_lock)
    }
}
