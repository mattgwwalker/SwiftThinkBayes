//
//  binarySearch.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 13/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

/**
 Iterative version of binary search.
 
 Given a sorted array a, and a value, key, binarySearch() will return the
 index of the array where the key occurs.
 
 If the array does not contain the key, then the returned index will be an
 index higher than the index with the highest value not greater than the key.
 
 Why isn't this part of the Swift standard library?!
 
 Source: https://github.com/raywenderlich/swift-algorithm-club
 **/

public func binarySearch<T: Comparable>(_ a: [T], key: T) -> Int? {
    var lowerBound = 0
    var upperBound = a.count
    while lowerBound < upperBound {
        let midIndex = lowerBound + (upperBound - lowerBound) / 2
        if a[midIndex] == key {
            return midIndex
        } else if a[midIndex] < key {
            lowerBound = midIndex + 1
        } else {
            upperBound = midIndex
        }
    }
    
    // Modification by Matthew to allow non-exact key searches.
    // FIXME: Can this just return lowerbound, without checking for equality
    // with lower bound?
    if lowerBound == upperBound {
        return lowerBound
    }
    
    return nil
}
