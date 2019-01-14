//
//  TestSwiftStatsAvailability.swift
//  SwiftThinkBayesTests
//
//  Created by Matthew Walker on 12/01/19.
//  Copyright © 2019 Matthew Walker. All rights reserved.
//

import XCTest
import SwiftStats

class TestSwiftStatsAvailability: XCTestCase {
    let epsilon = 10e-7

    func testBasicAccessibility() {
        XCTAssert(abs(SwiftStats.Common.mean([1,2,3])! - 2.0) < epsilon)
    }
}
