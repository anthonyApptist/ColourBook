//
//  DataService.swift
//  ColourBook
//
//  Created by Anthony Ma on 27/11/2016.
//  Copyright © 2016 Anthony Ma. All rights reserved.
//

// constants

//let Business = "business"
//let Address = "address"

let PersonalDashboard = "personalDashboard"
let BusinessDashboard = "businessDashboard"
let AddressDashboard = "addressDashboard"

let Barcodes = "barcodes"

import Foundation
import FirebaseDatabase


class DataService {
    private static let _instance = DataService()
    
    // public instance
    
    static var instance: DataService {
        return _instance
    }
    
    var generalRef: FIRDatabaseReference?
    
    //MARK: - Database References
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    // users reference
    
    var usersRef: FIRDatabaseReference {
        return mainRef.child("users")
    }
    
    
    // Public List Properties
    
    // businesses
    
    var businessRef: FIRDatabaseReference {
        return mainRef.child("businesses")
    }
    
    // addresses
    
    var addressRef: FIRDatabaseReference {
        return mainRef.child("addresses")
    }
    
    // barcodes
    
    var barcodeRef: FIRDatabaseReference {
        return mainRef.child("barcodes")
    }
    
    // colours
    
    var paintDataRef: FIRDatabaseReference {
        return mainRef.child("colours")
    }
    
    // MARK: - Database Config
    
    func savePaintData(manufacturerID: String, productCode: String, colourName: String, colourHexCode: String, manufacturer: String) {
        
        let paintProfile: Dictionary<String, String> = ["manufacturerID" : manufacturerID, "colourName" : colourName, "hexcode": colourHexCode, "manufacturer": manufacturer]
        
        paintDataRef.child(productCode).setValue(paintProfile)
    }
    
    func savePaintCanData(manufacturer: String, productName: String, category: String, code: String, upcCode: String, image: String, colour: String) {
        
        let paintCanProfile: Dictionary<String, AnyObject> = ["manufacturer": manufacturer as AnyObject, "productName": productName as AnyObject, "category": category as AnyObject, "code": code as AnyObject, "image": image as AnyObject, "colour": "" as AnyObject, "product": "Paint" as AnyObject]
        
        barcodeRef.child(upcCode).child("profile").setValue(paintCanProfile)
        
    }
    
}
