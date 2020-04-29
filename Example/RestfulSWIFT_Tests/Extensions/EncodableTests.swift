//
//  EncodableTests.swift
//  RestfulSWIFT_Tests
//
//  Created by Vlad Geiger on 22.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import XCTest
import PromiseKit
import RestfulSWIFT_Example

struct TestStructureEncodable: Encodable {
    var string: String
    var int: Int
    var bool: Bool
}

class EncodableTests: XCTestCase {
            
    func testJsonTransformationSuccess() {
        let structure = TestStructureEncodable(string: "I am a test data", int: 1512, bool: true )
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
          let structure = TestStructureEncodable(string: "I am a test data", int: 1512, bool: true )
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
