//
//  DataService - Transfer.swift
//  ColourBook
//
//  Created by Anthony Ma on 10/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation

extension DataService {
    
    func transfer(products: Dictionary<Paint, String>, user: User, location: String?, category: String) {
        for paint in products.keys {
            self.removeScannedProductFor(user: user, screenState: .personal, barcode: paint.upcCode, location: nil, category: category)
            
            let timestamp = products[paint]
            
            if let colour = paint.colour {
                let colourProfile: Dictionary<String, String> = ["productCode": colour.productCode, "colourName": colour.colourName, "manufacturer": colour.manufacturer, "manufacturerID": colour.manufacturerID, "hexcode": colour.colourHexCode]
                
                let paintProfile: Dictionary<String, Any> = ["manufacturer": paint.manufacturer, "productName": paint.productName, "category": paint.category, "code": paint.code, "image": paint.image, "product": "Paint", "colour": colourProfile, "timestamp": timestamp ?? ""]
                
                self.saveProductFor(location: location, screenState: .homes, barcode: paint.upcCode, value: paintProfile)
            }
            else {
                let paintProfile: Dictionary<String, Any> = ["manufacturer": paint.manufacturer, "productName": paint.productName, "category": paint.category, "code": paint.code, "image": paint.image, "product": "Paint", "timestamp": timestamp ?? ""]
                
                self.saveProductFor(location: location, screenState: .homes, barcode: paint.upcCode, value: paintProfile)
            }
            
        }
    }
    
}
