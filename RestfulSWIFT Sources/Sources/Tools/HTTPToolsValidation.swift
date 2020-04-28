//
//  HTTPToolsValidation.swift
//  RestfulSWIFT_Example
//
//  Created by Vlad Geiger on 28.04.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public protocol HTTPToolsValidation: HTTPTools {
    
    /// Defines the Type of the Error Object in case of a server error, for example: validation
    associatedtype ErrorObjectType: Decodable
    
}

public extension HTTPToolsValidation {
    
    func toValidatedEntityWithError<T: Decodable>(_ response: HTTPResponseType) throws -> T {
        let validatedResponse = try toErrorValidated(response)
        do {
            return try toEntity(validatedResponse)
        } catch {
            guard let data = response.0 else {
                throw GeneralErrors.fatal // should never occur
            }
            let decoder = JSONDecoder()
            let errorData = try? decoder.decode(ErrorObjectType.self, from: data)
            throw ValidationErrors.withServerError(error: errorData)
        }
    }
    
    func toValidatedLocationWithError(_ response: HTTPResponseType) throws -> String {
        let errorValidatedResponse = try toErrorValidated(response)
        guard let httpResponse = errorValidatedResponse.1 as? HTTPURLResponse else {
            throw DecodingErrors.failedToTransformToHTTPURLResponse
        }
        let potentialHeaderValue = httpResponse.allHeaderFields.first { (arg0) -> Bool in
            let (key, _) = arg0
            return key.description == "Location"
        }
        if let headerValue = potentialHeaderValue?.value as? String {
            return headerValue
        } else {
            guard let data = response.0 else {
                throw DecodingErrors.failedToExtractData
            }
            let decoder = JSONDecoder()
            let errorData = try? decoder.decode(ErrorObjectType.self, from: data)
            throw ValidationErrors.withServerError(error: errorData)
        }
    }
}
