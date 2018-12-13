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
    
    init(xs: [T], ps: [Double]) {
        self.xs = xs
        self.ps = ps
    }
    
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
    
    func percentile(percentage: Double) throws -> T {
        return try value(percentage / 100.0)
    }
}
