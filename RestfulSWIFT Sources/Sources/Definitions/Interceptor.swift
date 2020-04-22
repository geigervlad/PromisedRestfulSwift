//
//  Interceptor.swift
//  RestfulSWIFT
//
//  Created by Vlad Geiger on 17.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public protocol Interceptor {
    func intercept(_ request: URLRequest) -> Promise<URLRequest>
}
