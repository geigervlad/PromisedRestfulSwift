//
//  Encodable.swift
//  PromisedRestfulSwift
//
//  Created by Vlad Geiger on 15.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

extension Encodable {
    
    public func toJsonData() -> Promise<Data> {
        return Promise { resolver in
            let data = try JSONEncoder().encode(self)
            resolver.fulfill(data)
        }
    }
    
    public func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw DecodingErrors.failedToTransformToDictionary
        }
        return dictionary
    }
    
    public func toQueryParameters(in url: URL) throws -> URL {
        guard let parameters = try? self.toDictionary() else {
            throw DecodingErrors.failedToTransformToDictionary
        }
        let queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: value as? String)
        }
        guard var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw GeneralErrors.fatal
        }
        urlComponent.queryItems = queryItems
        guard let updatedUrl = urlComponent.url else {
            throw GeneralErrors.fatal
        }
        return updatedUrl
    }
    
    public func toPromisedQueryParameters(in url: URL) -> Promise<URL> {
        return Promise { resolver in
            let newUrl: URL = try self.toQueryParameters(in: url)
            resolver.fulfill(newUrl)
        }
    }
}
