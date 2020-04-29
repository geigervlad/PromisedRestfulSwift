//
//  HTTPToolsValidation.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 28.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import Foundation

// MARK: Definition

public protocol HTTPToolsValidation: HTTPTools {
    
    /// Defines the Type of the Error Object in case of a server error, for example: validation
    associatedtype ErrorObjectType: Decodable
    
    /// Checks a HTTPResponse for StatusCode, Error, Data and tries to transforms the data to expected Decodable Structure
    /// In case of HTTP Status Codes Bad Request(400) or Conflict(409) the server response gets decoded with the defined error object type
    /// - Parameter response: the HTTPResponse to check
    /// - Returns: The Decoded Entity
    func toValidatedEntityWithError<T: Decodable>(_ response: HTTPResponseType) throws -> T
    
    /// Checks a HTTPResponse for StatusCode, Error
    /// In case of HTTP Status Codes Bad Request(400) or Conflict(409) the server response gets decoded with the defined error object type
    /// - Parameter response: the HTTPResponse to check
    func toValidatedError(_ response: HTTPResponseType) throws
    
    /// Checks a HTTPResponse for StatusCode, Error, and tries to extract the value of the HTTP Location Header
    /// /// In case of HTTP Status Codes Bad Request(400) or Conflict(409) the server response gets decoded with the defined error object type
    /// - Parameter response: the HTTPResponse to check
    /// - Returns: The Value of the Location Header
    func toValidatedLocationWithError(_ response: HTTPResponseType) throws -> String
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
    
    func toValidatedLocationWithError(_ response: HTTPResponseType) throws -> String {
        do {
            return try toValidatedLocation(response)
        } catch {
            throw try extractServerError(error, response)
        }
    }
    
    func extractServerError(_ error: Error, _ response: HTTPResponseType) throws -> Error {
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
