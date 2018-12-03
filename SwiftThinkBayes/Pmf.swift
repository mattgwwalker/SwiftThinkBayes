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
    
    func set(id: T, value: Double) {
        dict[id] = value
    }

}

class Pmf<T: Hashable>: DictWrapper<T> {
}
