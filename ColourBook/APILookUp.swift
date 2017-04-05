//
//  APILookUp.swift
//  ColourBook
//
//  Created by Anthony Ma on 29/3/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit

let apiString = "https://api.upcitemdb.com/prod/trial/lookup?upc="

extension PostScanViewController {
    
    func apiLookUp() {
        
        // append barcode to end of api string to access JSON
        let apiLookupString = apiString + self.barcode!
        
        // api url
        let apiURL = URL(string: apiLookupString)
        
        // api request from URL
        var apiRequest = URLRequest(url: apiURL!)
        
        // set request
        apiRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: apiRequest) {data, response, error in
            if error == nil && data != nil {
                do {
                    let dictionaryData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                    
                    
                }
                catch {
                    
                }
            }
        }; task.resume()    
    }
    
}
