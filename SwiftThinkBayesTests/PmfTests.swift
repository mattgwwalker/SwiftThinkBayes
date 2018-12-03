//
//  PmfTests.swift
//  SwiftThinkBayesTests
//
//  Created by Matthew Walker on 4/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import XCTest
@testable import SwiftThinkBayes


class PmfTests: XCTestCase {
    func testNormalize() {
        let pmf = Pmf<Int>()
        
        // Normalise should throw as the total is zero
        XCTAssert(pmf.total() == 0)
        XCTAssertThrowsError(try pmf.normalize())
    }
    
}
