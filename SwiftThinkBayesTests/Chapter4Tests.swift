//
//  Chapter4Tests.swift
//  SwiftThinkBayesTests
//
//  Created by Matthew Walker on 13/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import XCTest
import SwiftThinkBayes

class Chapter4Tests: XCTestCase {
    let epsilon = 10e-7
    
    // Euro problem from Chapters 4.1--4.2 of Think Bayes
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
        let suite = Euro(hypos: hypos)
        
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

        let cdf = Cdf(pmf: suite)
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
        let triangleCdf = Cdf(pmf: triangleSuite)
        let triangleCredibleInterval = try triangleCdf.credibleInterval(percentage: 90)
        XCTAssert(triangleCredibleInterval.low  ==  51)
        XCTAssert(triangleCredibleInterval.high ==  61)
        
        
        // Section 4.4
        // ***********
        
        let suite2 = Euro(hypos: hypos)
        try suite2.updateSet(dataset: dataset)
        
        XCTAssert(suite.maximumLikelihood() == 56)
        XCTAssert(suite.mode() == 56)
        XCTAssert(abs(suite.mean() - 55.95) < 0.01)
        XCTAssert(suite.median() == 56)
        
        let cdf2 = Cdf(pmf: suite)
        let credibleInterval2 = try cdf2.credibleInterval(percentage: 90)
        XCTAssert(credibleInterval2.low  ==  51)
        XCTAssert(credibleInterval2.high ==  61)
        
        
        class Euro2 : Suite<(Int, Int), Int> {
            override func likelihood(data: (heads: Int, tails: Int),
                                     hypo: Int) throws -> Double {
                let x = Double(hypo) / 100.0
                let like = pow(x, Double(data.heads)) * pow(1-x, Double(data.tails))
                return like
            }
        }
        
        let suite3 = Euro2(hypos: hypos)
        try suite3.update(data: (heads:140, tails:110))
        
        XCTAssert(suite3.maximumLikelihood() == 56)
        XCTAssert(suite3.mode() == 56)
        XCTAssert(abs(suite3.mean() - 55.95) < 0.01)
        XCTAssert(suite3.median() == 56)
        
        let cdf3 = Cdf(pmf: suite3)
        let credibleInterval3 = try cdf3.credibleInterval(percentage: 90)
        XCTAssert(credibleInterval3.low  ==  51)
        XCTAssert(credibleInterval3.high ==  61)
    }
    
    func testBeta() throws {
        /*
         >>> import thinkbayes
         >>> beta = thinkbayes.Beta()
         >>> beta.Update((140,110))
         >>> print beta.Mean()
         0.559523809524
         */
        
        let beta = Beta()
        
        beta.update(data: (heads:140, tails:110))
        
        XCTAssert(abs(beta.mean() - 0.559523809524) < epsilon)
        
        /*
         >>> pmf = beta.MakePmf()
         >>> pmf.Prob(0.5)
         0.02097652612954467
         >>> pmf.Prob(0.55)
         0.1211673271600121
         */
        
        let pmf = try beta.makePmf()

        XCTAssert(abs(pmf.prob(0.5) - 0.02097652612954467) < epsilon)
        XCTAssert(abs(pmf.prob(0.55) - 0.1211673271600121) < epsilon)
    }
}
