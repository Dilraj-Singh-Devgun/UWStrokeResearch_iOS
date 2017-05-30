//
//  DatabaseConnection.swift
//  UWStrokeResearch
//
//  Created by Dilraj Devgun on 5/29/17.
//  Copyright © 2017 Dilraj Devgun. All rights reserved.
//

import Foundation

protocol DatabaseProtocol {
    func databaseSetupCallback(response: String?)
}

public class DatabaseConnection {
    
    class func makeGetRequestForJSONFile(callback: DatabaseProtocol) {
        
        // Send HTTP GET Request
        
        // Define server side script URL
        let scriptUrl = "https://depts.washington.edu/strokema/connect/test_dbpost.php?test_id=uw-stroke-decision-tree"
        // Add one parameter
        let urlWithParams = scriptUrl + ""
        // Create NSURL Ibject
        let myUrl = URL(string: urlWithParams)
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl!);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error \(String(describing: error))")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            callback.databaseSetupCallback(response: responseString as String?)
        }
        
        task.resume()
        
    }
}
