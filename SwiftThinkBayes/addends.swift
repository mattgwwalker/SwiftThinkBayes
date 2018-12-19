//
//  addends.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 19/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

/**
 Chooses a random value from each dist and returns the sum.

 - Parameters:
    - dists: sequence of Pmf or Cdf objects

 - returns: numerical sum
*/
func randomSum<T: Numeric>(_ dists: [Cdf<T>]) throws -> T {
    var total: T = 0
    
    for dist in dists {
        total += try dist.random()
    }
    
    return total
}

/**
 Draws a sample of sums from a list of distributions.

 - Parameters:
    - dists: sequence of Cdf objects
    - n: sample size

 - returns: new Pmf of sums
*/
func sampleSum<T: Numeric>(_ dists: [Cdf<T>], _ n: Int) throws -> Pmf<T> {
    var list: [T] = []
    
    for _ in 1 ... n {
        list.append( try randomSum(dists) )
    }
    
    let pmf = try makePmfFromList(list: list)
    return pmf
}
