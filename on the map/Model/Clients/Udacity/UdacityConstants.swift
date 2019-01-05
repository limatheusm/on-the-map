//
//  UdacityConstants.swift
//  on the map
//
//  Created by Matheus Lima on 02/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "onthemap-api.udacity.com"
        static let ApiPath = "/v1"
        
        static let SignUpURL = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "user_id"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Auth
        static let Session = "/session"
        
        // MARK: Users
        static let UserID = "/users/{\(UdacityClient.URLKeys.UserID)}"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        
        // MARK: Udacity
        static let Udacity = "udacity"
        static let UdacityUsername = "username" // Udacity e-mail
        static let UdacityPassword = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Session
        static let Session = "session"
        static let SessionID = "id"
        static let SessionExpiration = "expiration"
        
        // MARK: Account
        static let Account = "account"
        static let AccountKey = "key"
        static let AccountRegistered = "registered"
        
        // MARK: User
//        static let UserFirstName = "first_name"
//        static let UserLastName = "last_name"
        static let User = "user"
        static let Nickname = "nickname"
        
        // MARK: Error
        static let StatusCode = "status"
        static let ErrorMessage = "error"
    }
    
    struct Cookies {
        static let token = "X-XSRF-TOKEN"
    }
    
}
