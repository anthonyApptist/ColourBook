//
//  DataService - Delete.swift
//  ColourBook
//
//  Created by Anthony Ma on 30/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Remove database nodes
extension DataService {
    
    // MARK: - Remove Location
    func removeLocationFor(screenState: ScreenState, locationName: String) {
        let ref = getAddressRefFor(screenState: screenState)
        
        // remove location from user list
        ref?.child(locationName).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
        })
    }
    
    // MARK: - Get Address Reference
    func getAddressRefFor(screenState: ScreenState) -> DatabaseReference? {
        if screenState == .business {
            let businessID = standardUserDefaults.value(forKey: "business") as! String
            return self.businessDashboardRef.child(businessID)
        }
        if screenState == .homes {
            let homeID = standardUserDefaults.value(forKey: "home") as! String
            return self.homeDashboardRef.child(homeID)
        }
        return nil
    }
    
    // MARK: - Remove Product (Public List) 
    func removeScannedProductForAddress(uniqueID: String, location: String?, category: String) {
        let removeRef = self.addressRef.child(location!).child("categories").child(category)
        
        removeRef.child(uniqueID).removeValue { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else {
                self.checkPublicPath(reference: ref.parent!, category: category, location: location)
            }
        }
    }
    
    /*
    func removeProduct(barcode: String, location: String?, category: String) {
        let removeRef = self.addressRef.child(location!).child("categories").child(category).child("barcodes")
        
        removeRef.child(barcode).removeValue { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else {
                self.checkPath(reference: removeRef.parent!, category: category, location: location)
            }
        }
    }
    */
    
    // MARK: - Remove Product
    func removeScannedProductFor(screenState: ScreenState, uniqueID: String, location: String?, category: String) {
        let ref = self.getBarcodeRefFor(screenState: screenState, location: location, category: category)
        
        // remove product from user list
        ref.child(uniqueID).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else {
                self.checkPath(reference: ref.parent!, category: category, location: location, screenState: screenState, uniqueID: uniqueID)
            }
        })
    }
    
    // MARK: - Check if category is deleted
    func checkPath(reference: DatabaseReference, category: String, location: String?, screenState: ScreenState, uniqueID: String) {
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                // do nothing
            }
            else {
                // add empty value to category branch
                reference.setValue("")
                if screenState == .business || screenState == .homes {
                    self.removeScannedProductForAddress(uniqueID: uniqueID, location: location, category: category)
                }
            }
        })
    }
    
    // MARK: - Check Public Path
    func checkPublicPath(reference: DatabaseReference, category: String, location: String?) {
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                // do nothing
            }
            else {
                // add empty value to category branch
                reference.setValue("")
            }
        })
    }

    
    func getBarcodeRefFor(screenState: ScreenState, location: String?, category: String) -> DatabaseReference {
        if screenState == .personal {
            let personalID = standardUserDefaults.value(forKey: "personal") as! String
            return self.personalDashboardRef.child(personalID).child(category)
        }
        if screenState == .business {
            let businessID = standardUserDefaults.value(forKey: "business") as! String
            return self.businessDashboardRef.child(businessID).child(location!).child("categories").child(category)
        }
        if screenState == .homes {
            let homeID = standardUserDefaults.value(forKey: "home") as! String
            return self.homeDashboardRef.child(homeID).child(location!).child("categories").child(category)
        }
        return self.publicRef
    }
    
}
