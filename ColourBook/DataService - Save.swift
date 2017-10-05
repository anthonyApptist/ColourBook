//
//  DataService - Save.swift
//  ColourBook
//
//  Created by Anthony Ma on 29/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Write to database
extension DataService {
    
    // MARK: Public
    /*
    // MARK: - Public Database Reference
    func getLocationRef(screenState: ScreenState, location: Location?) -> DatabaseReference {
        if screenState == .business {
            return self.addressRef.child(location!.locationName)
        }
        if screenState == .homes {
            return self.addressRef.child(location!.locationName)
        }
    }
    
    // MARK: - Address item save
    func saveInfoFor(user: String, screenState: ScreenState, location: String?, image: String?, name: String?) {
        getSaveRef(screenState: screenState, user: user, location: location)
        
        let infoRef = self.generalRef
        infoRef?.updateChildValues(["image" : image ?? "", "name": name ?? ""])
    }
    
    func getSaveRef(screenState: ScreenState, user: String, location: String?) -> DatabaseReference {
        if screenState == .personal {
            return self.usersRef.child(user)
        }
        else if screenState == .business {
            self.generalRef = self.usersRef.child(user).child(BusinessDashboard).child(location!)
        }
        else if screenState == .homes {
            self.generalRef = self.usersRef.child(user).child(AddressDashboard).child(location!)
        }
    }
    
    // MARK: Save Paint Can to Public Lists
    func savePaintCanToPublic(location: String?, screenState: ScreenState, product: PaintCan, category: String) {
        
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
    */
    // MARK: - Save User Personal Info
    func saveUserPersonalInfo(name: String) {
        let userUID = standardUserDefaults.value(forKey: "uid") as! String
        self.usersRef.child(userUID).updateChildValues(["name":name])
    }
    
    // MARK: - Save Address Profile Info
    func saveAddressInfoToUserList(image: String) {
        
    }
    
    // MARK: - Save address to user list
    func saveAddressToUserListOnly(location: Address, screenState: ScreenState) {
        // check for unique list id
        if checkForUniqueID(screenState: screenState) { // true
            let locationRef = self.getUserlocationRef(screenState: screenState)
            let startingCategories = self.startingCategories(screenState: screenState)
            
            let locationProfile: [String:Any] = ["postalCode": location.postalCode!, "categories": startingCategories]
            locationRef?.child(location.address!).updateChildValues(locationProfile)
        }
        else {
            // no list id created for screen state
            self.saveNewUniqueListID(screenState: screenState)
            
            // call function again to save new location
            self.saveAddressToUserListOnly(location: location, screenState: screenState)
        }
    }
    
    func getPublicLocationCategoriesRef(location: String?, category: String) -> DatabaseReference {
        return self.addressRef.child(location!).child("categories").child(category)
    }
    
    // MARK: Save Paint Can to Dashboard
    func savePaintCanToDashboard(screenState: ScreenState, location: String?, product: PaintCan, category: String) {
        let dashboardRef = self.getDashboardRef(screenState: screenState, location: location, category: category)
        
        var value: [String:Any] = [:]
        
        value.updateValue(product.upcCode!, forKey: "barcode")
        value.updateValue(product.name!, forKey: "name")
        value.updateValue(product.type!, forKey: "type")
        value.updateValue(product.manufacturer!, forKey: "manufacturer")
        value.updateValue(product.image!, forKey: "image")
        value.updateValue(product.timestamp!, forKey: "timestamp")
        
        // paint can code
        if let code = product.code {
            value.updateValue(code, forKey: "code")
        }
        
        // paint can category
        if let category = product.category {
            value.updateValue(category, forKey: "category")
        }
        
        // colour
        if let colour = product.colour {
            let colourProfile: [String:String] = ["productCode": colour.productCode!, "name": colour.name!, "manufacturer": colour.manufacturer!, "manufacturerID": colour.manufacturerID!, "hexcode": colour.hexCode!]
            value.updateValue(colourProfile, forKey: "colour")
        }
        
        // business
        if let business = product.businessAdded {
            value.updateValue(business, forKey: "businessAdded")
        }
        
        dashboardRef.child(product.uniqueID!).updateChildValues(value)
        
        // save to public
        if screenState == .business {
            let publicRef = self.getPublicLocationCategoriesRef(location: location, category: category)
            publicRef.child(product.uniqueID!).updateChildValues(value)
        }
        if screenState == .homes {
            let publicRef = self.getPublicLocationCategoriesRef(location: location, category: category)
            publicRef.child(product.uniqueID!).updateChildValues(value)
        }
    }
    
    // MARK: - Get Dashboard Ref
    func getDashboardRef(screenState: ScreenState, location: String?, category: String) -> DatabaseReference {
        if screenState == .personal {
            let personalDashboardID = standardUserDefaults.value(forKey: "personal") as! String
            return self.personalDashboardRef.child(personalDashboardID).child(category)
        }
        if screenState == .business {
            let businessDashboardID = standardUserDefaults.value(forKey: "business") as! String
            return self.businessDashboardRef.child(businessDashboardID).child(location!).child("categories").child(category)
        }
        if screenState == .homes {
            let homeDashboardID = standardUserDefaults.value(forKey: "home") as! String
            return self.homeDashboardRef.child(homeDashboardID).child(location!).child("categories").child(category)
        }
        else {
            return DataService.instance.publicRef
        }
    }
    
