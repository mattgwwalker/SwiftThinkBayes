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

        // There's no data, so total should be zero
        XCTAssert(pmf.total() == 0)
        
        // Normalise should throw as the total is zero
        XCTAssertThrowsError(try pmf.normalize())
    }
    
}
