//
//  DataService.swift
//  ColourBook
//
//  Created by Anthony Ma on 27/11/2016.
//  Copyright © 2016 Anthony Ma. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol BusinessProfileDelegate {
    func noBusinessProfile()
    func businessEntryCreated()
}

// Database Functions for Firebase
class DataService: DataBase {
    private static let _instance = DataService()
    
    // public instance
    static var instance: DataService {
        return _instance
    }
    
    var businessDelegate: BusinessProfileDelegate?
    
    // MARK: - Save Paint Colour Data (database)
    func savePaintDataForDatabase(manufacturerID: String, productCode: String, colourName: String, colourHexCode: String, manufacturer: String) {
        var paintProfile: [String:String] = ["colourName" : colourName, "hexcode": colourHexCode, "manufacturer": manufacturer, "productCode": productCode]
        
        if !(manufacturerID.isEmpty) {
            paintProfile.updateValue(manufacturerID, forKey: "manufacturerID")
        }
        paintDataRef.child(manufacturer).child(productCode).setValue(paintProfile)
    }
    
    // MARK: - Save Paint Can Data (database)
    func savePaintCanDataForDatabase(manufacturer: String, productName: String, category: String?, code: String?, upcCode: String, image: String) {
        
        let paintCanProfile: Dictionary<String, String> = ["manufacturer": manufacturer, "productName": productName, "image": image, "product": "Paint", "code": code!]
        barcodeRef.child(upcCode).child("profile").setValue(paintCanProfile)
    }
    
}
