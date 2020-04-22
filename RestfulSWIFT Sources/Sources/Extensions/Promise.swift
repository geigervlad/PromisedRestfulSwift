//
//  Promise.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 16.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

extension Promise {
    
    public class func fulfilled(_ value: T) -> Promise<T> {
        return Promise { $0.fulfill(value)}
    }
    
    public func timeout(after seconds: TimeInterval) -> Promise<T> {
        return race(asVoid(), after(seconds: seconds).done {
            throw PromiseErrors.timeout
        }).map {
            self.value!
        }
    }
    
}
