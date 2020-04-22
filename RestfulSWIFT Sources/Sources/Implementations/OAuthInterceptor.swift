//
//  OAuthInterceptor.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 17.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public struct OAuthClientConfiguration: Decodable {
    var tokenUri: URL
    var clientId: String
    var clientSecret: String
}

public struct OAuthData: Decodable {
    
    var accessToken: String
    var refreshToken: String
    var accessTokenExpiresAt: Date
    var refreshTokenExpiresAt: Date
    
    enum DecodingKeys: String, CodingKey {
        case access_token
        case refresh_token
        case expires_in
        case refresh_expires_in
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DecodingKeys.self)
        let accessTokenExpiresIn = try values.decode(Int.self, forKey: .expires_in)
        let refreshTokenExpiresIn = try values.decode(Int.self, forKey: .refresh_expires_in)
        let now = Date()
        accessTokenExpiresAt = now.addingTimeInterval(TimeInterval(accessTokenExpiresIn))
        refreshTokenExpiresAt = now.addingTimeInterval(TimeInterval(refreshTokenExpiresIn))
        accessToken = try values.decode(String.self, forKey: .access_token)
        refreshToken = try values.decode(String.self, forKey: .refresh_token)
    }
    
}

public class OAuthInterceptor: Interceptor, RestfulWrite {
    
    private let configuration: OAuthClientConfiguration
    private var loginData: OAuthData?
        
    public init(_ configuration: OAuthClientConfiguration, _ data: OAuthData? = nil) {
        self.configuration = configuration
        self.loginData = data
    }
    
    public func intercept(_ request: URLRequest) -> Promise<URLRequest> {
        return getValidAccessToken().map { token in
            self.injectToken(token, request)
        }
    }
    
    private func getValidAccessToken() -> Promise<String> {
        guard let loginData = self.loginData else {
            return Promise(error: AuthenticationErrors.notAuthenticated)
        }
        guard loginData.accessTokenExpiresAt < Date() else {
            return Promise { $0.fulfill(loginData.accessToken) }
        }
        guard loginData.refreshTokenExpiresAt > Date() else {
            return Promise(error: AuthenticationErrors.notAuthenticated)
        }
        return refreshAccessToken(loginData.refreshToken).map { newLoginData in
            self.loginData = newLoginData
            return loginData.accessToken
        }
    }
    
    private func refreshAccessToken(_ refreshToken: String) -> Promise<OAuthData> {
        var queryItems = [
            URLQueryItem(name: "grant_type", value: OAuthGrantTypes.refreshToken.rawValue),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        if !configuration.clientId.isEmpty {
            queryItems.append(URLQueryItem(name: "client_id", value: configuration.clientId))
        }
        if !configuration.clientSecret.isEmpty {
            queryItems.append(URLQueryItem(name: "client_secret", value: configuration.clientSecret))
        }
        guard var urlComponent = URLComponents(url: configuration.tokenUri, resolvingAgainstBaseURL: false) else {
            return Promise(error: GeneralErrors.fatal)
        }
        urlComponent.queryItems = queryItems
        guard let url = urlComponent.url else {
            return Promise(error: GeneralErrors.fatal)
        }
        return write(url: url)
    }
    
    private func injectToken(_ token: String,_ request: URLRequest) -> URLRequest {
        var mutableRequest = request
        mutableRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return mutableRequest
    }
    
}
