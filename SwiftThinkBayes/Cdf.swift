//
//  Cdf.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 13/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

public class Cdf<T: Comparable & Hashable> {
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
    public init(xs: [T], ps: [Double]) {
        self.xs = xs
        self.ps = ps
    }
    
    
    /**
     Makes a normalized Pmf from a Cdf object.
    
     - Parameters:
        - cdf: Cdf object
    
     - Returns: Pmf object
     */
    public func makePmf() -> Pmf<T> {
        let pmf = Pmf<T>()
        var prev = 0.0
        for i in 0 ..< ps.count {
            pmf.incr(xs[i], by: ps[i]-prev)
            prev = ps[i]
        }
        return pmf
    }
    
    
    /**
     Returns InverseCDF(p), the value that corresponds to probability p.
     
     - Parameters:
     - p: Proportion between 0 and 1, inclusive.
     */
    public func value(_ p: Double) throws -> T {
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
    public func percentile(percentage: Double) throws -> T {
        return try value(percentage / 100.0)
    }
    
    
    /**
     Computes the central credible interval.
    
     If percentage=90, computes the 90% CI.
    
     - Parameters:
     - percentage: float between 0 and 100
    
     - Returns: tuple of two floats, low and high
    */
    public func credibleInterval(percentage: Double) throws -> (low: T, high: T) {
        let prob = (1.0 - percentage / 100.0) / 2.0
        let interval = (low: try self.value(prob),
                        high: try self.value(1 - prob))
        return interval
    }
    
    
    /**
     Chooses a random value from this distribution.
     */
    public func random() throws -> T {
        return try value(Double.random(in: 0...1))
    }
    
    
    public func max(_ k: Int) -> Cdf<T> {
        var new_ps : [Double] = []
        for p in ps {
            new_ps.append(pow(p, Double(k)))
        }
        let cdf = Cdf(xs: xs, ps: new_ps)
        return cdf
    }
}
