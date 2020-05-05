//
//  RestfulWriteTests.swift
//  RestfulSWIFT_Tests
//
//  Created by Vlad Geiger on 22.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import XCTest
import PromiseKit
import RestfulSWIFT_Example

class RestfulWriteTests: XCTestCase, RestfulWrite {
    
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
    
    func execute(_ request: URLRequest) -> Promise<HTTPResponseType> {
        return Promise { resolver in
            resolver.fulfill(response)
        }
    }
    
    // MARK: - Tests for "func write<U: Decodable>(_ url: URL) -> Promise<U>"
    
    func testWriteFailureFatal() {
        response = (nil, nil, GeneralErrors.fatal)
        let promise: Promise<[String]> = write(exampleUri)
        let expectation = XCTestExpectation()
        promise.done { result in
            XCTFail()
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
    
    func testWriteFailureFailedToTransformToHTTPURLResponse() {
        response = (nil, nil, nil)
        let promise: Promise<[String]> = write(exampleUri)
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
    
    func testWriteFailureInvalidHttpCode() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 400,
                                              httpVersion: nil,
                                              headerFields: nil)
        response = (nil, httpUrlResponse, nil)
        let promise: Promise<[String]> = write(exampleUri)
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
    
    func testWriteFailureFailedToExtractData() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        response = (nil, httpUrlResponse, nil)
        let promise: Promise<[String]> = write(exampleUri)
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
    
    func testWriteFailureDecodingErrorDataCorrupted() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        response = (Data(), httpUrlResponse, nil)
        let promise: Promise<[String]> = write(exampleUri)
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
    
    func testWriteSuccess() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        let structure = TestStructureCodable(string: "I am a test data", int: 1512, bool: true )
        let data = try! JSONEncoder().encode(structure)
        response = (data, httpUrlResponse, nil)
        let promise: Promise<TestStructureCodable> = write(exampleUri)
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
    
    // MARK: Tests for "func write<T: Encodable, U: Decodable>(_ url: URL, _  entity: T) -> Promise<U>"
    
    func testWriteWithEntityFailureEncodingErrorInvalidValue() {
        response = (nil, nil, nil)
        let entity = TestStructureCodable(string: "test", int: 0, bool: false, double: Double.infinity)
        let promise: Promise<[String]> = write(exampleUri, entity)
        let expectation = XCTestExpectation()
        promise.done { result in
            XCTFail("ERROR: Unexpected result: \(result)")
        }.catch { error in
            switch error {
            case EncodingError.invalidValue:
                expectation.fulfill()
            default:
                XCTFail("ERROR: Unexpected error: \(error) occured")
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testWriteWithEntityFailureFatal() {
        response = (nil, nil, GeneralErrors.fatal)
        let entity = TestStructureCodable(string: "test", int: 0, bool: false)
        let promise: Promise<[String]> = write(exampleUri, entity)
        let expectation = XCTestExpectation()
        promise.done { result in
            XCTFail()
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
    
    func testWriteWithEntityFailureFailedToTransformToHTTPURLResponse() {
        response = (nil, nil, nil)
        let entity = TestStructureCodable(string: "test", int: 0, bool: false)
        let promise: Promise<[String]> = write(exampleUri, entity)
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
    
    func testWriteWithEntityFailureInvalidHttpCode() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 400,
                                              httpVersion: nil,
                                              headerFields: nil)
        response = (nil, httpUrlResponse, nil)
        let entity = TestStructureCodable(string: "test", int: 0, bool: false)
        let promise: Promise<[String]> = write(exampleUri, entity)
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
    
    func testWriteWithEntityFailureFailedToExtractData() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        response = (nil, httpUrlResponse, nil)
        let entity = TestStructureCodable(string: "test", int: 0, bool: false)
        let promise: Promise<[String]> = write(exampleUri, entity)
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
    
    func testWriteWithEntityFailureDecodingErrorDataCorrupted() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        response = (Data(), httpUrlResponse, nil)
        let entity = TestStructureCodable(string: "test", int: 0, bool: false)
        let promise: Promise<[String]> = write(exampleUri, entity)
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
    
    func testWriteWithEntitySuccess() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        let structure = TestStructureCodable(string: "I am a test data", int: 1512, bool: true )
        let data = try! JSONEncoder().encode(structure)
        response = (data, httpUrlResponse, nil)
        let promise: Promise<TestStructureCodable> = write(exampleUri, structure)
        let expectation = XCTestExpectation()
        promise.done { result in
            XCTAssertEqual(structure.string, structure.string)
            XCTAssertEqual(structure.int, structure.int)
            XCTAssertEqual(structure.bool, structure.bool)
            expectation.fulfill()
        }.catch { error in
            XCTFail("ERROR: Unexpected error: \(error) occured")
        }
        wait(for: [expectation], timeout: 2)
    }
    
    // MARK: - Tests for "func writeAndExtractLocation<T: Encodable>(_ url: URL, _ entity: T) -> Promise<String>"
    
    func testWriteWithEntityLocationFailureEncodingErrorInvalidValue() {
        response = (nil, nil, nil)
        let entity = TestStructureCodable(string: "test", int: 0, bool: false, double: Double.infinity)
        let promise: Promise<String> = writeAndExtractLocation(exampleUri, entity)
        let expectation = XCTestExpectation()
        promise.done { result in
            XCTFail("ERROR: Unexpected result: \(result)")
        }.catch { error in
            switch error {
            case EncodingError.invalidValue:
                expectation.fulfill()
            default:
                XCTFail("ERROR: Unexpected error: \(error) occured")
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testWriteWithEntityLocationFailureFatal() {
        response = (nil, nil, GeneralErrors.fatal)
        let entity = TestStructureCodable(string: "test", int: 0, bool: false)
        let promise: Promise<String> = writeAndExtractLocation(exampleUri, entity)
        let expectation = XCTestExpectation()
        promise.done { result in
            XCTFail()
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
    
    func testWriteWithEntityLocationFailureFailedToTransformToHTTPURLResponse() {
        response = (nil, nil, nil)
        let entity = TestStructureCodable(string: "test", int: 0, bool: false)
        let promise: Promise<String> = writeAndExtractLocation(exampleUri, entity)
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
    
    func testWriteWithEntityLocationFailureInvalidHttpCode() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 400,
                                              httpVersion: nil,
                                              headerFields: nil)
        response = (nil, httpUrlResponse, nil)
        let entity = TestStructureCodable(string: "test", int: 0, bool: false)
        let promise: Promise<String> = writeAndExtractLocation(exampleUri, entity)
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
    
    func testWriteWithEntityLocationFailureDecodingErrorsFailedToEtractLocationHeader() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: nil)
        response = (nil, httpUrlResponse, nil)
        let entity = TestStructureCodable(string: "test", int: 0, bool: false)
        let promise: Promise<String> = writeAndExtractLocation(exampleUri, entity)
        let expectation = XCTestExpectation()
        promise.done { result in
            XCTFail("ERROR: Unexpected result: \(result)")
        }.catch { error in
            switch error {
            case DecodingErrors.failedToExtractLocationHeader:
                expectation.fulfill()
            default:
                XCTFail("ERROR: Unexpected error: \(error) occured")
            }
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testWriteWithEntityLocationSuccess() {
        let httpUrlResponse = HTTPURLResponse(url: exampleUri,
                                              statusCode: 200,
                                              httpVersion: nil,
                                              headerFields: ["Location": "https://test.test"])
        response = (nil, httpUrlResponse, nil)
        let entity = TestStructureCodable(string: "test", int: 0, bool: false)
        let promise: Promise<String> = writeAndExtractLocation(exampleUri, entity)
        let expectation = XCTestExpectation()
        promise.done { result in
            expectation.fulfill()
        }.catch { error in
            
            XCTFail("ERROR: Unexpected error: \(error) occured")
        }
        wait(for: [expectation], timeout: 2)
    }
}
