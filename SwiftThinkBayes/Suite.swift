//
//  Suite.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 4/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

class Suite<DataType, HypoType: Hashable & Comparable>: Pmf<HypoType> {
    enum Errors : Error {
        case UnimplementedMethod
    }
    
    override init() {
        super.init()
    }
    
    init(hypos: [HypoType]) {
        super.init(keys: hypos)
    }

    init(hypos: [HypoType], probs: [Double]) {
        super.init(keys: hypos, values: probs)
    }

    
    /**
     Updates each hypothesis based on the data.
    
     - Parameters:
       - data: any representation of the data
    
     - Returns: the normalizing constant
    */
    @discardableResult
    func update(data: DataType) throws -> Double {
        for hypo in keys() {
            let like = try likelihood(data: data, hypo: hypo)
            mult(key: hypo, factor: like)
        }
        return try normalize()
    }
    
    /**
     Updates each hypothesis based on the dataset.
     
     This is more efficient than calling Update repeatedly because
     it waits until the end to Normalize.
     
     Modifies the suite directly; if you want to keep the original, make
     a copy.
     
     - Parameters:
     - dataset: a sequence of data
     
     - Returns: the normalizing constant
     */
    @discardableResult
    func updateSet(dataset: [DataType]) throws -> Double {
        for data in dataset {
            for hypo in keys() {
                let like = try likelihood(data: data, hypo: hypo)
                mult(key: hypo, factor: like)
            }
        }
        return try normalize()
    }
    
    /**
     Computes the likelihood of the data under the hypothesis.
    
     - Parameters:
       - hypo: some representation of the hypothesis
       - data: some representation of the data
    */
    func likelihood(data: DataType, hypo: HypoType) throws -> Double {
        throw Errors.UnimplementedMethod
    }
    
    /**
     Prints the hypotheses and their probabilities
     */
    func print() {
        for (hypo, prob) in dict {
            Swift.print("\(hypo): \(prob)")
        }
    }
}
