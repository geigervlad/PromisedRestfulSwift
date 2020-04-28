//
//  RestfulDelete.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 15.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public protocol RestfulDelete {
    
    /// Provides capability to intercept a request and include for example an Authorization Header inside
    var interceptor: Interceptor { get }
    
    /// Executes a DELETE request on a resource: solutions/{ID}
    /// - Parameter url: the url with the identification of the resource
    /// - Returns: a Promise which resolves if the request was successful
    func delete(url: URL) -> Promise<Void>
    
}

public extension RestfulDelete {
    
    var interceptor: Interceptor {
        return EmptyInterceptor()
    }
    
    func delete(url: URL) -> Promise<Void> {
        return Promise(error: GeneralErrors.functionNotAvailableInThisVersion)
    }
    
}
