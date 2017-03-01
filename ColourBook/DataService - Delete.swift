//
//  DataService - Delete.swift
//  ColourBook
//
//  Created by Anthony Ma on 30/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DataService {
    
    // MARK: - Remove Location
    
    func removeLocationFor(user: User, screenState: ScreenState, locationName: String) {
        
        getAddressRefFor(user: user, screenState: screenState)
        
        let locationRef = self.generalRef
        
        // remove location from user list
        
        locationRef?.child(locationName).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
        })
        
    }
    
    func getAddressRefFor(user: User, screenState: ScreenState) {
        if screenState == .business {
            self.generalRef = self.usersRef.child(user.uid).child(BusinessDashboard)
        }
        if screenState == .homes {
            self.generalRef = self.usersRef.child(user.uid).child(AddressDashboard)
        }
    }
    
    // MARK: - Remove Product (Public List) 
    func removeScannedProductForAddress(barcode: String, location: String?, category: String) {
        let removeRef = self.addressRef.child(location!).child("businessAdded").child("categories").child(category).child("barcodes")
        
        removeRef.child(barcode).removeValue { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else {
                self.checkPath(reference: removeRef.parent!, category: category, location: location)
            }
        }
    }
    
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
    
    
    // MARK: - Remove Product
    
    func removeScannedProductFor(user: User, screenState: ScreenState, barcode: String, location: String?, category: String) {
        
        self.getBarcodeRefFor(user: user, screenState: screenState, location: location, category: category)
        let locationRef = self.generalRef
        
        // remove product from user list
        locationRef?.child(barcode).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else {
                self.checkPath(reference: locationRef!.parent!, category: category, location: location)
            }
        })
    }
    
    func checkPath(reference: FIRDatabaseReference, category: String, location: String?) {
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                // do nothing
            }
            else {
                // add empty to category branch
                reference.setValue("")
            }
        })
    }
    
    func getBarcodeRefFor(user: User, screenState: ScreenState, location: String?, category: String) {
        if screenState == .personal {
            self.generalRef = self.usersRef.child(user.uid).child(PersonalDashboard).child(category).child(Barcodes)
        }
        if screenState == .business {
            self.generalRef = self.usersRef.child(user.uid).child(BusinessDashboard).child("addresses").child(location!).child("categories").child(category).child(Barcodes)
        }
        if screenState == .homes {
            self.generalRef = self.usersRef.child(user.uid).child(AddressDashboard).child(location!).child("categories").child(category).child(Barcodes)
        }
    }
    
}
