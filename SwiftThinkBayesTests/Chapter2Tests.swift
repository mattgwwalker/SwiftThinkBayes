//
//  SwiftThinkBayesTests.swift
//  SwiftThinkBayesTests
//
//  Created by Matthew Walker on 3/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import XCTest
@testable import SwiftThinkBayes

class Chapter2Tests: XCTestCase {
    let epsilon = 10e-7

    // Tests based on code in Section 2.2 of Think Bayes
    func testCookie() throws {
        let pmf = Pmf<String>()
        
        pmf.set(key: "Bowl 1", value: 0.5)
        guard let result1 = pmf.dict["Bowl 1"] else {
            XCTFail()
            return
        }
        XCTAssert(abs(result1 - 0.5) < epsilon )
        
        pmf.set(key: "Bowl 2", value: 0.5)
        guard let result2 = pmf.dict["Bowl 2"] else {
            XCTFail()
            return
        }
        XCTAssert(abs(result2 - 0.5) < epsilon )
        
        pmf.mult(key: "Bowl 1", factor: 0.75)
        guard let result3 = pmf.dict["Bowl 1"] else {
            XCTFail()
            return
        }
        XCTAssert(abs(result3 - 0.5*0.75) < epsilon )

        pmf.mult(key: "Bowl 2", factor: 0.5)
        guard let result4 = pmf.dict["Bowl 2"] else {
            XCTFail()
            return
        }
        XCTAssert(abs(result4 - 0.5*0.5) < epsilon )
        
        let total = pmf.total()
        XCTAssert(abs(total - (0.5*0.75 + 0.5*0.5)) < epsilon)

        // Normalise
        let before = try pmf.normalize()
        XCTAssert(abs(before - (0.5*0.75 + 0.5*0.5)) < epsilon)
        XCTAssert(abs(pmf.total() - 1) < epsilon, "Total after normalization should be 1.0")

        // Posterior
        let posterior = pmf.prob("Bowl 1")
        XCTAssert(abs(posterior - 0.6) < epsilon)
    }
    
    // Tests based on section 2.3 of Think Bayes
    func testCookie2() throws {
        class Cookie: Pmf<String> {
            init(_ hypos: [String]) throws {
                super.init()
                
                for hypo in hypos {
                    set(key: hypo, value: 1)
                }
                
                try normalize()
            }
            
            func update(_ data: String) throws {
                for hypo in keys() {
                    let like = likelihood(data: data, hypo: hypo)
                    mult(key: hypo, factor: like)
                }
                try normalize()
            }
            
            let mixes: [String:[String:Double]] =
                ["Bowl 1":["vanilla":0.75, "chocolate":0.25],
                 "Bowl 2":["vanilla":0.5,  "chocolate":0.5]]

            func likelihood(data: String, hypo: String) -> Double {
                // Note that the original ThinkBayes does not handle the cases
                // of hypo and data not being found in the dictionaries.
                // We've assumed that returning zero is reasonable.
                guard let mix = mixes[hypo] else {
                    return 0
                }
                guard let like = mix[data] else {
                    return 0
                }
                return like
            }
        }
        
        let hypos = ["Bowl 1", "Bowl 2"]
        let pmf = try Cookie(hypos)
        try pmf.update("vanilla")
        
        for (hypo, prob) in pmf.dict {
            print("\(hypo): \(prob)")
        }
        
        XCTAssert(abs(pmf.prob("Bowl 1") - 0.6) < epsilon)
        XCTAssert(abs(pmf.prob("Bowl 2") - 0.4) < epsilon)
    }

}
