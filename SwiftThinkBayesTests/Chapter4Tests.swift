//
//  Chapter4Tests.swift
//  SwiftThinkBayesTests
//
//  Created by Matthew Walker on 13/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import XCTest
@testable import SwiftThinkBayes

class Chapter4Tests: XCTestCase {
    let epsilon = 10e-7
    
    func testEuro() throws {
        class Euro : Suite<Character, Int> {
            override func likelihood(data: Character, hypo: Int) throws -> Double {
                let x = hypo
                if data == "H" {
                    return Double(x) / 100.0
                } else {
                    return 1 - Double(x)/100.0
                }
            }
        }
        
        let hypos = Array(0...100)
        let suite = Euro(sequence: hypos)
        
        let heads = Array(repeating: Character("H"), count: 140)
        let tails = Array(repeating: Character("T"), count: 110)
        let dataset = heads + tails
        
        for data in dataset {
            try suite.update(data: data)
        }
        
        XCTAssert(suite.maximumLikelihood() == 56)
    }

}
