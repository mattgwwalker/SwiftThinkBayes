//
//  addends.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 19/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

func randomSum<T: Numeric>(_ dists: [Cdf<T>]) throws -> T {
    var total: T = 0
    
    for dist in dists {
        total += try dist.random()
    }
    
    return total
}
