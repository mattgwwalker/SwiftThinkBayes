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
    - dists: array of Cdf objects

 - returns: numerical sum
*/
public func randomSum<T: Numeric>(_ dists: [Cdf<T>]) throws -> T? {
    var total: T? = nil
    
    for dist in dists {
        if total == nil {
            total = try dist.random()
        } else {
            total! += try dist.random()
        }
    }
    
    return total
}

/**
 Draws a sample of sums from a list of distributions.

 - Parameters:
    - dists: array of Cdf objects
    - n: sample size

 - returns: new Pmf of sums
*/
public func sampleSum<T: Numeric>(_ dists: [Cdf<T>], _ n: Int) throws -> Pmf<T> {
    // Return an empty PMF if no distributions were passed in
    if dists.count == 0 {
        return Pmf<T>()
    }
    
    // Return an empty PMF if n isn't positive
    if n < 1 {
        return Pmf<T>()
    }
    
    var list: [T] = []
    
    for _ in 1 ... n {
        list.append( try randomSum(dists)! )
    }
    
    let pmf = try makePmfFromList(list: list)
    return pmf
}


/**
 Chooses a random value from each dist and returns the maximum.
 
 - Parameters:
 - dists: array of Cdf objects
 
 - returns: numerical maximum
 */
public func randomMax<T: Numeric & Comparable>(_ dists: [Cdf<T>]) throws -> T? {
    var max: T? = nil
    
    for dist in dists {
        if max == nil {
            max = try dist.random()
        } else {
            let result = try dist.random()
            if result > max! {
                max = result
            }
        }
    }
    
    return max
}


/**
 Draws a sample of maximums from a list of distributions.
 
 - Parameters:
 - dists: array of Cdf objects
 - n: sample size
 
 - returns: new Pmf of maximums
 */
public func sampleMax<T: Numeric>(_ dists: [Cdf<T>], _ n: Int) throws -> Pmf<T> {
    // Return an empty PMF if no distributions were passed in
    if dists.count == 0 {
        return Pmf<T>()
    }
    
    // Return an empty PMF if n isn't positive
    if n < 1 {
        return Pmf<T>()
    }
    
    var list: [T] = []
    
    for _ in 1 ... n {
        list.append( try randomMax(dists)! )
    }
    
    let pmf = try makePmfFromList(list: list)
    return pmf
}

/**
 Make a mixture distribution.

 - Parameters:
    - metapmf: Pmf that maps from Pmfs to probs.

 - Returns: Pmf object.
*/
public func makeMixture<T: Comparable & Hashable>(_ metapmf: Pmf<Pmf<T>>) -> Pmf<T> {
    let mix = Pmf<T>()

    for (pmf, weight) in metapmf.items() {
        for (x, p) in pmf.items() {
            mix.incr(x, by: weight * p)
        }
    }
    return mix
}
