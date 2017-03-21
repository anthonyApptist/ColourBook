//
//  DataService - Transfer.swift
//  ColourBook
//
//  Created by Anthony Ma on 10/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation

extension DataService {
    
    // transfer to a home in address list
    
    func transfer(products: Dictionary<Paint, String>, user: User, location: String?, category: String, destination: String) {
        for paint in products.keys {
            self.removeScannedProductFor(user: user, screenState: .personal, barcode: paint.uniqueID!, location: nil, category: category)
            
            let timestamp = products[paint]
            
            if let colour = paint.colour {
                let colourProfile: Dictionary<String, String> = ["productCode": colour.productCode, "colourName": colour.colourName, "manufacturer": colour.manufacturer, "manufacturerID": colour.manufacturerID, "hexcode": colour.colourHexCode]
                
                let paintProfile: Dictionary<String, Any> = ["manufacturer": paint.manufacturer, "productName": paint.productName, "category": paint.category, "code": paint.code, "image": paint.image, "product": "Paint", "colour": colourProfile, "timestamp": timestamp ?? "", "barcode": paint.upcCode]
                
                self.saveProductIn(user: user.uid, screenState: .homes, location: location, value: paintProfile, category: destination, uniqueID: paint.uniqueID!)
                
                self.saveProductFor(location: location, screenState: .homes, value: paintProfile, category: destination, uniqueID: paint.uniqueID!)
            }
            else {
                let paintProfile: Dictionary<String, Any> = ["manufacturer": paint.manufacturer, "productName": paint.productName, "category": paint.category, "code": paint.code, "image": paint.image, "product": "Paint", "timestamp": timestamp ?? "", "barcode": paint.upcCode]
                
                self.saveProductIn(user: user.uid, screenState: .homes, location: location, value: paintProfile, category: destination, uniqueID: paint.uniqueID!)
                
                self.saveProductFor(location: location, screenState: .homes, value: paintProfile, category: destination, uniqueID: paint.uniqueID!)
            }
            
        }
    }
    
}
