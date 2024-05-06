//
//  DebounceState+Extension.swift
//  PodOuvir
//
//  Created by ProDoctor on 06/05/24.
//

import Foundation
import SwiftUI
import Combine

@propertyWrapper
private struct DebouncedState<Value>: DynamicProperty {

    @StateObject private var backingState: BackingState<Value>
    
    init(initialValue: Value, delay: Double = 0.3) {
        self.init(wrappedValue: initialValue, delay: delay)
    }
    
    init(wrappedValue: Value, delay: Double = 0.3) {
        self._backingState = StateObject(wrappedValue: BackingState<Value>(originalValue: wrappedValue, delay: delay))
    }
    
    var wrappedValue: Value {
        get {
            backingState.debouncedValue
        }
        nonmutating set {
            backingState.currentValue = newValue
        }
    }
    
    public var projectedValue: Binding<Value> {
        Binding {
            backingState.currentValue
        } set: {
            backingState.currentValue = $0
        }
    }
    
    @Observable
    private class BackingState<T> {
        var currentValue: T
        var debouncedValue: T

        init(originalValue: T, delay: Double) {
            _currentValue = originalValue
            _debouncedValue = originalValue
            currentValue
                .debounce(for: .seconds(delay), scheduler: RunLoop.main)
                .assign(to: &$debouncedValue)
        }
    }
}
