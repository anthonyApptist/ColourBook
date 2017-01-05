//
//  DataService-Retrieve.swift
//  ColourBook
//
//  Created by Anthony Ma on 25/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DataService {
    
    // MARK: - Locations
    
    func getLocationLists(screenState: ScreenState, user: User) {
        
        getLocationsRefFor(user: user, screenState: screenState)
        
        let locationsRef = self.generalRef
        
        locationsRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            user.items = []
            
            for child in snapshot.children.allObjects {
                
                let addressProfile = child as! FIRDataSnapshot
                
                let profile = addressProfile.value as? NSDictionary
                
                let postalCode = profile?["postalCode"] as! String
                
                let image = profile?["image"] as! String
                
                let name = addressProfile.key 
                
                let location = Location(locationName: name, postalCode: postalCode, image: image)
                
                user.items.append(location)
        
            }
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
            user.items = []
        })
        
    }
    
    func getLocationsRefFor(user: User, screenState: ScreenState) {

        if screenState == .business {
            self.generalRef = self.usersRef.child(user.uid).child(BusinessDashboard)
        }
        else if screenState == .homes {
            self.generalRef = self.usersRef.child(user.uid).child(AddressDashboard)
        }
        
    }
        
    // MARK: - Get Barcodes
    
    func getPaintArray(screenState: ScreenState, user: User, location: String?) {
        
        getBarcodeRefFor(user: user, screenState: screenState, location: location)
        
        let productsRef = self.generalRef
        
        productsRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            user.items = []
            
            for child in snapshot.children.allObjects {
                
                let profile = snapshot.childSnapshot(forPath: child as! String).value as? NSDictionary
                
                let productType = profile?["productType"] as! String
                
                let manufacturer = profile?["manufacturer"] as! String
                
                let upcCode = child as! String
                
                let image = profile?["image"] as! String
                
                let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image)
                
                user.items.append(product)
                
            }
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
            user.items = []
        })
        
    }
    
    func getBarcodesRefFor(user: User, screenState: ScreenState, location: String?) {
        
        if screenState == .personal {
            self.generalRef = self.usersRef.child(user.uid).child(PersonalDashboard).child(Barcodes)
        }
        else if screenState == .business {
            self.generalRef = self.usersRef.child(user.uid).child(BusinessDashboard).child(location!).child(Barcodes)
        }
        else if screenState == .homes {
            self.generalRef = self.usersRef.child(user.uid).child(AddressDashboard).child(location!).child(Barcodes)
        }
        
    }
    
}
