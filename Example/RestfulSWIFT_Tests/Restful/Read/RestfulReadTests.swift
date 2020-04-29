//
//  RestfulReadTests.swift
//  RestfulSWIFT_Tests
//
//  Created by Vlad Geiger on 22.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import XCTest
import PromiseKit
import RestfulSWIFT_Example

struct TestStructureCodable: Codable {
    var string: String
    var int: Int
    var bool: Bool
}

class RestfulReadTests: XCTestCase, RestfulRead {
    
    var exampleUri: URL!
    var response: HTTPResponseType!
    
    override func setUp() {
        exampleUri = URL(string: "https://testExample.test")!
        response = nil
    }
    
    override func tearDown() {
        exampleUri = nil
        response = nil
    }
    
    func executeRequestAsPromise(_ request: URLRequest) -> Promise<HTTPResponseType> {
        return Promise { resolver in
            resolver.fulfill(response)
        }
    }
    
    func testReadFailureFatal() {
        response = (nil, nil ,GeneralErrors.fatal)
        let promise: Promise<[String]> = read(url: exampleUri)
        let expectation = XCTestExpectation()
        promise.done { result in
            XCTFail("ERROR: Unexpected result: \(result)")
        }.catch { error in
            switch error {
            case GeneralErrors.fatal:
                expectation.fulfill()
            default:
                XCTFail("ERROR: Unexpected error: \(error) occured")
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testReadFailureFailedToTransformToHTTPURLResponse() {
        response = (nil, nil ,nil)
        let promise: Promise<[String]> = read(url: exampleUri)
        let expectation = XCTestExpectation()
        promise.done { result in
            XCTFail("ERROR: Unexpected result: \(result)")
        }.catch { error in
            switch error {
            case DecodingErrors.failedToTransformToHTTPURLResponse:
                expectation.fulfill()
            default:
                XCTFail("ERROR: Unexpected error: \(error) occured")
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testReadFailureInvalidHttpCode() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 400,
                                              httpVersion: nil,
                                              headerFields: nil)
        response = (nil, httpUrlResponse, nil)
        let promise: Promise<[String]> = read(url: exampleUri)
        let expectation = XCTestExpectation()
        promise.done { result in
            XCTFail("ERROR: Unexpected result: \(result)")
        }.catch { error in
            switch error {
            case ValidationErrors.invalidHttpCode(code: httpUrlResponse?.statusCode):
                expectation.fulfill()
            default:
                XCTFail("ERROR: Unexpected error: \(error) occured")
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testReadFailureFailedToExtractData() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        response = (nil, httpUrlResponse, nil)
        let promise: Promise<[String]> = read(url: exampleUri)
        let expectation = XCTestExpectation()
        promise.done { result in
            XCTFail("ERROR: Unexpected result: \(result)")
        }.catch { error in
            switch error {
            case DecodingErrors.failedToExtractData:
                expectation.fulfill()
            default:
                XCTFail("ERROR: Unexpected error: \(error) occured")
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testReadFailureDecodingErrorDataCorrupted() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        response = (Data(), httpUrlResponse, nil)
        let promise: Promise<[String]> = read(url: exampleUri)
        let expectation = XCTestExpectation()
        promise.done { result in
            XCTFail("ERROR: Unexpected result: \(result)")
        }.catch { error in
            switch error {
            case is DecodingError:
                expectation.fulfill()
            default:
                XCTFail("ERROR: Unexpected error: \(error) occured")
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testReadSuccess() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        let structure = TestStructureCodable(string: "I am a test data", int: 1512, bool: true )
        let data = try! JSONEncoder().encode(structure)
        response = (data, httpUrlResponse, nil)
        let promise: Promise<TestStructureCodable> = read(url: exampleUri)
        let expectation = XCTestExpectation()
        promise.done { result in
            XCTAssertEqual(result.string, structure.string)
            XCTAssertEqual(result.int, structure.int)
            XCTAssertEqual(result.bool, structure.bool)
            expectation.fulfill()
        }.catch { error in
            XCTFail("ERROR: Unexpected error: \(error) occured")
        }
        wait(for: [expectation], timeout: 2)
    }
    
}
