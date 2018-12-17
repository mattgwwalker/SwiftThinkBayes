//
//  Cdf.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 13/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

class Cdf<T> {
    enum Errors : Error {
        case ProbabilityNotInRange
        case NoValues
        case BinarySearchFailure
    }

    let xs: [T]
    let ps: [Double]
    
    /**
     Initialises a cumulative distribution function.
     
     - Parameters:
     - xs: sequence of values
     - ps: sequence of probabilities, where the last value should be 1.0
     */
    init(xs: [T], ps: [Double]) {
        self.xs = xs
        self.ps = ps
    }
    
    /**
     Returns InverseCDF(p), the value that corresponds to probability p.
     
     - Parameters:
     - p: Proportion between 0 and 1, inclusive.
     */
    func value(_ p: Double) throws -> T {
        if p<0 || p>1 { throw Errors.ProbabilityNotInRange }
        
        if xs.isEmpty { throw Errors.NoValues }
        if p == 0 { return xs[0] }
        if p == 1 { return xs.last! }
        
        guard let index = binarySearch(ps, key: p) else {
            throw Errors.BinarySearchFailure
        }
        
        return xs[index]
    }
    
    /**
     Returns the value that corresponds to percentile p.
     
     - Parameters:
     - p: number in the range [0, 100]
     */
    func percentile(percentage: Double) throws -> T {
        return try value(percentage / 100.0)
    }
    
    
    /**
     Computes the central credible interval.
    
     If percentage=90, computes the 90% CI.
    
     - Parameters:
     - percentage: float between 0 and 100
    
     - Returns: tuple of two floats, low and high
    */
    func credibleInterval(percentage: Double) throws -> (low: T, high: T) {
        let prob = (1.0 - percentage / 100.0) / 2.0
        let interval = (low: try self.value(prob),
                        high: try self.value(1 - prob))
        return interval
    }
    
    
}
