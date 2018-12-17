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
    
    // Euto problem from Chapters 4.1--4.2 of Think Bayes
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
        XCTAssert(suite.mode() == 56)
        XCTAssert(abs(suite.mean() - 55.95) < 0.01)
        XCTAssert(suite.median() == 56)

        let cdf = suite.makeCdf()
        let credibleInterval = try cdf.credibleInterval(percentage: 90)
        XCTAssert(credibleInterval.low  ==  51)
        XCTAssert(credibleInterval.high ==  61)
        
        // As per section 4.2, calling prob at 50% isn't what you want
        XCTAssert(abs(suite.prob(50) - 0.021) < 0.001)
        
        
        // Section 4.3
        // ***********
        
        let triangleSuite = Euro()
        for x in 0...50 {
            triangleSuite.set(key: x, value: Double(x))
        }
        for x in 51...100 {
            triangleSuite.set(key: x, value: Double(x))
        }
        try triangleSuite.normalize()
        
        for data in dataset {
            try triangleSuite.update(data: data)
        }
        
        XCTAssert(triangleSuite.median() == 56)
        let triangleCdf = triangleSuite.makeCdf()
        let triangleCredibleInterval = try triangleCdf.credibleInterval(percentage: 90)
        XCTAssert(triangleCredibleInterval.low  ==  51)
        XCTAssert(triangleCredibleInterval.high ==  61)
        
        
        // Section 4.4
        // ***********
        
        let suite2 = Euro(sequence: hypos)
        try suite2.updateSet(dataset: dataset)
        
        XCTAssert(suite.maximumLikelihood() == 56)
        XCTAssert(suite.mode() == 56)
        XCTAssert(abs(suite.mean() - 55.95) < 0.01)
        XCTAssert(suite.median() == 56)
        
        let cdf2 = suite.makeCdf()
        let credibleInterval2 = try cdf2.credibleInterval(percentage: 90)
        XCTAssert(credibleInterval2.low  ==  51)
        XCTAssert(credibleInterval2.high ==  61)
    }
}
