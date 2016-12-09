//
//  DataService.swift
//  ColourBook
//
//  Created by Anthony Ma on 27/11/2016.
//  Copyright © 2016 Anthony Ma. All rights reserved.
//

import Foundation
import FirebaseDatabase


class DataService {
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    //MARK: Database
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    // users reference
    var usersRef: FIRDatabaseReference {
        return mainRef.child("users")
    }
    
    // address reference
    var addressRef: FIRDatabaseReference {
        return mainRef.child("addresses")
    }
    
    // barcode reference
    var barcodeRef: FIRDatabaseReference {
        return mainRef.child("barcodes")
    }
    
    // paint data reference
    var paintDataRef: FIRDatabaseReference {
        return mainRef.child("paintData")
    }
    
    func saveRegisterUser(uid: String, email: String, name: String) {
        let profile: Dictionary<String, AnyObject> = ["email": email as AnyObject, "name": name as AnyObject]
    }
    
    func savePaintData(manufactuerID: String, productCode: String, colourName: String, colourHexCode: String) {
        
        let paintProfile: Dictionary<String, AnyObject> = ["manufactuerID" : manufactuerID as AnyObject, "colourName" : colourName as AnyObject, "productCode": productCode as AnyObject]
        
        let hexCode = colourHexCode
        
        paintDataRef.child(hexCode).setValue(paintProfile)
    }
    
    func savePaintCanData(manufacturer: String, productName: String, category: String, code: String, upcCode: String, image: String) {
        
        let paintCanProfile: Dictionary<String, AnyObject> = ["manufacturer": manufacturer as AnyObject, "productName": productName as AnyObject, "category": category as AnyObject, "code": code as AnyObject, "image": image as AnyObject, "product": "paint can" as AnyObject]
        
        barcodeRef.child(upcCode).child("profile").setValue(paintCanProfile)
        
    }
    
    func createNewUser(uid: String, email: String) {
        
        let dashboards: Dictionary<String, AnyObject> = ["addressDashboard": "" as AnyObject, "businessDashboard": "" as AnyObject, "personalDashboard": "" as AnyObject]
        
        usersRef.child(uid).setValue(dashboards)
        
    }
    
}
