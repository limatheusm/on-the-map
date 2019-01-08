//
//  ParseClient.swift
//  on the map
//
//  Created by Matheus Lima on 02/01/19.
//  Copyright © 2019 Matheus Lima. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // MARK: Properties
    var session = URLSession.shared
    
    // MARK: GET
    func taskForGETMethod <T : Codable> (_ method: String, parameters: [String:AnyObject], codableResponse: T.Type?, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: self.createURLFromParameters(parameters, withPathExtension: method))
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: HeaderFields.ApplicationID)
        request.addValue(Constants.RestAPIKey, forHTTPHeaderField: HeaderFields.RestAPIKey)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError("Status code not found")
                return
            }
            
            guard (statusCode >= 200 && statusCode <= 299) else {
                sendError("Error status code: \(statusCode)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, codableResponse, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
}

// MARK: Singleton

extension ParseClient {
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}

// MARK: Helpers

extension ParseClient {
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    /* Decode JSON */
    private func convertDataWithCompletionHandler <T : Codable> (_ data: Data, _ codableResponse: T.Type?, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            if let codableResponse = codableResponse {
                parsedResult = try JSONDecoder().decode(codableResponse, from: data) as AnyObject
            } else {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            }
            completionHandlerForConvertData(parsedResult, nil)
        } catch let error {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
    }
    
    // create a URL from parameters
    func createURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}
