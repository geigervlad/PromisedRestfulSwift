//
//  Interceptor.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 29.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import Foundation

// MARK: Definition

public var defaultInterceptor: InterceptorType = EmptyInterceptor()

public protocol Interceptor {
    
    /// provides capability to intercept a URLRequest and change it before its execution
    var interceptor: InterceptorType { get }
}

// MARK: Default Implementation

public extension Interceptor {
    
    var interceptor: InterceptorType {
        return defaultInterceptor
    }
}
