//
//  UserResponse.swift
//  on the map
//
//  Created by Matheus Lima on 05/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

import Foundation

/*
 {
     user =     {
         "_registered" = 1;
         guard =         {
         "allowed_behaviors" =             (
         register,
         "view-public",
         "view-short"
         );
         };
         key = 2312231;
         nickname = "Mariela Steuber";
         };
     }
 */

struct UserResponse : Codable {
    let user: User
}

struct User: Codable {
    let registered: Int
    let guard_: [String:String]
    let key: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case registered = "_registered"
        case guard_ = "guard"
        case key
        case nickname
    }
}
