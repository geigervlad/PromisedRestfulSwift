//
//  RestfulWriteError.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 21.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

// MARK: Definition

public protocol RestfulWriteError: HTTPToolsValidation {
    
    /// Executes a POST request on a resource with no body: url encoding
    /// - Parameter url: the url with the query parameters
    /// - Returns: A promise which resolves if the request was successful and contains the server response
    func write<U: Decodable>(url: URL) -> Promise<U>
    
    /// Executes a POST request on a resource: /solutions with the entity data and returns the server response
    /// - Parameter url: the url for the resource to create
    /// - Returns: A promise which resolves if the request was successful and contains the server response
    func write<T: Encodable, U: Decodable>(url: URL, entity: T) -> Promise<U>
    
    /// Executes a POST request on a resource: /solutions with the entity data and returns the Location Header Value
    /// - Parameter url: the url for the resource to create
    /// - Returns: A promise which resolves if the request was successful and contains the value of the HTTP Location Header
    func writeAndExtractLocation<T: Encodable>(url: URL, entity: T) -> Promise<String>
}

// MARK: Default Implementation

public extension RestfulWriteError {
    
    func write<U: Decodable>(url: URL) -> Promise<U> {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.post.rawValue
        return interceptor.intercept(request)
            .then(execute)
            .map(toValidatedEntityWithError)
    }
    
    func write<T: Encodable, U: Decodable>(url: URL, entity: T) -> Promise<U> {
        return buildPostRequest(url, entity)
            .then(interceptor.intercept)
            .then(execute)
            .map(toValidatedEntityWithError)
    }
    
    func writeAndExtractLocation<T: Encodable>(url: URL, entity: T) -> Promise<String> {
        return buildPostRequest(url, entity)
            .then(interceptor.intercept)
            .then(execute)
            .map(toValidatedLocationWithError)
    }
}
