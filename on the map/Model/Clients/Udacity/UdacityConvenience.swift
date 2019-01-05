//
//  UdacityConvenience.swift
//  on the map
//
//  Created by Matheus Lima on 04/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: Authentication
    func authenticate(email: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let parameters: [String:AnyObject] = [:]
        let jsonBody = """
                        { "\(JSONBodyKeys.Udacity)" : {
                                "\(JSONBodyKeys.UdacityUsername)": "\(email)",
                                "\(JSONBodyKeys.UdacityPassword)": "\(password)"
                            }
                        }
                        """
        let _ = taskForPOSTMethod(Methods.Session, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            guard (error == nil) else {
                completionHandlerForAuth(false, error!.localizedDescription)
                return
            }
            
            print(results ?? "")
            self.getUserInfo(completion: completionHandlerForAuth)
        }
    }
    
    // MARK: User info
    private func getUserInfo(completion: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let parameters: [String:AnyObject] = [:]
        var mutableMethod: String = Methods.UserID
        
        guard let sessionID = UdacityClient.sharedInstance().sessionID else {
            completion(false, "Session ID not found")
            return
        }
        
        mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.UserID, value: sessionID)!

        let _ = taskForGETMethod(mutableMethod, parameters: parameters) { (results, error) in
            guard (error == nil) else {
                completion(false, error!.localizedDescription)
                return
            }
            
            guard let user = results?[JSONResponseKeys.User] as? [String:AnyObject] else {
                completion(false, "Could not find \(JSONResponseKeys.User)")
                return
            }
            
            guard let nickname = user[JSONResponseKeys.Nickname] as? String else {
                completion(false, "Could not find \(JSONResponseKeys.Nickname)")
                return
            }
            
            UdacityClient.sharedInstance().nickname = nickname
            completion(true, nil)
        }
    }
}
