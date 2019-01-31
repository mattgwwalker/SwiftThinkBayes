//
//  Chapter6Tests.swift
//  SwiftThinkBayesTests
//
//  Created by Matthew Walker on 27/01/19.
//  Copyright © 2019 Matthew Walker. All rights reserved.
//

import XCTest
import SwiftThinkBayes
import CSVImporter
import SwiftStats

func -(lhs: [Double], rhs: [Double]) -> [Double] {
    return operateOnTwoVectors(lhs, rhs, operation: -)
}

func operateOnTwoVectors<T>(_ lhs: [T], _ rhs:[T], operation: (_ lhs: T, _ rhs:T) -> T) -> [T] {
    let len = max(lhs.count, rhs.count)
    
    var results = [T]()
    
    for i in stride(from:0, to:len, by:1) {
        let lhsIndex = i % lhs.count
        let rhsIndex = i % rhs.count
        
        results.append(operation(lhs[lhsIndex], rhs[rhsIndex]))
    }
    
    return results
}



class Chapter6Tests: XCTestCase {
    // These tests have only medium fidelity to the results obtained with
    // Python.  This stems from the implementations of kernel density
    // estimation.  The scipy.stats.gaussian_kde() code uses a different
    // bandwidth selection algorithm to that of SwiftStats.  Visually however,
    // the results are quite similar.
    let epsilon = 10e-4

    func extractDataFromRow(_ row: [String]) -> [Double] {
        var result = [Double]()
        
        for i in 1 ..< row.count {
            if let asDouble = Double(row[i]) {
                result.append(asDouble)
            }
            else {
                print("Failed to convert \(row[i]) to Double")
            }
        }
        
        return result
    }
    
    func readDataFromFile(path: String) -> (showcase1: [Double],
                                            showcase2: [Double],
                                            bid1: [Double],
                                            bid2: [Double]) {
        let importer = CSVImporter<[String]>(path: path)
        
        let importedRecords = importer.importRecords{$0}
        
        var showcase1 = [Double]()
        var showcase2 = [Double]()
        var bid1 = [Double]()
        var bid2 = [Double]()

        for row in importedRecords {
            if row[0] == "Showcase 1" {
                showcase1 = extractDataFromRow(row)
            }
            else if row[0] == "Showcase 2" {
                showcase2 = extractDataFromRow(row)
            }
            else if row[0] == "Bid 1" {
                bid1 = extractDataFromRow(row)
            }
            else if row[0] == "Bid 2" {
                bid2 = extractDataFromRow(row)
            }
        }

        return (showcase1: showcase1,
                showcase2: showcase2,
                bid1: bid1,
                bid2: bid2)
    }
    
    func readData() -> (showcase1: [Double],
                        showcase2: [Double],
                        bid1: [Double],
                        bid2: [Double]) {
        let bundle = Bundle(for: type(of: self))
        let path1 = bundle.path(forResource: "showcases.2011", ofType: "csv")!
        let (showcase1A, showcase2A, bid1A, bid2A) = readDataFromFile(path: path1)
        
        let path2 = bundle.path(forResource: "showcases.2012", ofType: "csv")!
        let (showcase1B, showcase2B, bid1B, bid2B) = readDataFromFile(path: path2)
        
        return (showcase1: showcase1A+showcase1B,
                showcase2: showcase2A+showcase2B,
                bid1: bid1A+bid1B,
                bid2: bid2A+bid2B)
    }
    
    func seq(from: Double, through: Double, length: Double) -> [Double] {
        let range = through - from
        let stepSize = range / (length-1)
        
        var result = [Double]()
        
        for i in stride(from: from, through:through, by:stepSize) {
            result.append(i)
        }
        
        return result
    }
    
    
    func testEstimatedPdf() throws {
        // From ThinkBayes price.py
        // Showcase 1:
        // $30000.0 -> 0.04161278321066259
        // $37500.0 -> 0.019702858115113634
        //
        // Showcase 2:
        // $30000.0 -> 0.03836928577546672
        // $60000.0 -> 0.0005766869073060268

        
        // From section 6.4 of Think Bayes
        let (showcase1, showcase2, bid1, bid2) = readData()
        
        let pdf1 = EstimatedPdf(sample: showcase1)

        let xs = seq(from: 0, through: 75000, length: 101)
        let pmf1 = try pdf1?.makePmf(xs: xs)

        XCTAssert( abs(pmf1!.prob(30000) - 0.04161278321066259) < epsilon)
        XCTAssert( abs(pmf1!.prob(37500) - 0.019702858115113634) < epsilon)

        let pdf2 = EstimatedPdf(sample: showcase2)
        let pmf2 = try pdf2?.makePmf(xs: xs)
        
        XCTAssert( abs(pmf2!.prob(30000) - 0.03836928577546672) < epsilon)
        XCTAssert( abs(pmf2!.prob(60000) - 0.0005766869073060268) < epsilon)
        
        // From section 6.5 of Think Bayes
        // "The first contestant overbids 25% of the time"
        let diff1 = showcase1 - bid1
        let overbid1 = diff1.map {$0 < 0 ? 1.0 : 0.0}
        let sum1 = overbid1.reduce(0, +)
        let mean1 = sum1 / Double(diff1.count)
        XCTAssert( abs(mean1 - 0.25) < 0.5)
        
        // "The second contestant overbids 29% of the time"
        let diff2 = showcase2 - bid2
        let overbid2 = diff2.map {$0 < 0 ? 1.0 : 0.0}
        let sum2 = overbid2.reduce(0, +)
        let mean2 = sum2 / Double(diff2.count)
        XCTAssert( abs(mean2 - 0.29) < 0.5)
        
    }
    
    class Player {
        let pdfPrice : EstimatedPdf
        let cdfDiff: Cdf<Double>
        let pdfError: GaussianPdf
        
        // Can return nil if there are insufficient prices to form a kernel
        // density estimation
        init?(prices: [Double], bids: [Double]) {
            let diffs = prices - bids
            
            guard let guardedPdfPrice = EstimatedPdf(sample: prices) else {
                return nil
            }
            self.pdfPrice = guardedPdfPrice
            self.cdfDiff = Cdf(list: diffs)
            
            let mu = 0.0
            guard let sigma = SwiftStats.Common.sd(diffs) else {
                return nil
            }
            self.pdfError = GaussianPdf(mu: mu, sigma: sigma)
        }
        
        func errorDensity(_ error: Double) -> Double {
            return pdfError.density(error)
        }
    }
    
    class Price : Suite<Double, Double> {
        let player: Player
        
        init(pmf: Pmf<Double>, player: Player) {
            self.player = player
            super.init(prior: pmf)
        }
        
        override func likelihood(data: Double, hypo: Double) throws -> Double {
            let price = hypo
            let guess = data
            
            let error = price - guess
            let like = player.errorDensity(error)
            
            return like
        }
        
    }
}
