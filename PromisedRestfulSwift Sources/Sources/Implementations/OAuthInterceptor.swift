//
//  OAuthInterceptor.swift
//  PromisedRestfulSwift
//
//  Created by Vlad Geiger on 17.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public struct OAuthClientConfiguration: Decodable {
    var tokenUri: URL
    var clientId: String
    var clientSecret: String?
}

public struct OAuthData: Decodable {
    
    var accessToken: String
    var refreshToken: String
    var accessTokenExpiresAt: Date
    var refreshTokenExpiresAt: Date?
    
    enum DecodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case refreshExpiresIn = "refresh_expires_in"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DecodingKeys.self)
        let accessTokenExpiresIn = try values.decode(Int.self, forKey: .expiresIn)
        let now = Date()
        accessTokenExpiresAt = now.addingTimeInterval(TimeInterval(accessTokenExpiresIn))
        if let refreshTokenExpiresIn = try values.decode(Optional<Int>.self, forKey: .refreshExpiresIn) {
            refreshTokenExpiresAt = now.addingTimeInterval(TimeInterval(refreshTokenExpiresIn))
        } else {
            refreshTokenExpiresAt = nil
        }
        accessToken = try values.decode(String.self, forKey: .accessToken)
        refreshToken = try values.decode(String.self, forKey: .refreshToken)
    }
    
}

public class OAuthInterceptor: InterceptorType, RestfulWrite {
    
    private let configuration: OAuthClientConfiguration
    private var loginData: OAuthData?
    
    public init(_ configuration: OAuthClientConfiguration, _ data: OAuthData? = nil) {
        self.configuration = configuration
        self.loginData = data
    }
    
    public func intercept(_ request: URLRequest) -> Promise<URLRequest> {
        return getValidAccessToken().map { self.injectToken($0, request) }
    }
    
    private func getValidAccessToken() -> Promise<String> {
        guard let loginData = self.loginData else {
            return Promise(error: AuthenticationErrors.notAuthenticated)
        }
        guard !loginData.accessToken.isEmpty else {
            return Promise(error: AuthenticationErrors.notAuthenticated)
        }
        guard loginData.accessTokenExpiresAt < Date() else {
            return Promise.value(loginData.accessToken)
        }
        guard !loginData.refreshToken.isEmpty else {
            return Promise(error: AuthenticationErrors.notAuthenticated)
        }
        if let refreshTokenExpiresAt = loginData.refreshTokenExpiresAt, refreshTokenExpiresAt < Date() {
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
        if let clientSecret = configuration.clientSecret, !clientSecret.isEmpty {
            queryItems.append(URLQueryItem(name: "client_secret", value: configuration.clientSecret))
        }
        guard var urlComponent = URLComponents(url: configuration.tokenUri, resolvingAgainstBaseURL: false) else {
            return Promise(error: GeneralErrors.fatal)
        }
        urlComponent.queryItems = queryItems
        guard let url = urlComponent.url else {
            return Promise(error: GeneralErrors.fatal)
        }
        return write(url)
    }
    
    private func injectToken(_ token: String, _ request: URLRequest) -> URLRequest {
        var mutableRequest = request
        mutableRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return mutableRequest
    }
    
}
