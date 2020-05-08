//
//  RestfulWrite.swift
//  PromisedRestfulSwift
//
//  Created by Vlad Geiger on 15.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public protocol RestfulWrite: HTTPTools { }

public extension RestfulWrite {
    
    /// Executes a POST request on a resource with no body: url encoding
    /// - Parameter url: the url with the query parameters
    /// - Returns: A promise which resolves if the request was successful and contains the server response
    func write<U: Decodable>(_ url: URL) -> Promise<U> {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.post.rawValue
        return interceptor.intercept(request)
            .then(execute)
            .map(toValidatedEntity)
    }
    
    /// Executes a POST request on a resource: /solutions with the entity data and returns the server response
    /// - Parameter url: the url for the resource to create
    /// - Returns: A promise which resolves if the request was successful and contains the server response
    func write<T: Encodable, U: Decodable>(_ url: URL, _  entity: T) -> Promise<U> {
        return buildPostRequest(url, entity)
            .then(interceptor.intercept)
            .then(execute)
            .map(toValidatedEntity)
    }
    
    /// Executes a POST request on a resource: /solutions with the entity data
    /// - Parameter url: the url for the resource to create
    /// - Returns: A promise which resolves if the request was successful and contains the value of the HTTP Location Header
    func writeAndExtractLocation<T: Encodable>(_ url: URL, _ entity: T) -> Promise<String> {
        return buildPostRequest(url, entity)
            .then(interceptor.intercept)
            .then(execute)
            .map(toValidatedLocation)
    }
    
}
