//
//  Suite.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 4/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

class Suite<DataType, HypoType: Hashable>: Pmf<HypoType> {
    enum Errors : Error {
        case UnimplementedMethod
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
