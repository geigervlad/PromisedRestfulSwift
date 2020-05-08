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
    
}
