//
//  InterceptorType.swift
//  PromisedRestfulSwift
//
//  Created by Vlad Geiger on 17.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public protocol InterceptorType {
    
    /// Intercepts a URL requests before its execution
    /// Can be used for adding for example: Authorization Header
    /// - Parameter request: the URLRequest
    func intercept(_ request: URLRequest) -> Promise<URLRequest>
}
