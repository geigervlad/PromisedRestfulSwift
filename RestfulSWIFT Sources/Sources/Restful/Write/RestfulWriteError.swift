//
//  RestfulWriteError.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 21.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public protocol RestfulWriteError {
    
    /// Provides capability to intercept a request and include for example an Authorization Header inside
    var interceptor: Interceptor { get }
    
    /// Defines the Type of the Error Object in case of a server error, for example: validation
    associatedtype errorObject: Decodable
}

public extension RestfulWriteError {
    
    var interceptor: Interceptor {
        return EmptyInterceptor()
    }
    
    /// Executes a POST request on a resource with no body: url encoding
    /// - Parameter url: the url with the query parameters
    /// - Returns: A promise which resolves if the request was successful and contains the server response
    func write<U: Decodable>(url: URL) -> Promise<U> {
        return Promise(error: GeneralErrors.functionNotAvailableInThisVersion)
    }
    
    /// Executes a POST request on a resource: /solutions with the entity data and returns the server response
    /// - Parameter url: the url for the resource to create
    /// - Returns: A promise which resolves if the request was successful and contains the server response
    func write<T: Encodable, U: Decodable>(url: URL, entity: T) -> Promise<U> {
        return Promise(error: GeneralErrors.functionNotAvailableInThisVersion)
    }
    
    /// Executes a POST request on a resource: /solutions with the entity data and returns the Location Header Value
    /// - Parameter url: the url for the resource to create
    /// - Returns: A promise which resolves if the request was successful and contains the value of the HTTP Location Header
    func writeAndExtractLocation<T: Encodable>(url: URL, entity: T) -> Promise<String> {
        return Promise(error: GeneralErrors.functionNotAvailableInThisVersion)
    }
}
