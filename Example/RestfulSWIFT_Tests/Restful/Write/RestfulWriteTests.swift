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
    
    func executeRequestAsPromise(_ request: URLRequest) -> Promise<HTTPResponseType> {
        return Promise { resolver in
            resolver.fulfill(response)
        }
    }
    
    // TODO: - here the tests
    
}
