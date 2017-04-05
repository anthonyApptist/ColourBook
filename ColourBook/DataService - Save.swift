//
//  DataService - Save.swift
//  ColourBook
//
//  Created by Anthony Ma on 29/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DataService {
    
    // MARK: - Public Database (Create new)
    
    // Save a business or address
    
    func saveAddress(screenState: ScreenState, location: Location?) {
        getLocationRef(screenState: screenState, location: location)
        
        let newCategories = self.startingCategories(screenState: screenState)
        let locationRef = self.generalRef
        
        if screenState == .business {
            let locationProfile: [String:Any] = ["postalCode": location!.postalCode, "categories": newCategories ?? ""]
            locationRef?.updateChildValues(locationProfile)
        }
        if screenState == .homes {
            let locationProfile: Dictionary<String, Any> = ["postalCode": location!.postalCode, "categories": newCategories ?? ""]
            locationRef?.updateChildValues(locationProfile)
        }
    }
    
    // Public Database refs
    
    func getLocationRef(screenState: ScreenState, location: Location?) {
        if screenState == .business {
            self.generalRef = self.addressRef.child(location!.locationName)
        }
        if screenState == .homes {
            self.generalRef = self.addressRef.child(location!.locationName)
        }

    }
    
    // Address item save
    
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
    
    // MARK: Save Paint Can to Location (Public)
    
    func saveProductFor(location: String?, screenState: ScreenState, product: ScannedProduct, category: String) {
        
        getPublicLocationCategoriesRef(screenState: screenState, location: location, category: category)
        let publicRef = self.generalRef
        
        var value: [String:Any]? = [:]
        
        value?.updateValue(product.upcCode, forKey: "barcode")
        value?.updateValue(product.productName, forKey: "productName")
        value?.updateValue(product.productType, forKey: "product")
        value?.updateValue(product.manufacturer, forKey: "manufacturer")
        value?.updateValue(product.image, forKey: "image")
        value?.updateValue(product.timestamp!, forKey: "timestamp")
        
        if let code = product.code {
            value?.updateValue(code, forKey: "code")
        }
        if let category = product.category {
            value?.updateValue(category, forKey: "category")
        }
        
        // colour
        if let colour = product.colour {
            let colourProfile: [String:String] = ["productCode": colour.productCode, "colourName": colour.colourName, "manufacturer": colour.manufacturer, "manufacturerID": colour.manufacturerID, "hexcode": colour.colourHexCode]
            
            value?.updateValue(colourProfile, forKey: "colour")
        }
        if let businessAdded = product.businessAdded {
            value?.updateValue(businessAdded, forKey: "businessAdded")
        }
        
        publicRef?.child(product.uniqueID!).setValue(value)
    }
    
    func getPublicLocationCategoriesRef(screenState: ScreenState, location: String?, category: String) {
        if screenState == .business {
            self.generalRef = self.addressRef.child(location!).child("categories").child(category).child(Barcodes)
        }
        if screenState == .homes {
            self.generalRef = self.addressRef.child(location!).child("categories").child(category).child(Barcodes)
        }
    }
    
    // MARK: Save Paint Can to User Database (Personal)
    
    func saveProductIn(user: String, screenState: ScreenState, location: String?, product: ScannedProduct, category: String) {
        
        getDashboardRef(screenState: screenState, user: user, location: location, category: category)
        let infoRef = self.generalRef
        
        var value: [String:Any]? = [:]
        
        value?.updateValue(product.upcCode, forKey: "barcode")
        value?.updateValue(product.productName, forKey: "productName")
        value?.updateValue(product.productType, forKey: "product")
        value?.updateValue(product.manufacturer, forKey: "manufacturer")
        value?.updateValue(product.image, forKey: "image")
        value?.updateValue(product.timestamp!, forKey: "timestamp")
        
        if let code = product.code {
            value?.updateValue(code, forKey: "code")
        }
        if let category = product.category {
            value?.updateValue(category, forKey: "category")
        }
        
        // colour
        if let colour = product.colour {
            let colourProfile: [String:String] = ["productCode": colour.productCode, "colourName": colour.colourName, "manufacturer": colour.manufacturer, "manufacturerID": colour.manufacturerID, "hexcode": colour.colourHexCode]
            
            value?.updateValue(colourProfile, forKey: "colour")
        }
        
        if let businessAdded = product.businessAdded {
            value?.updateValue(businessAdded, forKey: "businessAdded")
        }
        
        infoRef?.child(product.uniqueID!).setValue(value)
    }
    
    func getDashboardRef(screenState: ScreenState, user: String, location: String?, category: String) {
        
        if screenState == .personal {
            self.generalRef = self.usersRef.child(user).child(PersonalDashboard).child(category).child(Barcodes)
        }
        else if screenState == .business {
            self.generalRef = self.usersRef.child(user).child(BusinessDashboard).child("addresses").child(location!).child("categories").child(category).child(Barcodes)
        }
        else if screenState == .homes {
            self.generalRef = self.usersRef.child(user).child(AddressDashboard).child(location!).child("categories").child(category).child(Barcodes)
        }
        
    }
    
    // MARK: User Database 
    
    // Save Address
    
    func saveAddressTo(user: User, location: Location, screenState: ScreenState) {
        
        getUserlocationRef(screenState: screenState, user: user)
        let locationRef = self.generalRef
        let newCategories = self.startingCategories(screenState: screenState)
        
        let locationProfile: Dictionary<String, Any> = ["postalCode": location.postalCode, "categories": newCategories ?? [:]]
        locationRef?.child(location.locationName).setValue(locationProfile)
    }
    
    // User Dashboard Reference
    
    func getUserlocationRef(screenState: ScreenState, user: User) {
        if screenState == .business {
            self.generalRef = self.usersRef.child(user.uid).child(BusinessDashboard).child("addresses")
        }
        else if screenState == .homes {
            self.generalRef = self.usersRef.child(user.uid).child(AddressDashboard)
        }
    }
    
    // MARK: - Save New User
    
    // Create new
    
    func createNewUser(uid: String, email: String, image: String) {
        
        let dashboardCats: Dictionary<String, String> = ["Kitchen": "", "Living Room": "", "Dining Room": "", "Bathroom": "", "Bedrooms": "", "Garage": "", "Exterior": "", "Trim": "", "Hallway": "", "Unsorted": ""]
        
        let newProfile: Dictionary<String, Any> = ["email": email, PersonalDashboard: dashboardCats]
        
        usersRef.child(uid).setValue(newProfile)
        
    }
    
    // Starting Categories
    
    func startingCategories(screenState: ScreenState) -> Dictionary<String, String>? {
        if screenState == .business {
            let locationDefaultCategories: Dictionary<String, String> = ["Kitchen": "", "Living Room": "", "Dining Room": "", "Bathroom": "", "Bedrooms": "", "Interior re-paint": "", "Exterior re-paint": "", "Garage":"", "Trim": "", "Hallway": "", "Renovations": "", "Unsorted": ""]
            return locationDefaultCategories
        }
        if screenState == .homes {
            let locationDefaultCategories: Dictionary<String, String> = ["Kitchen": "", "Living Room": "", "Dining Room": "", "Bathroom": "", "Bedrooms": "", "Interior re-paint": "", "Exterior re-paint": "", "Garage":"", "Trim": "", "Hallway": "", "Renovations": "", "Unsorted": ""]
            return locationDefaultCategories
        }
        return nil
    }
    
}
