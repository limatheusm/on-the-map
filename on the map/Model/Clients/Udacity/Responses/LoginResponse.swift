//
//  LoginResponse.swift
//  on the map
//
//  Created by Matheus Lima on 05/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let session: Session
    let account: Account
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct Account: Codable {
    let registered: Bool
    let key: String
}
