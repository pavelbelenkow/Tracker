//
//  CategoryObservable.swift
//  Tracker
//
//  Created by Pavel Belenkow on 31.07.2023.
//

import Foundation

@propertyWrapper
final class CategoryObservable<Value> {
    
    private var onChange: ((Value) -> Void)? = nil
    
    var wrappedValue: Value {
        didSet {
            onChange?(wrappedValue)
        }
    }
    
    var projectedValue: CategoryObservable<Value> { self }
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    func bind(action: @escaping (Value) -> Void) {
        self.onChange = action
    }
}
