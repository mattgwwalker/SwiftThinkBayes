//
//  SwiftThinkBayesTests.swift
//  SwiftThinkBayesTests
//
//  Created by Matthew Walker on 3/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import XCTest
import SwiftThinkBayes

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
    
    // Tests based on the Monty Hall problem (section 2.4 of Think Bayes)
    func testMonty() throws {
        class Monty: Pmf<Character> {
            init(_ hypos: String) throws {
                super.init()
                
                for hypo in hypos {
                    set(key: hypo, value: 1)
                }
                
                try normalize()
            }
            
            func update(_ data: Character) throws {
                for hypo in keys() {
                    let like = likelihood(data: data, hypo: hypo)
                    mult(key: hypo, factor: like)
                }
                try normalize()
            }
            
            func likelihood(data: Character, hypo: Character) -> Double {
                if hypo == data {
                    return 0
                } else if hypo == "A" {
                    return 0.5
                } else {
                    return 1
                }
            }
        }
        
        let hypos = "ABC"
        let pmf = try Monty(hypos)
        try pmf.update("B")
        
        for (hypo, prob) in pmf.dict {
            print("\(hypo): \(prob)")
        }
        
        XCTAssert(abs(pmf.prob("A") - 0.3333333) < epsilon)
        XCTAssert(abs(pmf.prob("B") - 0.0) < epsilon)
        XCTAssert(abs(pmf.prob("C") - 0.6666667) < epsilon)
    }

    // Tests Monty Hall problem implemented with the class Suite
    func testMonty2() throws {
        class Monty: Suite<Character, Character> {
            override func likelihood(data: Character, hypo: Character) -> Double {
                if hypo == data {
                    return 0
                } else if hypo == "A" {
                    return 0.5
                } else {
                    return 1
                }
            }
        }
        
        let suite = Monty(hypos: Array("ABC"))
        try suite.update(data: "B")
        suite.print()
        
        XCTAssert(abs(suite.prob("A") - 0.3333333) < epsilon)
        XCTAssert(abs(suite.prob("B") - 0.0) < epsilon)
        XCTAssert(abs(suite.prob("C") - 0.6666667) < epsilon)
    }
    
    func testMAndM() throws {
        class M_and_M : Suite<(String,String),String> {
            let hypotheses : [String : [String: [String:Int]]]
            
            override init(hypos: [String]) {
                let mix94 = ["Brown":30,
                             "Yellow":20,
                             "Red":20,
                             "Green":10,
                             "Orange":10,
                             "Tan":10]
                
                let mix96 = ["Blue":24,
                             "Green":20,
                             "Orange":16,
                             "Yellow":14,
                             "Red":13,
                             "Brown":13]
                
                let hypoA = ["Bag 1":mix94, "Bag 2":mix96]
                let hypoB = ["Bag 1":mix96, "Bag 2":mix94]
                
                self.hypotheses = ["A":hypoA, "B":hypoB]
                
                super.init(hypos: hypos)
            }
            
            override func likelihood(data: (String,String), hypo: String) throws -> Double {
                let (bag, color) = data
                let hypothesis = hypotheses[hypo]!
                let mix = hypothesis[bag]!
                let like = Double(mix[color]!)
                return like
            }
        }
        
        let suite = M_and_M(hypos: ["A", "B"])
        try suite.update(data: ("Bag 1", "Yellow"))
        try suite.update(data: ("Bag 2", "Green"))
        
        suite.print()
        
        XCTAssert(abs(suite.prob("A") - 0.740740740741) < epsilon)
        XCTAssert(abs(suite.prob("B") - 0.259259259259) < epsilon)
    }
}
