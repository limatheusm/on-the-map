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
        
        let parameters: [String:AnyObject] = [:]
        
        let _ = taskForGETMethod(Methods.StudentLocation, parameters: parameters, codableResponse: StudentLocationResponse.self) { (results, error) in
            func sendError(_ errorString: String) {
                print(errorString)
                completion(nil, errorString)
            }
            
            guard (error == nil) else {
                sendError(error!.localizedDescription)
                return
            }
            
            guard let results = results as? StudentLocationResponse else {
                sendError("No results")
                return
            }

            completion(results.studentsLocation, nil)
        }
    }
}
