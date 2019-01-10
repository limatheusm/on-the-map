//
//  ParseConstants.swift
//  on the map
//
//  Created by Matheus Lima on 02/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Keys
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    // MARK: Header Fields
    struct HeaderFields {
        static let ApplicationID = "X-Parse-Application-Id"
        static let RestAPIKey = "X-Parse-REST-API-Key"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let StudentLocationObjectID = "objectId"
    }
    
    // MARK: Methods
    struct Methods {
        static let StudentLocation = "/StudentLocation"
        static let StudentLocationObjectID = "/StudentLocation/{\(URLKeys.StudentLocationObjectID)}"
    }
    
    // MARK: Parameter Keys
    struct ParametersKeys {
        static let limit = "limit"
        static let skip = "skip"
        static let order = "order"
        static let where_ = "where"
    }
    
    struct ParametersValues {
        static let Limit = 100
        static let Order = "-updatedAt"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let objectId = "objectId"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    // MARK: String Messages
    struct Messages {
        static let askOverwriteStudentLocation = "You have already posted a Student Location. Would you like to overwrite your current location?"
    }
}
