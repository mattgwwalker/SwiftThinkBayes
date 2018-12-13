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
    
    // Modification by Matthew
    if lowerBound == upperBound {
        return lowerBound
    }
    
    return nil
}
