//
//  Errors.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 15.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

public enum GeneralErrors: Error {
    case fatal
    case functionNotAvailableInThisVersion
}

public enum DecodingErrors: Error {
    case failedToExtractData
    case failedToExtractURLResponse
    case failedToTransformToDictionary
    case failedToExtractLocationHeader
    case failedToTransformToHTTPURLResponse
}

public enum ValidationErrors: Error {
    case invalidHttpCode(code: Int)
    case withServerError(error: Decodable)
}

public enum PromiseErrors: Error {
    case timeout
}

public enum AuthenticationErrors: Error {
    case notAuthorized
    case notAuthenticated
}
