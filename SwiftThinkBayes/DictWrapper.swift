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
    
    /**
     Sets the freq/prob associated with the given key.
     */
    func set(key: T, value: Double) {
        dict[key] = value
    }
    
    /**
     Gets the probability associated with the given key.  If the key isn't found, the value `defaultValue` is returned.
     */
    func prob(key: T, defaultValue: Double = 0) -> Double {
        guard let value = dict[key] else {
            return defaultValue
        }
        return value
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
    
}

