//
//  Pmf.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 3/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

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
    @discardableResult
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

extension Pmf where T: BinaryInteger {
    /*** Computes the mean of a PMF.
     */
    func mean() -> Double {
        var mu = 0.0
        for (x, p) in dict {
            mu += p * Double(x)
        }
        return mu
    }
}

// Why on earth can this be merged with the method defintion above?  It seems
// that Swift's "where" clause could do with an "or" operator.
extension Pmf where T: BinaryFloatingPoint {
    /*** Computes the mean of a PMF.
     */
    func mean() -> Double {
        var mu = 0.0
        for (x, p) in dict {
            mu += p * Double(x)
        }
        return mu
    }
}
