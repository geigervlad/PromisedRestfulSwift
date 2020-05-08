//
//  Intercepting.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 29.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import Foundation

public protocol Intercepting {
    /// provides capability to intercept a URLRequest and change it before its execution
    var interceptor: InterceptorType { get }
}

public extension Intercepting {
    var interceptor: InterceptorType {
        return defaultInterceptor
    }
}

public var defaultInterceptor: InterceptorType = EmptyInterceptor()
