//
//  SwiftThinkBayesTests.swift
//  SwiftThinkBayesTests
//
//  Created by Matthew Walker on 3/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import XCTest
@testable import SwiftThinkBayes

class SwiftThinkBayesTests: XCTestCase {
    let epsilon = 10e-7
    
    func testSection2_2() throws {
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
        let posterior = pmf.prob(key: "Bowl 1")
        XCTAssert(abs(posterior - 0.6) < epsilon)
    }
}
