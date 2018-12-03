//
//  Pmf.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 3/12/18.
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
     Scales the freq/prob associated with the given key.
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

class Pmf<T: Hashable>: DictWrapper<T> {
    enum Errors : Error {
        case TotalProbabilityZero
    }
    
    /**
     Normalizes this PMF so the sum of all probs is fraction.
     
     - Parameters:
     -fraction: what the total should be after normalization
     
     - Returns: the total probability before normalizing
     
     - Throws: `Errors.TotalProbabilityZero` is thrown if, before normalization, the sum of all the probabilities is zero
     */
    func normalize(fraction: Double = 1.0) throws -> Double {
        let sum = total()
        
        if sum == 0 {
            throw Errors.TotalProbabilityZero
        }
        
        let factor = fraction / sum
        
        for (key,value) in dict {
            dict[key] = value * factor
        }
        
        return sum
    }
}
