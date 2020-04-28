//
//  EmptyInterceptor.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 17.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public class EmptyInterceptor: Interceptor {
    
    public init() {
        // unused
    }
    
    public func intercept(_ request: URLRequest) -> Promise<URLRequest> {
        return Promise.fulfilled(request)
    }
    
}