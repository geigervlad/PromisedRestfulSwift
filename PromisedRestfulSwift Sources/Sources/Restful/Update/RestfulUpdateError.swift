//
//  RestfulUpdateError.swift
//  PromisedRestfulSwift
//
//  Created by Vlad Geiger on 21.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public protocol RestfulUpdateError: HTTPToolsValidation { }

public extension RestfulUpdateError {
    
    /// Executes a PUT request on a resource: /solutions with the entity data
    /// - Parameter url: the url of the resource to update
    /// - Returns: a promise which resolves if the update was successful
    func update<T: Encodable>(_ url: URL, _ entity: T) -> Promise<Void> {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.put.rawValue
        return interceptor.intercept(request)
            .then(execute)
            .map(toValidatedError)
    }
    
    /// Executes a PUT request on a resource: /solutions with the entity data and returns the server response
    /// - Parameter url: the url of the resource to update
    /// - Parameter entity: the entity to update
    /// - Returns: a promise which resolves if the update was successfull and contains  the server response data
    func update<T: Encodable, U: Decodable>(_ url: URL, _ entity: T) -> Promise<U> {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.put.rawValue
        return interceptor.intercept(request)
            .then(execute)
            .map(toValidatedEntityWithError)
    }
    
}
