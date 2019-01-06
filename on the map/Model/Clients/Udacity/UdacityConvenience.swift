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
            func sendError(_ errorString: String) {
                print(errorString)
                completionHandlerForAuth(false, errorString)
            }
            
            guard (error == nil) else {
                sendError(error!.localizedDescription)
                return
            }
            
            guard let session = results?[JSONResponseKeys.Session] as? [String:AnyObject] else {
                sendError("Could not find \(JSONResponseKeys.Session)")
                return
            }
            
            guard let sessionID = session[JSONResponseKeys.SessionID] as? String else {
                sendError("Could not find \(JSONResponseKeys.SessionID)")
                return
            }
            
            UdacityClient.sharedInstance().sessionID = sessionID
            
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
            func sendError(_ errorString: String) {
                print(errorString)
                completion(false, errorString)
            }
            
            guard (error == nil) else {
                sendError(error!.localizedDescription)
                return
            }

            guard let firstName = results?[JSONResponseKeys.UserFirstName] as? String else {
                sendError("Could not find \(JSONResponseKeys.UserFirstName)")
                return
            }

            guard let lastName = results?[JSONResponseKeys.UserLastName] as? String else {
                sendError("Could not find \(JSONResponseKeys.UserLastName)")
                return
            }

            UdacityClient.sharedInstance().firstName = firstName
            UdacityClient.sharedInstance().lastName = lastName
            completion(true, nil)
        }
    }
}
