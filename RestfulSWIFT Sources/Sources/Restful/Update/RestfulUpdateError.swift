//
//  RestfulUpdateError.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 21.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public protocol RestfulUpdateError {
    
    /// Provides capability to intercept a request and include for example an Authorization Header inside
    var interceptor: Interceptor { get }
    
    /// Defines the Type of the Error Object in case of a server error, for example: validation
    associatedtype ErrorObjectType: Decodable
}

public extension RestfulUpdateError {
    
    var interceptor: Interceptor {
        return EmptyInterceptor()
    }
    
    /// Executes a PUT request on a resource: /solutions with the entity data
    /// - Parameter url: the url of the resource to update
    /// - Returns: a promise which resolves if the update was successful
    func update<T: Encodable>(url: URL, entity: T) -> Promise<Void> {
        return Promise(error: GeneralErrors.functionNotAvailableInThisVersion)
    }
    
    /// Executes a PUT request on a resource: /solutions with the entity data and returns the server response
    /// - Parameter url: the url of the resource to update
    /// - Returns: a promise which resolves if the update was successfull and contains  the server response data
    func update<T: Encodable, U: Decodable>(url: URL, entity: T) -> Promise<U> {
        return Promise(error: GeneralErrors.functionNotAvailableInThisVersion)
    }
    
}
