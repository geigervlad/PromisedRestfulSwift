//
//  EncodableTests.swift
//  PromisedRestfulSwift_Tests
//
//  Created by Vlad Geiger on 22.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import XCTest
import PromiseKit
import PromisedRestfulSwift_Example

class EncodableTests: XCTestCase {
    
    func testJsonTransformationSuccess() {
        let structure = TestStructureCodable(string: "I am a test data", int: 1512, bool: true )
        let expectedString = "{\"string\":\"I am a test data\",\"int\":1512,\"bool\":true}"
        let expectation = XCTestExpectation()
        structure.toJsonData().done { actualData in
            let actualString = String(data: actualData, encoding: .utf8)
            XCTAssertEqual(actualString, expectedString)
            expectation.fulfill()
        }.catch { error in
            XCTFail("ERROR: Unexpected error: \(error) occured")
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testJsonTransformationFailure() {
        let structure = TestStructureCodable(string: "I am a test data", int: 1512, bool: true )
        let expectedString = "{\"string\":\"I am a  test data\",\"int\":1512,\"bool\":true}"
        let expectation = XCTestExpectation()
        structure.toJsonData().done { actualData in
            let actualString = String(data: actualData, encoding: .utf8)
            XCTAssertNotEqual(actualString, expectedString)
            expectation.fulfill()
        }.catch { error in
            XCTFail("ERROR: Unexpected error: \(error) occured")
        }
        wait(for: [expectation], timeout: 1)
    }
    
}
