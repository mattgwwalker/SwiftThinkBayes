//
//  Beta.swift
//  SwiftThinkBayes
//
//  Created by Matthew Walker on 18/12/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation

/**
 Represents a Beta distribution.

 See http://en.wikipedia.org/wiki/Beta_distribution
*/
class Beta {
    enum Errors : Error {
        case NotImplemented
    }
    
    var alpha: Double
    var beta: Double
    
    /**
     Initializes a Beta distribution.
     */
    init(alpha: Double = 1, beta: Double = 1) {
        self.alpha = alpha
        self.beta = beta
    }

    /**
     Updates a Beta distribution.
    
     - Parameters:
     - data: pair of int (heads, tails)
     */
    func update(data: (heads: Double, tails: Double)) {
        alpha += data.heads
        beta += data.tails
    }

    /**
     Computes the mean of this distribution.
     */
    func mean() -> Double {
        return alpha / (alpha + beta)
    }


    /**
     Evaluates the PDF at x.
     */
    func evalPdf(_ x: Double) -> Double {
        return pow(x, alpha - 1) * pow(1 - x, beta - 1)
    }

    /**
     Returns a Pmf of this distribution.
    
     Note: Normally, we just evaluate the PDF at a sequence
     of points and treat the probability density as a probability
     mass.
    
     But if alpha or beta is less than one, we have to be
     more careful because the PDF goes to infinity at x=0
     and x=1.  In that case we evaluate the CDF and compute
     differences.
     */
    func makePmf(steps: Int = 100) throws -> Pmf<Double> {
        if alpha < 1 || beta < 1 {
            throw Errors.NotImplemented
            /*
            let cdf = makeCdf()
            let pmf = cdf.makePmf()
            return pmf
             */
        }

        var xs: [Double] = []
        for i in 0 ... steps {
            xs.append( Double(i) / Double(steps) )
        }

        var probs: [Double] = []
        for x in xs {
            probs.append( evalPdf(x) )
        }

        let pmf = Pmf<Double>(keys: xs, values: probs)
        try pmf.normalize()
        return pmf
    }

    /**
     Returns the CDF of this distribution.
     */
    /*
    func makeCdf(steps: Int = 100) -> Cdf<Double> {
        var xs: [Double] = []
        for i in 0 ... steps {
            xs.append( Double(i) / Double(steps) )
        }
        

        // The problem in porting this code is that we don't have access to
        // scipy.spcial.betainc.
        let ps = [scipy.special.betainc(self.alpha, self.beta, x) for x in xs]
        let cdf = Cdf(xs, ps)
        return cdf
    }
    */
}
