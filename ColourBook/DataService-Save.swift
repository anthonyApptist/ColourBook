//
//  DataService-Save.swift
//  ColourBook
//
//  Created by Anthony Ma on 29/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DataService {
    
    // MARK: - Public Database (House)
    
    func saveLocation(screenState: ScreenState, location: Location) {
        getLocationRef(screenState: screenState)
        
        if let locationRef = self.generalRef {
            let locationProfile: Dictionary<String, String> = ["postalCode": location.postalCode, "image": "", "name": ""]
            locationRef.child(location.locationName).setValue(locationProfile)
        }
    }
    
    // get database reference public
    
    func getLocationRef(screenState: ScreenState) {
        if screenState == .business {
            self.generalRef = self.businessRef
        }
        if screenState == .homes {
            self.generalRef = self.addressRef
        }
    }
    
    // MARK: - Public Database (Apartment)
    
    
    
    // MARK: Saving Profile Info
    
    func saveInfoFor(user: String, screenState: ScreenState, location: String?, image: String?, name: String?) {
        getSaveRef(screenState: screenState, user: user, location: location)
        
        let infoRef = self.generalRef
        infoRef?.updateChildValues(["image" : image ?? "", "name": name ?? ""])
    }
    
    func getSaveRef(screenState: ScreenState, user: String, location: String?) {
        if screenState == .personal {
            self.generalRef = self.usersRef.child(user)
        }
        else if screenState == .business {
            self.generalRef = self.usersRef.child(user).child(BusinessDashboard).child(location!)
        }
        else if screenState == .homes {
            self.generalRef = self.usersRef.child(user).child(AddressDashboard).child(location!)
        }
    }
    
    // MARK: Save Paint Can to Public Database
    
    func saveProductFor(location: String?, screenState: ScreenState, barcode: String, value: Dictionary<String, Any>) {
        getPublicLocationRef(screenState: screenState, location: location)
        let publicRef = self.generalRef
        publicRef?.child(barcode).setValue(value)
    }
    
    func getPublicLocationRef(screenState: ScreenState, location: String?) {
        
        if screenState == .business {
            self.generalRef = self.businessRef.child(location!).child(Barcodes)
        }
        else if screenState == .homes {
            self.generalRef = self.addressRef.child(location!).child(Barcodes)
        }
        
    }
    
    // MARK: Save Paint Can to User Database
    
    func saveProductFor(user: String, screenState: ScreenState, location: String?, barcode: String, value: Dictionary<String, Any>) {
        
        // reference
        getDashboardRef(screenState: screenState, user: user, location: location)
        let infoRef = self.generalRef

        infoRef?.child(barcode).setValue(value)
    }
    
    func getDashboardRef(screenState: ScreenState, user: String, location: String?) {
        
        if screenState == .personal {
            self.generalRef = self.usersRef.child(user).child(PersonalDashboard).child(Barcodes)
        }
        else if screenState == .business {
            self.generalRef = self.usersRef.child(user).child(BusinessDashboard).child(location!).child(Barcodes)
        }
        else if screenState == .homes {
            self.generalRef = self.usersRef.child(user).child(AddressDashboard).child(location!).child(Barcodes)
        }
        
    }
    
    // MARK: User Database (Apartment)
    
    func saveApartmentLocationTo(user: User, location: Location, screenState: ScreenState) {
        
        getUserlocationRef(screenState: screenState, user: user)
        
        if let locationRef = self.generalRef {
            let locationProfile: Dictionary<String, String> = ["postalCode": location.postalCode, "image": location.image!]
            locationRef.child(location.locationName).setValue(locationProfile)
        }
    }
    
    // MARK: User Database (House)
    
    // save location to user list
    
    func saveLocationTo(user: User, location: Location, screenState: ScreenState) {
        
        getUserlocationRef(screenState: screenState, user: user)
        
        if let locationRef = self.generalRef {
            let locationProfile: Dictionary<String, String> = ["postalCode": location.postalCode, "image": location.image!]
            locationRef.child(location.locationName).setValue(locationProfile)
        }
    }
    
    // get database reference user
    
    func getUserlocationRef(screenState: ScreenState, user: User) {
        if screenState == .business {
            self.generalRef = self.usersRef.child(user.uid).child(BusinessDashboard)
        }
        else if screenState == .homes {
            self.generalRef = self.usersRef.child(user.uid).child(AddressDashboard)
        }
    }
    
}
