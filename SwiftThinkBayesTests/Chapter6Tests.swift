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

class Chapter6Tests: XCTestCase {
    // These tests have only medium fidelity to the results obtained with
    // Python.  This stems from the implementations of kernel density
    // estimation.  The scipy.stats.gaussian_kde() code uses a different
    // bandwidth selection algorithm to that of SwiftStats.  Visually however,
    // the results are quite similar.
    let epsilon = 10e-4

    func extractShowcaseFromRow(_ row: [String]) -> [Double] {
        var result = [Double]()
        
        for i in 1 ..< row.count {
            if let asDouble = Double(row[i]) {
                result.append(asDouble)
            }
            else {
                print("Failed to convert \(row[i]) to Int")
            }
        }
        
        return result
    }
    
    func readDataFromFile(path: String) -> (showcase1: [Double],
                                            showcase2: [Double]) {
        let importer = CSVImporter<[String]>(path: path)
        
        let importedRecords = importer.importRecords{$0}
        
        var showcase1 = [Double]()
        var showcase2 = [Double]()
        for row in importedRecords {
            if row[0] == "Showcase 1" {
                showcase1 = extractShowcaseFromRow(row)
            }
            else if row[0] == "Showcase 2" {
                showcase2 = extractShowcaseFromRow(row)
            }
        }

        return (showcase1: showcase1, showcase2: showcase2)
    }
    
    func readData() -> (showcase1: [Double], showcase2: [Double]) {
        let bundle = Bundle(for: type(of: self))
        let path1 = bundle.path(forResource: "showcases.2011", ofType: "csv")!
        let (showcase1A, showcase2A) = readDataFromFile(path: path1)
        
        let path2 = bundle.path(forResource: "showcases.2012", ofType: "csv")!
        let (showcase1B, showcase2B) = readDataFromFile(path: path2)
        
        return (showcase1: showcase1A+showcase1B,
                showcase2: showcase2A+showcase2B)
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

        
        let (showcase1, showcase2) = readData()
        
        let pdf1 = EstimatedPdf(sample: showcase1)

        let xs = seq(from: 0, through: 75000, length: 101)
        let pmf1 = try pdf1?.makePmf(xs: xs)

        XCTAssert( abs(pmf1!.prob(30000) - 0.04161278321066259) < epsilon)
        XCTAssert( abs(pmf1!.prob(37500) - 0.019702858115113634) < epsilon)

        let pdf2 = EstimatedPdf(sample: showcase2)
        let pmf2 = try pdf2?.makePmf(xs: xs)
        
        XCTAssert( abs(pmf2!.prob(30000) - 0.03836928577546672) < epsilon)
        XCTAssert( abs(pmf2!.prob(60000) - 0.0005766869073060268) < epsilon)
    }
}