    // MARK: User Business or Homes
    
    // MARK: - Save an Address
    func saveNewAddress(location: Address, screenState: ScreenState) {
        // check for unique list id
        if checkForUniqueID(screenState: screenState) {
            let locationRef = self.getUserlocationRef(screenState: screenState)
            let startingCategories = self.startingCategories(screenState: screenState)
            
            let locationProfile: [String:Any] = ["postalCode": location.postalCode!, "categories": startingCategories]
            locationRef?.child(location.address!).updateChildValues(locationProfile)
            
            // add to public list
            self.addressRef.child(location.address!).updateChildValues(locationProfile)
        }
        else {
            // no list id created for screen state
            self.saveNewUniqueListID(screenState: screenState)
            
            // call function again to save new location
            self.saveNewAddress(location: location, screenState: screenState)
        }
    }
    
    // MARK: - User Location Dashboard Reference
    func getUserlocationRef(screenState: ScreenState) -> DatabaseReference? {
        if screenState == .business {
            let businessID = standardUserDefaults.value(forKey: "business") as! String
            return self.businessDashboardRef.child(businessID)
        }
        else if screenState == .homes {
            let homeID = standardUserDefaults.value(forKey: "home") as! String
            return self.homeDashboardRef.child(homeID)
        }
        return nil
    }
    
    // MARK: - Starter Categories, Business and Address
    func startingCategories(screenState: ScreenState) -> [String:String] {
        if screenState == .business {
            let businessDefaultCategories: [String: String] = ["Kitchen": "", "Living Room": "", "Dining Room": "", "Bathroom": "", "Bedrooms": "", "Interior re-paint": "", "Exterior re-paint": "", "Garage":"", "Trim": "", "Hallway": "", "Renovations": "", "Unsorted": ""]
            return businessDefaultCategories
        }
        if screenState == .homes {
            let homeDefaultCategories: [String: String] = ["Kitchen": "", "Living Room": "", "Dining Room": "", "Bathroom": "", "Bedrooms": "", "Interior re-paint": "", "Exterior re-paint": "", "Garage":"", "Trim": "", "Hallway": "", "Renovations": "", "Unsorted": ""]
            return homeDefaultCategories
        }
        return [:]
    }

    // MARK: - Save New User
    func saveNewUser(uid: String, email: String) {
        let personalDashboardID = self.createUniqueID() // unique id for user's personal list
        
        // personal dashboard categories
        let dashboardCats: [String:String] = ["Kitchen": "", "Living Room": "", "Dining Room": "", "Bathroom": "", "Bedrooms": "", "Garage": "", "Exterior": "", "Trim": "", "Hallway": "", "Unsorted": ""]
        let newProfile: Dictionary<String, Any> = ["email": email, kPersonalDashboard: personalDashboardID]
        self.usersRef.child(uid).setValue(newProfile)
        
        // user defaults
        standardUserDefaults.set(uid, forKey: "uid")
        standardUserDefaults.set(personalDashboardID, forKey: "personal")
        
        // save new personal dashboard to public ref
        self.personalDashboardRef.child(personalDashboardID).setValue(dashboardCats)
    }
    
    // MARK: - Create New Category
    func createNewCategory(newCategory: String) {
        let personalID = standardUserDefaults.value(forKey: "personal") as! String
        self.personalDashboardRef.child(personalID).child(newCategory).setValue("")
    }
    
    // MARK: - Check Unique ID
    func checkForUniqueID(screenState: ScreenState) -> Bool {
        if screenState == ScreenState.business {
            if standardUserDefaults.value(forKey: "business") != nil {
                return true
            }
            else {
                return false
            }
        }
        if screenState == ScreenState.homes {
            if standardUserDefaults.value(forKey: "home") != nil {
                return true
            }
            else {
                return false
            }
        }
        return true
    }
    
    // MARK: - Save New Address Name
    func saveNewAddressName(name: String, location: String, screenState: ScreenState) {
        if screenState == .business  {
            let businessID = standardUserDefaults.value(forKey: "business") as! String
            self.businessDashboardRef.child(businessID).child(location).updateChildValues(["name": name])
        }
        if screenState == .homes {
            let homeID = standardUserDefaults.value(forKey: "home") as! String
            self.homeDashboardRef.child(homeID).child(location).updateChildValues(["name": name])
        }
    }
    
    // MARK: - Save New Name
    func saveNewUserName(name: String) {
        let uid = standardUserDefaults.value(forKey: "uid") as! String
        self.usersRef.child(uid).updateChildValues(["name":name])
    }
    
    // MARK: - Save New Business Unique ID
    func saveNewUniqueListID(screenState: ScreenState) {
        let uid = standardUserDefaults.value(forKey: "uid") as! String
        let uniqueID = self.createUniqueID() // unique id for new list
        
        switch screenState {
        case .business:
            let childUpdate: [String:String] = [kBusinessDashboard: uniqueID]
            // user ref update
            self.usersRef.child(uid).updateChildValues(childUpdate)
            // save to user defaults
            standardUserDefaults.set(uniqueID, forKey: "business")
            break
        case .homes:
            let childUpdate: [String:String] = [kHomeDashboard: uniqueID]
            // user ref update
            self.usersRef.child(uid).updateChildValues(childUpdate)
            // save to user defaults
            standardUserDefaults.set(uniqueID, forKey: "home")
            break
        default:
            break
        }
    }
}
