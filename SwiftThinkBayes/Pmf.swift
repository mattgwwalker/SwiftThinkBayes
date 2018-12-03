//
//  Pmf.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 3/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

class DictWrapper<T: Hashable> {
    var dict: [T: Double] = [T:Double]()
    
    /**
     Sets the freq/prob associated with the given key.
    */
    func set(key: T, value: Double) {
        dict[key] = value
    }
    
    /**
     Scales the freq/prob associated with the given key.
     */
    func mult(key: T, factor: Double) {
        guard let value = dict[key] else {
            return
        }
        
        dict[key] = value * factor
    }

}

class Pmf<T: Hashable>: DictWrapper<T> {
}
