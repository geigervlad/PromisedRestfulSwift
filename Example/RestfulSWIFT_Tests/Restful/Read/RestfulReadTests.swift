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
    
    func testExample() {
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

}
