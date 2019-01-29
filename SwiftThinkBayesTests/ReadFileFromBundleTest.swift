//
//  ReadFileFromBundleTest.swift
//  SwiftThinkBayesTests
//
//  Created by Matthew Walker on 27/01/19.
//  Copyright © 2019 Matthew Walker. All rights reserved.
//

import XCTest
import SwiftStats
import CSVImporter

class ReadFileFromBundleTest: XCTestCase {
    func testReadFileFromBundle() throws {
        print("Testing")
        
        let bundle = Bundle(for:ReadFileFromBundleTest.self)
        print("Bundle URL: ", bundle.bundleURL)
        
        let url = bundle.url(forResource: "TestFile", withExtension: "csv")!
        print("Test file URL:", url)

        let path = bundle.path(forResource: "TestFile", ofType: "csv")!
        print("Test file path:", path)

        
        let contents = try String(contentsOf: url)
        print("Contents:")
        print(contents)
        
        // Let's try reading using CSVImporter
        let importer = CSVImporter<[String]>(path: path)
        
        //let importedRecords = importer.importRecords{$0}
        //print("Imported Records:", importedRecords)
        
        let expectation = XCTestExpectation(description: "Read CSV file")

        importer.startImportingRecords { $0 }.onFail {
            print("ERROR The CSV file couldn't be read.")
            XCTFail()
        }.onProgress { importedDataLinesCount in
            print("\(importedDataLinesCount) lines were already imported.")
        }.onFinish { importedRecords in
            print("Did finish import with \(importedRecords.count) records.")
            expectation.fulfill()
        }

        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
    
}
