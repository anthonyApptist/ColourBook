//
//  DataBase.swift
//  ColourBook
//
//  Created by Anthony Ma on 2017-08-19.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

// Database References
class DataBase {
    
    // Database References
    var mainRef: DatabaseReference {
        return Database.database().reference()
    }
    
    // users reference
    var usersRef: DatabaseReference {
        return mainRef.child("users")
    }
    
    // Public List Properties
    var publicRef: DatabaseReference {
        return mainRef.child("public")
    }

    // businesses
    var businessRef: DatabaseReference {
        return publicRef.child("businesses")
    }
    
    // addresses
    var addressRef: DatabaseReference {
        return publicRef.child("addresses")
    }
    
    // barcodes
    var barcodeRef: DatabaseReference {
        return publicRef.child("barcodes")
    }
    
    // colours
    var paintDataRef: DatabaseReference {
        return publicRef.child("colours")
    }
    
    // personal dashboards
    var personalDashboardRef: DatabaseReference {
        return publicRef.child(kPersonalDashboard)
    }
    
    // business dashboards
    var businessDashboardRef: DatabaseReference {
        return publicRef.child(kBusinessDashboard)
    }
    
    // home dashboards
    var homeDashboardRef: DatabaseReference {
        return publicRef.child(kHomeDashboard)
    }
    
    // MARK: - Storage References
    var mainStorageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://colourbook-4961e.appspot.com/")
    }
    
    // MARK: - Create Unique ID
    func createUniqueID() -> String {
        let uniqueID = NSUUID().uuidString
        return uniqueID
    }
    
}
