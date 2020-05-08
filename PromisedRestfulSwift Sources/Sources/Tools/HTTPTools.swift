//
//  HTTPTools.swift
//  PromisedRestfulSwift
//
//  Created by Vlad Geiger on 15.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

// MARK: Definition

public protocol HTTPTools: Intercepting {
    
    /// Executes a URLRequest within a Promise resolved with the HTTPResponse
    /// - Parameter request: The request to execute
    /// - Returns: A Promise which resolves as soon as the request has been executed, with the HTTP Response
    func execute(_ request: URLRequest) -> Promise<HTTPResponseType>
        
}

// MARK: Default Implementation

public extension HTTPTools {
    
    func execute(_ request: URLRequest) -> Promise<HTTPResponseType> {
        return Promise { resolver in
            let task = URLSession.shared.dataTask(with: request) {
                resolver.fulfill(($0, $1, $2))
            }
            task.resume()
        }
    }
    
    func toErrorValidated(_ response: HTTPResponseType) throws -> HTTPResponseType {
        guard let error = response.2 else {
            return response
        }
        throw error
    }
    
    func toStatusCodeValidated(_ response: HTTPResponseType) throws -> HTTPResponseType {
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            throw DecodingErrors.failedToTransformToHTTPURLResponse
        }
        guard validHttpStatusCodes.contains(httpResponse.statusCode) else {
            throw ValidationErrors.invalidHttpCode(code: httpResponse.statusCode)
        }
        return response
    }
        
    func toEntity<T: Decodable>(_ response: HTTPResponseType) throws -> T {
        guard let data = response.0 else {
            throw DecodingErrors.failedToExtractData
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func toValidatedEntity<T: Decodable>(_ response: HTTPResponseType) throws -> T {
        let errorValidatedResponse = try toErrorValidated(response)
        let validatedResponse = try toStatusCodeValidated(errorValidatedResponse)
        return try toEntity(validatedResponse)
    }
    
    func toValidatedLocation(_ response: HTTPResponseType) throws -> String {
        let errorValidatedResponse = try toErrorValidated(response)
        let validatedResponse = try toStatusCodeValidated(errorValidatedResponse)
        guard let httpResponse = validatedResponse.1 as? HTTPURLResponse else {
            throw DecodingErrors.failedToTransformToHTTPURLResponse
        }
        let potentialHeaderValue = httpResponse.allHeaderFields.first { (arg0) -> Bool in
            let (key, _) = arg0
            return key.description == "Location"
        }
        if let headerValue = potentialHeaderValue?.value as? String {
            return headerValue
        } else {
            throw DecodingErrors.failedToExtractLocationHeader
        }
    }
    
    func buildPostRequest<T: Encodable>(_ url: URL, _ entity: T) -> Promise<URLRequest> {
        return entity.toJsonData().map { data in
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethods.post.rawValue
            request.httpBody = data
            return request
        }
    }
    
}
