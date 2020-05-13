//
//  HTTPToolsValidation.swift
//  PromisedRestfulSwift
//
//  Created by Vlad Geiger on 28.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import Foundation

// MARK: Definition

public protocol HTTPToolsValidation: HTTPTools {
    
    /// Defines the Type of the Error Object in case of a server error, for example: validation
    associatedtype ErrorObjectType: Decodable
    
}

// MARK: Default Implementation

public extension HTTPToolsValidation {
    
    func toValidatedEntityWithError<T: Decodable>(_ response: HTTPResponseType) throws -> T {
        do {
            return try toValidatedEntity(response)
        } catch {
            throw try extractServerError(error, response)
        }
    }
    
    func toValidatedError(_ response: HTTPResponseType) throws {
        do {
            _ = try toStatusCodeValidated(toErrorValidated(response))
        } catch {
            throw try extractServerError(error, response)
        }
    }
    
    func toValidatedHeadersWithError(_ response: HTTPResponseType, _ headerKeys: [String]) throws -> HTTPHeadersType {
        do {
            return try toValidatedHeaders(response, headerKeys)
        } catch {
            throw try extractServerError(error, response)
        }
    }
    
    func toValidatedLocationWithError(_ response: HTTPResponseType) throws -> String {
        do {
            return try toValidatedLocation(response)
        } catch {
            throw try extractServerError(error, response)
        }
    }
    
    private func extractServerError(_ error: Error, _ response: HTTPResponseType) throws -> Error {
        switch error {
        case ValidationErrors.invalidHttpCode(let httpCode):
            if httpCode == HTTPStatusCodes.badRequest.rawValue || httpCode == HTTPStatusCodes.conflict.rawValue {
                let errorData: ErrorObjectType = try toEntity(response)
                return ValidationErrors.withServerError(error: errorData)
            } else {
                return error
            }
        default:
            return error
        }
    }
    
}
