//
//  ErrorResponse.swift
//  on the map
//
//  Created by Matheus Lima on 05/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

import Foundation

struct ErrorResponse : Codable {
    let status: Int
    let error: String
}
