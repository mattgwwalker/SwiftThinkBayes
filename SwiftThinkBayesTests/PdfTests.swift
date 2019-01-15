//
//  PdfTests.swift
//  SwiftThinkBayesTests
//
//  Created by Matthew Walker on 15/01/19.
//  Copyright © 2019 Matthew Walker. All rights reserved.
//

import XCTest
import SwiftStats
@testable import SwiftThinkBayes

class PdfTests: XCTestCase {
    let epsilon = 10e-7

    func testGaussianPdf() {
        /* R code:
         > dnorm(0, mean=0, sd=1)
         [1] 0.3989423
         */
        
        let distribution = SwiftStats.Distributions.Normal(mean: 0, sd: 1)
        XCTAssert(abs(distribution.pdf(0) - 0.3989423) < epsilon)
        
        let gaussianPdf = GaussianPdf(mu: 0, sigma: 1)
        XCTAssert(abs(gaussianPdf.density(0) - 0.3989423) < epsilon)
    }
}
