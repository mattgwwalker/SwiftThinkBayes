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
    
    // Chapter 5.4 of Think Bayes
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
        
        let d6_cdf = d6.makeCdf()
        let dice = [d6_cdf, d6_cdf, d6_cdf]

        let three = try sampleSum(dice, 1000)
        
        let mean = three.mean()
        XCTAssert( abs(mean - 10.5) < 1) // mean is ~10.5.
        
        let three_exact = d6 + d6 + d6
        XCTAssert( abs(three_exact.mean() - 10.5) < epsilon) // mean is 10.5.
    }
    
    // Chapter 5.5 of Think Bayes
    func testMaxima() throws {
        class Die : Pmf<Int> {
            init(sides: Int) throws {
                super.init()
                for side in 1 ... sides {
                    set(key:side, value:1)
                }
                try normalize()
            }
        }
        
        // Create a six-sided die
        let d6 = try Die(sides: 6)
        let d6_cdf = d6.makeCdf()

        // Simulation:
        // ***********

        // Roll three six-sided dice
        let dice = [d6_cdf, d6_cdf, d6_cdf]
        let three = try sampleSum(dice, 1000)
        let three_cdf = three.makeCdf()
        
        // Find the maximum of six rolls of three six-sided dice (one roll for
        // each of the six character attributes).
        let max_three = try sampleMax([three_cdf, three_cdf, three_cdf,
                                       three_cdf, three_cdf, three_cdf], 1000)

        // Test that the mean is approximately 14.23.
        let mean = max_three.mean()
        print("mean 1:", mean)
        XCTAssert( abs(mean - 14.23) < 1)
        
        // Enumeration:
        // ************
        
        // Given identical distributions, it's more efficient to convert to
        // CDFs and call max(); see the following section.  However if the two
        // distributions aren't identical then this option might be the best
        // choice.
        
        // Enumerate the probabilities for rolling three six-sided dice
        let three_exact = d6 + d6 + d6
        let three_exact_cdf = three_exact.makeCdf()
        
        // Enumerate the probabilities for the maximum of six times rolling
        // three six-sided dice
        let max_attributes_exact = three_exact.max(three_exact).max(three_exact)
            .max(three_exact).max(three_exact).max(three_exact)

        let mean2 = max_attributes_exact.mean()
        XCTAssert( abs(mean2 - 14.23311854) < epsilon)

        
        // Exponentiation:
        // ***************
        
        // Enumerate the probabilities for the six character attributes
        let max_attributes_exact2 = three_exact_cdf.max(6)
        let max_attributes_exact2_pmf = max_attributes_exact2.makePmf()
        let mean3 = max_attributes_exact2_pmf.mean()
        XCTAssert( abs(mean3 - 14.23311854) < epsilon)
    }

}
