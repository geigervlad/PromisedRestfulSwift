//
//  ValidationError.swift
//  RestfulSWIFT_Tests
//
//  Created by Vlad Geiger on 22.04.20.
//  Copyright © 2020 Vlad Geiger. All rights reserved.
//

import Foundation

struct ValidationError: Decodable {
    var code: Int
    var description: String
}
