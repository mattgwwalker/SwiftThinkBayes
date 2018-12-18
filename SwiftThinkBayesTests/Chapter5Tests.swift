//
//  Chapter5Tests.swift
//  SwiftThinkBayesTests
//
//  Created by Matthew Walker on 18/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import XCTest
@testable import SwiftThinkBayes


class Chapter5Tests: XCTestCase {
    let epsilon = 10e-7

    // Chapter 5.1 of Think Bayes
    func testOdds() {
        // "If 20% of them think my horse will win, then 80% don't, so the odds
        // in favor are 20:80 or 1:4."
        XCTAssert(abs(odds(0.2) - 1/4) < epsilon)

        // "If I think my team has a 75% chance of winning, I would say that the
        // odds in favor are three to one, because the chance of winning is
        // three times the chance of losing."
        XCTAssert(abs(probability(3) - 0.75) < epsilon)

        // "If the odds are 5:1 against my horse, then five out of six people
        // think she will lose, so the probability of winning is 1/6."
        XCTAssert(abs(probability2(yes:1, no:5) - 1/6) < epsilon)
    }
    
    func testAddends() throws {
        class Die : Pmf<Int> {
            init(sides: Int) throws {
                super.init()
                for side in 1 ... sides {
                    set(key:side, value:1)
                }
                try normalize()
            }
        }
        
        let d6 = try Die(sides: 6)
        
    }
}
