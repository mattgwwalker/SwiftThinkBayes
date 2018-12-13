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
        let hypos = Array(1...1000)
        
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

    
    // The alternative-prior locomotive problem from Chapter 3.4 of Think Bayes
    func testTrain3() throws {
        let hypos500  = Array(1...500)
        let hypos1000 = Array(1...1000)
        let hypos2000 = Array(1...2000)

        class Train : Suite<Int, Int> {
            init(hypos: [Int], alpha: Double = 1.0) throws {
                super.init(sequence: hypos)
                for hypo in hypos {
                    set(key: hypo, value: pow(Double(hypo), -alpha))
                }
                try normalize()
            }
            
            override func likelihood(data: Int, hypo: Int) throws -> Double {
                if hypo < data {
                    return 0
                } else {
                    return 1.0 / Double(hypo)
                }
            }
        }
        
        let suite500  = try Train(hypos: hypos500)
        let suite1000 = try Train(hypos: hypos1000)
        let suite2000 = try Train(hypos: hypos2000)
        
        let data = [30, 60, 90]
        
        for d in data {
            try suite500.update(data:d)
            try suite1000.update(data:d)
            try suite2000.update(data:d)
        }

        // Note the level of accuracy as the book only gives the result to zero
        // decimal places.
        XCTAssert(abs(suite500.mean()  - 131) < 0.5)
        XCTAssert(abs(suite1000.mean() - 133) < 0.5)
        XCTAssert(abs(suite2000.mean() - 134) < 0.5)
        
        
        // Section 3.5
        // ***********
        
        let interval = (suite2000.percentile(percentage: 5)!,
                        suite2000.percentile(percentage: 95)!)

        // These interval's types are Ints.
        XCTAssert(interval.0 == 91)
        XCTAssert(interval.1 == 243)
        
        
        // Section 3.6
        // ***********
        
        let cdf = suite2000.makeCdf()
        
        XCTAssert(try cdf.percentile(percentage: 5)  == 91)
        XCTAssert(try cdf.percentile(percentage: 95) == 243)
    }

}
