//
//  StudentsDatasource.swift
//  on the map
//
//  Created by Matheus Lima on 10/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

final class StudentsDataSource {
    /* Singleton */
    static let shared = StudentsDataSource()
    
    static var studentsLocation: [StudentLocation]? = nil
    
    private init () {}
}
