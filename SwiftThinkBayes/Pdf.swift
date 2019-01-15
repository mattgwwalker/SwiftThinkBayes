//
//  Pdf.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 15/01/19.
//  Copyright © 2019 Matthew Walker. All rights reserved.
//

import Foundation
import SwiftStats

public protocol Pdf {
    func density(_ x: Double) -> Double
}

extension Pdf {
    public func makePmf(xs: [Double]) throws -> Pmf<Double> {
        let pmf = Pmf<Double>()
        for x in xs {
            pmf.set(key: x, value: density(x))
        }
        try pmf.normalize()
        return pmf
    }
}


public class GaussianPdf : Pdf {
    let mu: Double
    let sigma: Double
    let distribution: SwiftStats.Distributions.Normal
    
    public init(mu: Double, sigma: Double) {
        self.mu = mu
        self.sigma = sigma
        
        self.distribution = SwiftStats.Distributions.Normal(mean: mu, sd: sigma)
    }
    
    public func density(_ x: Double) -> Double {
        return distribution.pdf(x)
    }
}
