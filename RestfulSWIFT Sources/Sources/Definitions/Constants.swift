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

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
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
    array.append(400) // Bad Request
    array.append(409) // Conflict
    return array
}
