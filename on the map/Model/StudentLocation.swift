//
//  StudentLocation.swift
//  on the map
//
//  Created by Matheus Lima on 07/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let firstName: String?
    let lastName: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let objectId: String?
    let userId: String?
    let uniqueKey: String?
    let mapString: String?
    let createdAt: Date
    let updatedAt: Date
}
