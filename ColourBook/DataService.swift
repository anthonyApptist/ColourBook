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
    
    var usersPersonalDashboardRef: FIRDatabaseReference {
        return mainRef.child("users").child("personalDashboard")
    }
    
    var usersBusinessDashboardRef: FIRDatabaseReference {
        return mainRef.child("users").child("businessDashboard")
    }
    
    // paint data reference
    var paintDataRef: FIRDatabaseReference {
        return mainRef.child("paintData")
    }
    
    // paint can reference
    var paintCanRef: FIRDatabaseReference {
        return mainRef.child("paintCans")
    }
    
    func saveRegisterUser(uid: String, email: String, name: String) {
        let profile: Dictionary<String, AnyObject> = ["email": email as AnyObject, "name": name as AnyObject]
    }
    
    func savePaintData(manufactuerID: String, productCode: String, colourName: String, colourHexCode: String) {
        
        let paintProfile: Dictionary<String, AnyObject> = ["manufactuerID" : manufactuerID as AnyObject, colourName : productCode as AnyObject]
        
        let hexCode = colourHexCode
        
        print(colourName)
        
        paintDataRef.child(hexCode).setValue(paintProfile)
    }
    
    func savePaintCanData(manufactuer: String, productName: String, category: String, code: String, upcCode: String, image: String) {
        
        let paintCanProfile: Dictionary<String, AnyObject> = ["manufactuer" : manufactuer as AnyObject, "productName" : productName as AnyObject, "category" : category as AnyObject, productName : productName as AnyObject]
        
        paintCanRef.child(upcCode).child("profile").setValue(paintCanProfile)
        
        paintCanRef.child("image").setValue(image)
        
    }
    
}
