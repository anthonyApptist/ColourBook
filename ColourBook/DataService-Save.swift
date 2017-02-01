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
    
    func saveApartment(screenState: ScreenState, location: Location) {
        getLocationRef(screenState: screenState)
        
        if let locationRef = self.generalRef {
            let locationProfile: Dictionary<String, String> = ["postalCode": location.postalCode, "image": "", "name": ""]
            locationRef.child(location.locationName).setValue(locationProfile)
        }
    }
    
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
    
    func getPublicLocationCategoriesRef(screenState: ScreenState, location: String?) {
        if screenState == .business {
            self.generalRef = self.businessRef.child(location!).child("categories")
        }
        else if screenState == .homes {
            self.generalRef = self.addressRef.child(location!).child("categories")
        }
    }
    
    // MARK: Save Paint Can to Public Database (w/ category)
    
    func saveProductIn(location: String?, screenState: ScreenState, barcode: String, value: Dictionary<String, Any>, category: String) {
        getPublicLocationCategoriesRef(screenState: screenState, location: location)
        let publicRef = self.generalRef?.child(category)
        publicRef?.child(barcode).setValue(value)
    }
    
    // MARK: Save Paint Can to User Database (w/ category)
    
    func saveProductIn(user: String, screenState: ScreenState, location: String?, barcode: String, value: Dictionary<String, Any>, category: String) {
        // reference
        getDashboardRef(screenState: screenState, user: user, location: location)
        let infoRef = self.generalRef?.child(category)
        
        infoRef?.child(barcode).setValue(value)
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
            self.generalRef = self.usersRef.child(user).child(BusinessDashboard).child(location!).child("categories")
        }
        else if screenState == .homes {
            self.generalRef = self.usersRef.child(user).child(AddressDashboard).child(location!).child("categories")
        }
        
    }
    
    // MARK: User Database (Apartment)
    
    func saveApartmentLocationTo(user: User, location: Location, screenState: ScreenState) {
        
        getUserlocationRef(screenState: screenState, user: user)
        let locationRef = self.generalRef
        let newCategories = self.startingCategories(screenState: screenState)
        
        let locationProfile: Dictionary<String, Any> = ["postalCode": location.postalCode, "image": location.image!, "categories": newCategories ?? [:]]
        locationRef?.child(location.locationName).setValue(locationProfile)
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
    
    func startingCategories(screenState: ScreenState) -> Dictionary<String, String>? {
        if screenState == .business {
            let locationDefaultCategories: Dictionary<String, String> = ["Interior re-paint": "", "Exterior re-paint": "", "Commercial": "", "Homebuilders": "", "Renovations": ""]
            return locationDefaultCategories
        }
        if screenState == .homes {
            let locationDefaultCategories: Dictionary<String, String> = ["Kitchen": "", "Living Room": "", "Dining Room": "", "Bathroom": "", "Bedrooms": "", "Garage": "", "Garage": "", "Exterior": "", "Trim": "", "Hallway": ""]
            return locationDefaultCategories
        }
        return nil
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
