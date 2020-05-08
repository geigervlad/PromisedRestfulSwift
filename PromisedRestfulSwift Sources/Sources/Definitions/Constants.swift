//
//  Constants.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 16.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import Foundation

public typealias HTTPHeadersType = [String: String]
public typealias HTTPResponseType = (Data?, URLResponse?, Error?)

public enum HTTPMethods: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

public enum HTTPStatusCodes: Int {
    case badRequest = 400
    case conflict = 409
    case forbidden = 403
    case unauthorized = 401
}

public enum OAuthGrantTypes: String {
    case code = "authorization_code"
    case password = "password"
    case implicit = "implicit"
    case refreshToken = "refresh_token"
    case clientCredentials = "client_credentials"
}

public var validHttpStatusCodes: [Int] {
    return Array(200..<300)
}

public var validHttpStatusCodesBadRequest: [Int] {
    var array: [Int] = validHttpStatusCodes
    array.append(HTTPStatusCodes.badRequest.rawValue)
    array.append(HTTPStatusCodes.conflict.rawValue)
    return array
}
