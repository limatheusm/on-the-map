//
//  StudentLocationResponse.swift
//  on the map
//
//  Created by Matheus Lima on 07/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

struct StudentLocationResponse: Codable {
    let studentsLocation: [StudentLocation]
    
    enum CodingKeys: String, CodingKey {
        case studentsLocation = "results"
    }
}
