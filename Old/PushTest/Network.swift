//
//  Network.swift
//  UtilityApp
//
//  Created by Gene Backlin on 8/21/17.
//  Copyright © 2017 Gene Backlin. All rights reserved.
//

import UIKit

public class Network: NSObject {
    
    public func get(url: String, token: String, headers: [String : String], completion:@escaping(AnyObject?, [AnyHashable : Any]?, Error?)->Void) {
        weak var weakSelf = self
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
        request.httpMethod = "GET"
        
        for(headerKey, headerValue) in headers {
            request.setValue(headerValue, forHTTPHeaderField: headerKey)
        }
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let jsonData = data {
                let parsedJSON = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                
                if let json = parsedJSON as? [AnyObject] {
                    print("GET json: \(json)")
                    
                    if let responseReceived = response as? HTTPURLResponse, 200...299 ~= responseReceived.statusCode {
                        let headerFields = responseReceived.allHeaderFields
                        print("GET headerFields: \(headerFields)")
                        completion(json as AnyObject?, headerFields, nil)
                    } else {
                        completion(json as AnyObject?, nil, error)
                    }
                } else if let json = parsedJSON as? [String : AnyObject] {
                    print("GET json: \(json)")
                    
                    if let responseReceived = response as? HTTPURLResponse, 200...299 ~= responseReceived.statusCode {
                        let headerFields = responseReceived.allHeaderFields
                        print("GET headerFields: \(headerFields)")
                        completion(json as AnyObject?, headerFields, nil)
                    } else {
                        completion(json as AnyObject?, nil, error)
                    }
                } else {
                    let localError: NSError = weakSelf!.createError(domain: NSOSStatusErrorDomain, code: -1001, text: "No values in the JSON returned") as NSError
                    completion(nil, nil, localError)
                }
            } else {
                completion(data as AnyObject?, nil, error)
            }
        }
        
        task.resume()

    }
    
    public func post(url: String, token: String, headers: [String : AnyObject]?, parameters: [String : AnyObject]?, completion:@escaping(AnyObject?, [AnyHashable : Any]?, Error?)->Void) {

        do {
            var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
            request.httpMethod = "POST"
            
            if headers != nil {
                for(headerKey, headerValue) in headers! {
                    request.setValue(headerValue as? String, forHTTPHeaderField: headerKey)
                }
            }
            
            var postString = ""
            var parametersCount = 0
            if parameters != nil {
                for (key, value) in parameters! {
                    postString.append("\(key)=\(value)")
                    parametersCount += 1
                    if parametersCount < parameters!.count {
                        postString.append("&")
                    }
                }
                let postData = postString.data(using: .utf8)
                let postDataLength = "\(postData!.count)"
                request.setValue(postDataLength, forHTTPHeaderField: "Content-Length")
                request.httpBody = postData
            }

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let jsonData = data {
                    let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : AnyObject]
                    if json != nil {
                        print("POST json: \(json!)")
                        if let responseReceived = response as? HTTPURLResponse, 200...299 ~= responseReceived.statusCode {
                            let headerFields = responseReceived.allHeaderFields
                            print("POST headerFields: \(headerFields)")
                            completion(json as AnyObject?, headerFields, nil)
                        } else {
                            completion(json as AnyObject?, nil, error)
                        }
                    } else {
                        if let responseReceived = response as? HTTPURLResponse, 200...299 ~= responseReceived.statusCode {
                            let headerFields = responseReceived.allHeaderFields
                            print("POST headerFields: \(headerFields)")
                            completion(responseReceived as AnyObject?, headerFields, nil)
                        } else {
                            print("POST response: \(String(describing: response))")
                            let statusCode = (response as? HTTPURLResponse)?.statusCode
                            let message = "response status code: \(String(describing: statusCode))"
                            completion(message as AnyObject, nil, nil)
                        }
                    }
                } else {
                    completion(data as AnyObject?, nil, error)
                }
            }
            
            task.resume()
        }
        
    }
    
   
    func createError(domain: String, code: Int, text: String) -> Error {
        let userInfo: [String : String] = [NSLocalizedDescriptionKey: text]
        
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
    
}
