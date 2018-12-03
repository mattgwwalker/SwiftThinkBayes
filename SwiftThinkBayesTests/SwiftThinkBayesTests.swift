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
    let epsilson = 10e-7
    
    func testSection2_2() {
        let pmf = Pmf<String>()
        
        pmf.set(id: "Bowl 1", value: 0.5)
        let result = pmf.dict["Bowl 1"]
        guard result != nil else {
            XCTFail()
            return
        }
        
        XCTAssert(abs(result! - 0.5) < epsilson )
    }
}
