//
//  DictWrapper.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 4/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

open class DictWrapper<T: Hashable> : Hashable {
    // TODO: Dict shouldn't be public; set up accessor methods
    public var dict: [T: Double] = [T:Double]()
    
    public init() {
        // Do nothing
    }
    
    public init(keys: [T]) {
        for key in keys {
            set(key:key, value: 1)
        }
    }

    public init(keys: [T], values: [Double]) {
        precondition(keys.count == values.count)
        
        for index in 0 ... keys.count-1 {
            set(key:keys[index], value: values[index])
        }
    }
    
    public init(list: [T]) {
        for x in list {
            incr(x)
        }
    }
    
    public init(dictWrapper: DictWrapper<T>) {
        self.dict = dictWrapper.dict // Deep copy as Dictionaries are structs
    }
    
    public static func == (lhs: DictWrapper<T>, rhs: DictWrapper<T>) -> Bool {
        return lhs.dict == rhs.dict
    }
        
    public func hash(into hasher: inout Hasher) {
        hasher.combine(dict)
    }

    
    /**
     Sets the freq/prob associated with the given key.
     */
    public func set(key: T, value: Double) {
        dict[key] = value
    }
    
    
    /**
     Gets the probability associated with the given key.  If the key isn't found, the value `defaultValue` is returned.
     */
    public func prob(_ key: T, defaultValue: Double = 0) -> Double {
        guard let value = dict[key] else {
            return defaultValue
        }
        return value
    }
    
    /**
     Increments the freq/prob associated with the value x.
    
     - Parameters:
        - x: number value
        - by: how much to increment by
     */
    public func incr(_ key:T, by term: Double = 1) {
        dict[key] = prob(key) + term
    }
    
    
    /**
     Scales the freq/prob associated with the given key by the specified factor.
     */
    public func mult(key: T, factor: Double) {
        guard let value = dict[key] else {
            return
        }
        
        dict[key] = value * factor
    }
    
    /**
     Returns the total of the frequencies/probabilities in the dict.
     */
    public func total() -> Double {
        var total: Double = 0.0
        
        for (key,value) in dict {
            total += value
            dict[key] = value
        }
        
        return total
    }
    
    /**
     Returns the dict to allow iteration through the key value pairs.
     
     - ToDo: A better implementation would return an array of labelled tuples.
    */
    public func items() -> [T:Double] {
        return dict
    }
    
    /**
     Returns the keys of the dictionary.  Why-oh-why is this method called
     "values" in the original ThinkBayes?
    */
    public func keys() -> Dictionary<T, Double>.Keys {
        return dict.keys
    }
    
}

extension DictWrapper where T: Comparable {
    /**
     Prints the dictionary's key and associated values.
     */
    public func print() {
        let sortedKeys = dict.keys.sorted()
        
        for key in sortedKeys {
            let value = dict[key]!
            Swift.print("\(key): \(value)")
        }
    }
}
