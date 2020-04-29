//
//  PromiseTests.swift
//  RestfulSWIFT_Tests
//
//  Created by Vlad Geiger on 22.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import XCTest
import PromiseKit
import RestfulSWIFT_Example

class PromiseTests: XCTestCase {
    
    var promise: Promise<Void>!
    var resolver: Resolver<Void>!
    
    override func setUp() {
        promise = Promise { resolver in
            self.resolver = resolver
        }
    }
    
    override func tearDown() {
        resolver = nil
        promise = nil
    }
    
    func testPromiseDoesNotTimeout() {
        let expectation = XCTestExpectation()
        DispatchQueue(label: "testTimeoutSuccess").asyncAfter(deadline: .now() + 1) {
            self.resolver.fulfill(())
        }
        promise.timeout(after: 2).done {
            expectation.fulfill()
        }.catch { error in
            XCTFail("ERROR: Unexpected error: \(error) occured")
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func testPromiseTimeout() {
        let expectation = XCTestExpectation()
        promise.timeout(after: 2).done {
            XCTFail("ERROR: Promise should not fullfil")
        }.catch { error in
            switch error {
            case PromiseErrors.timeout:
                expectation.fulfill()
            default:
                XCTFail("ERROR: Unexpected error: \(error) occured")
            }
        }
        wait(for: [expectation], timeout: 3)
    }
        
}
