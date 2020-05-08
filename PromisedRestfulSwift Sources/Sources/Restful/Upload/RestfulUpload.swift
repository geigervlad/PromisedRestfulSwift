//
//  RestfulUpload.swift
//  PromisedRestfulSwift
//
//  Created by Vlad Geiger on 15.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import PromiseKit

public protocol RestfulUpload: HTTPTools { }

public extension RestfulUpload {
    
    /// Uploads the data stream onto the provided URL
    /// - Parameters:
    ///   - data: The data
    ///   - url: The URL
    ///   - onProgressUpdate: A function to react to the live progress of the upload
    /// - Returns: A Promise which resolves if the request is successfully executed
    func upload(_ data: Data, _ url: URL, _ onProgressUpdate: @escaping (Progress) -> Void) -> Promise<Void> {
        return Promise(error: GeneralErrors.functionNotAvailableInThisVersion)
    }
    
    /// Uploads the data stream with the provided metadata onto the provided URL
    /// - Parameters:
    ///   - data: The data
    ///   - metadata: The encodable metadata
    ///   - url: The URL
    ///   - onProgressUpdate: A function to react to the live progress of the upload
    /// - Returns: A Promise which resolves if the request is successfully executed
    func upload<T: Encodable>(_ data: Data, _ metadata: T, _ url: URL, _ onProgressUpdate: @escaping (Progress) -> Void) -> Promise<Void> {
        return Promise(error: GeneralErrors.functionNotAvailableInThisVersion)
    }
    
    /// Uploads the data stream onto the provided URL
    /// - Parameters:
    ///   - data: The data
    ///   - url: The URL
    ///   - onProgressUpdate: A function to react to the live progress of the upload
    /// - Returns: A Promise which resolves with the HTTP Location Header Value  if the request is successfully executed
    func uploadAndExtractLocation(_ data: Data, _ url: URL, _ onProgressUpdate: @escaping (Progress) -> Void) -> Promise<String> {
        return Promise(error: GeneralErrors.functionNotAvailableInThisVersion)
    }
    
    /// Uploads the data stream with the provided metadata onto the provided URL
    /// - Parameters:
    ///   - data: The data
    ///   - metadata: The encodable metadata
    ///   - url: The URL
    ///   - onProgressUpdate: A function to react to the live progress of the upload
    /// - Returns: A Promise which resolves with the HTTP Location Header Value  if the request is successfully executed
    func uploadAndExtractLocation<T: Encodable>(_ data: Data, _ metadata: T, _ url: URL, _ onProgressUpdate: @escaping (Progress) -> Void) -> Promise<String> {
        return Promise(error: GeneralErrors.functionNotAvailableInThisVersion)
    }
    
}
