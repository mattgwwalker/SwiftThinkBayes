//
//  DictWrapper.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 4/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

class DictWrapper<T: Hashable> {
    var dict: [T: Double] = [T:Double]()
    
    init() {
        // Do nothing
    }
    
    init(keys: [T]) {
        for key in keys {
            set(key:key, value: 1)
        }
    }

    init(keys: [T], values: [Double]) {
        precondition(keys.count == values.count)
        
        for index in 0 ... keys.count-1 {
            set(key:keys[index], value: values[index])
        }
    }

    
    /**
     Sets the freq/prob associated with the given key.
     */
    func set(key: T, value: Double) {
        dict[key] = value
    }
    
    
    /**
     Gets the probability associated with the given key.  If the key isn't found, the value `defaultValue` is returned.
     */
    func prob(_ key: T, defaultValue: Double = 0) -> Double {
        guard let value = dict[key] else {
            return defaultValue
        }
        return value
    }
    
    /**
     Increments the freq/prob associated with the value x.
    
     - Parameters:
        - x: number value
        - term: how much to increment by
     */
    func incr(_ key:T, term: Double = 1) {
        dict[key] = prob(key) + term
    }
    
    
    /**
     Scales the freq/prob associated with the given key by the specified factor.
     */
    func mult(key: T, factor: Double) {
        guard let value = dict[key] else {
            return
        }
        
        dict[key] = value * factor
    }
    
    /**
     Returns the total of the frequencies/probabilities in the dict.
     */
    func total() -> Double {
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
    func items() -> [T:Double] {
        return dict
    }
    
    /**
     Returns the keys of the dictionary.  Why-oh-why is this method called
     "values" in the original ThinkBayes?
    */
    func keys() -> Dictionary<T, Double>.Keys {
        return dict.keys
    }
}

