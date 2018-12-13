//
//  CdfTests.swift
//  SwiftThinkBayesTests
//
//  Created by Matthew Walker on 13/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import XCTest
@testable import SwiftThinkBayes


class CdfTests: XCTestCase {

    func testEmptyCdf() {
        let cdf = Cdf<Character>(xs:[], ps:[])
        
        // The proportion passed to value() should be between 0 and 1 inclusive
        XCTAssertThrowsError(try cdf.value(-1))
        XCTAssertThrowsError(try cdf.value(2))
        
        // If the CDF is empty, there aren't any values
        XCTAssertThrowsError(try cdf.value(0))
    }

    func testCdfWithOneValue() {
        let cdf = Cdf<Character>(xs:["A"], ps:[1])

        XCTAssert(try cdf.value(0) == "A")
        XCTAssert(try cdf.value(0.5) == "A")
        XCTAssert(try cdf.value(1) == "A")
    }

    func testCdfWithTwoValues() {
        let cdf = Cdf<Character>(xs:["A", "B"], ps:[0,1])
        
        XCTAssert(try cdf.value(0) == "A")
        XCTAssert(try cdf.value(0.5) == "B") // Tested against ThinkBayes Python result
        XCTAssert(try cdf.value(1) == "B")
    }

    func testCdf() {
        /* Tested against ThinkBayes Python:
         
         >>> xs = ["A","B","C","D","E"]
         >>> ps = [0.1, 0.2, 0.3, 0.8, 1]
         >>> cdf = thinkbayes.Cdf(xs, ps)
         >>> cdf.Value(0)
         'A'
         >>> cdf.Value(0.099)
         'A'
         >>> cdf.Value(0.101)
         'B'
         >>> cdf.Value(0.2)
         'B'
         >>> cdf.Value(0.201)
         'C'
         >>> cdf.Value(0.35)
         'D'
         >>> cdf.Value(0.801)
         'E'
         >>> cdf.Value(1)
         'E'
         */
 
        
        let cdf = Cdf<Character>(xs:["A", "B", "C", "D", "E"],
                                 ps:[0.1, 0.2, 0.3, 0.8, 1])
        
        XCTAssert(try cdf.value(0) == "A")
        XCTAssert(try cdf.value(0.099) == "A")
        XCTAssert(try cdf.value(0.101) == "B")
        XCTAssert(try cdf.value(0.2) == "B")
        XCTAssert(try cdf.value(0.201) == "C")
        XCTAssert(try cdf.value(0.35) == "D")
        XCTAssert(try cdf.value(0.801) == "E")
        XCTAssert(try cdf.value(1) == "E")
    }

}
