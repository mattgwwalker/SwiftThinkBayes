//
//  Pmf.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 3/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

open class Pmf<T: Hashable>: DictWrapper<T> {
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
    public func normalize(fraction: Double = 1.0) throws -> Double {
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
    
    
    /**
     Returns the value with the highest probability.
     */
    public func mode() -> T? {
        var max : Double? = nil
        var maxKey : T? = nil
        
        for (key, value) in dict {
            if max == nil || value > max! {
                max = value
                maxKey = key
            }
        }
        
        return maxKey
    }
    
    public func maximumLikelihood() -> T? {
        return mode()
    }
    
}




extension Pmf where T: Comparable {
    /**
     Computes a percentile of a given Pmf.
     
     Note: this is not super efficient.  If you are planning
     to compute more than a few percentiles, compute the Cdf.
     
     - Parameters:
     - percentage: floating point value between 0 and 100, inclusive.
     
     - Returns: value from the Pmf
     */
    public func percentile(percentage: Double) -> T? {
        // TODO: Should check that percentage is within range and that
        // the dict is not empty.
        let p = percentage / 100
        var total = 0.0
        for (key, prob) in dict.sorted(by: { $0.key < $1.key }) {
            total += prob
            if total >= p {
                return key
            }
        }
        // TODO: What if we get here?
        return nil
    }
    
    public func median() -> T? {
        return percentile(percentage: 50)
    }

    

}


extension Pmf where T: BinaryInteger {
    /*** Computes the mean of a PMF.
     */
    public func mean() -> Double {
        var mu = 0.0
        for (x, p) in dict {
            mu += p * Double(x)
        }
        return mu
    }
    
    public func add(_ other: Pmf<T>) -> Pmf<T> {
        let pmf = Pmf<T>()
        for (v1, p1) in dict {
            for (v2, p2) in other.dict {
                pmf.incr(v1+v2, by: p1*p2)
            }
        }
        
        return pmf
    }
    
    public static func +(left: Pmf<T>, right: Pmf<T>) -> Pmf<T> {
        return left.add(right)
    }
    
    public func max(_ other: Pmf<T>) -> Pmf<T> {
        let pmf = Pmf<T>()
        for (v1, p1) in dict {
            for (v2, p2) in other.dict {
                pmf.incr(Swift.max(v1, v2), by: p1*p2)
            }
        }
        
        return pmf
    }
}

// Why on earth can this not be merged with the method defintion above?  It
// seems that Swift's "where" clause could do with an "or" operator.
extension Pmf where T: BinaryFloatingPoint {
    /*** Computes the mean of a PMF.
     */
    public func mean() -> Double {
        var mu = 0.0
        for (x, p) in dict {
            mu += p * Double(x)
        }
        return mu
    }
    
    public func add(_ other: Pmf<T>) -> Pmf<T> {
        let pmf = Pmf<T>()
        for (v1, p1) in dict {
            for (v2, p2) in other.dict {
                pmf.incr(v1+v2, by: p1*p2)
            }
        }
        
        return pmf
    }
    
    public static func +(left: Pmf<T>, right: Pmf<T>) -> Pmf<T> {
        return left.add(right)
    }
    
    public func max(_ other: Pmf<T>) -> Pmf<T> {
        let pmf = Pmf<T>()
        for (v1, p1) in dict {
            for (v2, p2) in other.dict {
                pmf.incr(Swift.max(v1, v2), by: p1*p2)
            }
        }
        
        return pmf
    }
}



/**
 Initialisation to convert a list of non-unique keys into a histogram
 */
func makePmfFromList<T: Hashable & Comparable>(list: [T]) throws -> Pmf<T> {
    let pmf = Pmf<T>()
    
    for x in list {
        pmf.incr(x)
    }
    
    try pmf.normalize()
    
    return pmf
}


