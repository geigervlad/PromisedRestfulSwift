//
//  RestfulUpload.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 15.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

public protocol RestfulUpload {
    
    /// Provides capability to intercept a request and include for example an Authorization Header inside
    var interceptor: Interceptor { get }
    
}

public extension RestfulUpload {
    
    var interceptor: Interceptor {
        return EmptyInterceptor()
    }
    
}
