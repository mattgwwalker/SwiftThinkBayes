//
//  Chapter3Tests.swift
//  SwiftThinkBayesTests
//
//  Created by Matthew Walker on 13/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import XCTest
@testable import SwiftThinkBayes


class Chapter3Tests: XCTestCase {
    let epsilon = 10e-7

    // Multi-sided dice problem from Chapter 3.1 of Think Bayes
    func testDice() throws {
        class Dice: Suite<Int, Int> {
            override func likelihood(data: Int, hypo: Int) throws -> Double {
                if hypo < data {
                    return 0
                } else {
                    return 1.0 / Double(hypo)
                }
            }
        }
        
        let suite = Dice(sequence: [4, 6, 8, 12, 20])
        try suite.update(data: 6)
        
        XCTAssert(abs(suite.prob(4)  - 0) < epsilon)
        XCTAssert(abs(suite.prob(6)  - 0.392156862745) < epsilon)
        XCTAssert(abs(suite.prob(8)  - 0.294117647059) < epsilon)
        XCTAssert(abs(suite.prob(12) - 0.196078431373) < epsilon)
        XCTAssert(abs(suite.prob(20) - 0.117647058824) < epsilon)
        
        for roll in [6,8,7,7,5,4] {
            try suite.update(data: roll)
        }
        
        XCTAssert(abs(suite.prob(4)  - 0) < epsilon)
        XCTAssert(abs(suite.prob(6)  - 0) < epsilon)
        XCTAssert(abs(suite.prob(8)  - 0.943248453672) < epsilon)
        XCTAssert(abs(suite.prob(12) - 0.0552061280613) < epsilon)
        XCTAssert(abs(suite.prob(20) - 0.0015454182665) < epsilon)
    }
    
    // The locomotive problem from Chapter 3.2 of Think Bayes
    func testTrain() throws {
        let hypos = Array(0...1000)
        
        class Train : Suite<Int, Int> {
            override func likelihood(data: Int, hypo: Int) throws -> Double {
                if hypo < data {
                    return 0
                } else {
                    return 1.0 / Double(hypo)
                }
            }
        }
        
        let suite = Train(sequence: hypos)
        try suite.update(data:60)
        
        func mean(_ suite: Suite<Int, Int>) -> Double {
            var total: Double = 0
            for (hypo, prob) in suite.items() {
                total += Double(hypo) * prob
            }
            return total
        }
        
        // Note the level of accuracy as the book only gives the result to zero
        // decimal places.
        XCTAssert(abs(mean(suite) - 333) < 0.5)
        XCTAssert(abs(suite.mean() - 333) < 0.5)
    }
}
