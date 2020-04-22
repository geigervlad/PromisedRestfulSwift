//
//  RestfulRead.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 15.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public protocol RestfulRead: HTTPTools {
    
    /// Provides capability to intercept a request and include for example an Authorization Header inside
    var interceptor: Interceptor { get }
    
}

public extension RestfulRead {
    
    var interceptor: Interceptor {
        return EmptyInterceptor()
    }
    
    /// Executes a GET request on a specific resource: solutions/{ID}
    /// - Parameter url: the url with the resource identification
    /// - Returns: A promise which resolves if the request was successful and contains the expected entity
    func read<U: Decodable>(url: URL) -> Promise<U> {
        let request = URLRequest(url: url)
        return interceptor.intercept(request)
            .then(executeRequestAsPromise)
            .map(toValidatedEntity)
    }
    
}
