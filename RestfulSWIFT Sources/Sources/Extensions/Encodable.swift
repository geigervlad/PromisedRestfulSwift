//
//  Encodable.swift
//  RestfulSWIFT
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
    
}
