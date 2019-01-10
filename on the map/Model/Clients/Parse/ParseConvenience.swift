//
//  ParseConvenience.swift
//  on the map
//
//  Created by Matheus Lima on 07/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

extension ParseClient {
    
    // MARK: StudentLocation Actions
    
    func getStudentsLocation(completion: @escaping (_ studentsLocation: [StudentLocation]?, _ errorString: String?) -> Void) {
        
        let parameters = [ParametersKeys.limit: ParametersValues.Limit, ParametersKeys.order: ParametersValues.Order] as [String : AnyObject]
        
        let _ = taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (results: StudentLocationResponse?, error) in
            func sendError(_ errorString: String) {
                print(errorString)
                completion(nil, errorString)
            }
            
            guard error == nil else {
                sendError(error!.localizedDescription)
                return
            }
            
            guard let results = results else {
                sendError("No results")
                return
            }

            completion(results.studentsLocation, nil)
        }
    }
    
    func getStudentLocation(withAccountKey accountKey: String, completion: @escaping (_ studentsLocation: StudentLocation?, _ errorString: String?) -> Void) {
        
        /* Set parameters */
        let parameters: [String:AnyObject] = [ParametersKeys.where_: "{\"\(JSONBodyKeys.uniqueKey)\":\"\(accountKey)\"}" as AnyObject]
        
        /* Make the request */
        let _ = taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (results: StudentLocationResponse?, error) in
            func sendError(_ errorString: String) {
                print(errorString)
                completion(nil, errorString)
            }
            
            guard error == nil else {
                sendError(error!.localizedDescription)
                return
            }
            
            guard let results = results else {
                sendError("No results")
                return
            }
            
            if results.studentsLocation.isEmpty {
                completion(nil, nil)
            } else {
                ParseClient.sharedInstance().objectID = results.studentsLocation[0].objectId
                completion(results.studentsLocation[0], nil)
            }
        }
    }
    
    func addStudentLocation(httpMethod: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let parameters: [String:AnyObject] = [:]
        
        func sendError(_ errorString: String) {
            completion(false, errorString)
        }
        
        guard let uniqueKey = UdacityClient.sharedInstance().accountKey else {
            sendError("Account Key not found")
            return
        }
        
        let jsonBody = [JSONBodyKeys.uniqueKey: uniqueKey,
                        JSONBodyKeys.firstName: UdacityClient.sharedInstance().firstName ?? "",
                        JSONBodyKeys.lastName: UdacityClient.sharedInstance().lastName ?? "",
                        JSONBodyKeys.mapString: mapString,
                        JSONBodyKeys.mediaURL: mediaURL,
                        JSONBodyKeys.latitude: latitude,
                        JSONBodyKeys.longitude: longitude] as [String:AnyObject]
        
        var apiMethod = Methods.StudentLocation
        
        if httpMethod == "PUT" {
            guard let objectID = ParseClient.sharedInstance().objectID else {
                sendError("objectID not found")
                return
            }
            
            apiMethod = substituteKeyInMethod(Methods.StudentLocationObjectID, key: URLKeys.StudentLocationObjectID, value: objectID)!
        }
        
        let _ = taskFor(httpMethod: httpMethod, apiMethod: apiMethod, parameters: parameters, jsonBody: jsonBody) { (results, error) in

            guard error == nil else {
                sendError(error!.localizedDescription)
                return
            }

            completion(true, nil)
        }
    }
}
