//
//  HTTPTools.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 15.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public protocol HTTPTools {
    func executeRequestAsPromise(_ request: URLRequest) -> Promise<HTTPResponseType>
}

public extension HTTPTools {
        
    func executeRequestAsPromise(_ request: URLRequest) -> Promise<HTTPResponseType> {
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
    
    func toErrorAndStatusCodeValidated(_ response: HTTPResponseType) throws -> HTTPResponseType {
        let validatedResponse = try toErrorValidated(response)
        return try toStatusCodeValidated(validatedResponse)
    }
    
    func toValidatedEntity<T: Decodable>(_ response: HTTPResponseType) throws -> T {
        let validatedResponse = try toErrorAndStatusCodeValidated(response)
        return try toEntity(validatedResponse)
    }
    
    func toValidatedLocation(_ response: HTTPResponseType) throws -> String {
        let errorValidatedResponse = try toErrorValidated(response)
        guard let httpResponse = errorValidatedResponse.1 as? HTTPURLResponse else {
            throw DecodingErrors.failedToTransformToHTTPURLResponse
        }
        let potentialHeaderValue = httpResponse.allHeaderFields.first { (arg0) -> Bool in
            let (key, _) = arg0
            return key.description == "Location"
        }.map {
            $0.value
        }
        if let headerValue = potentialHeaderValue as? String {
            return headerValue
        } else {
            throw DecodingErrors.failedToExtractLocationHeader
        }
    }
    
    func buildPostRequest<T: Encodable>(_ url: URL, _ entity: T) -> Promise<URLRequest> {
        return entity.toJsonData().map { data in
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.httpBody = data
            return request
        }
    }
    
}
