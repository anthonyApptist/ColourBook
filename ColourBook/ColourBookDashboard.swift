//
//  ColourBookDashboard.swift
//  ColourBook
//
//  Created by Anthony Ma on 2017-08-26.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol AddressLoadingComplete {
    func addressLoadingComplete(allAddresses: [Address])
}

class ColourBookDashboard: ColourBook {
    
    // Properties
    
    // Business Data
    let businessRef = DataService.instance.businessRef
    var businessImages = [String:String]()
    
    // Address Data
    let addressRef = DataService.instance.addressRef
    var locationItems = [String:[String:[PaintCan]]]()
    var allAddresses = [Address]()
    
    // address load delegate
    var loadAddressDelegate: AddressLoadingComplete?
    
    // MARK: - Dashboard Setup
    func dashboardSetup() {
        self.showActivityIndicator()
        self.saveSignedInExistingUser()
        self.getBusinessAndImages()
//        self.getPublicAddresses()
    }
    
    // MARK: - Save Signed In Existing User
    func saveSignedInExistingUser() {
        let uid = standardUserDefaults.value(forKey: "uid") as! String
        
        DataService.instance.usersRef.child(uid).observe(.value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            if let email = snapshotValue?["email"] as? String {
                standardUserDefaults.set(email, forKey: "email")
            }
            if let name = snapshotValue?["name"] as? String {
                standardUserDefaults.set(name, forKey: "name")
            }
            if let image = snapshotValue?["image"] as? String {
                standardUserDefaults.set(image, forKey: "image")
            }
            if let personalDashboardID = snapshotValue?[kPersonalDashboard] as? String {
                standardUserDefaults.set(personalDashboardID, forKey: "personal")
            }
            if let businessDashboardID = snapshotValue?[kBusinessDashboard] as? String {
                standardUserDefaults.set(businessDashboardID, forKey: "business")
            }
            if let homeDashboardID = snapshotValue?[kHomeDashboard] as? String {
                standardUserDefaults.set(homeDashboardID, forKey: "home")
            }
        }) { (error) in
            self.errorDelegate?.loadError(error)
        }
    }
    
    // MARK: - Get Businesses and Their Images
    func getBusinessAndImages() {
        self.businessRef.observe(.value, with: { (snapshot) in
            self.businessImages = [:]
            
            for business in snapshot.children.allObjects {
                let businessProfile = business as! DataSnapshot
                let businessData = businessProfile.value as? NSDictionary
                
                // business object
                let name = businessData?["name"] as! String
                let address = businessData?["address"] as! String
                let phoneNumber = businessData?["phoneNumber"] as! String
                let website = businessData?["website"] as! String
                let postalCode = businessData?["postalCode"] as! String
                let image = businessData?["image"] as? String
                
                let aBusiness = Business()
                aBusiness.name = name
                aBusiness.address = address
                aBusiness.phoneNumber = phoneNumber
                aBusiness.website = website
                aBusiness.postalCode = postalCode
                aBusiness.image = image
                
                self.businessImages.updateValue(image ?? "", forKey: name)
            }
            self.hideActivityIndicator()
        }) { (error) in
            self.errorDelegate?.loadError(error)
        }
    }
    
    // MARK: - Get Public Addresses
    func getPublicAddresses() {
        self.addressRef.observe(.value, with: { (snapshot) in
            self.allAddresses = []
            self.locationItems = [:]
            
            // get all addresses
            for address in snapshot.children.allObjects {
                let addressProfile = address as! DataSnapshot
                let addressData = addressProfile.value as? NSDictionary
                
                // location
                let postalCode = addressData?["postalCode"] as! String
                let addressName = addressProfile.key // address name
                
                // image if exists
                let image = addressData?["image"] as? String
                
                // user name and image for location
                let address = Address()
                address.postalCode = postalCode
                address.address = addressName // address name
                address.image = image
                address.categoryItems = [:]
                
                self.allAddresses.append(address)
                print(addressName)
                
                // get address categories and items
                for categoryProfile in snapshot.childSnapshot(forPath: address.address!).childSnapshot(forPath: "categories").children.allObjects {
                    var itemsArray: [PaintCan] = []
                    // category
                    let categoryName = categoryProfile as! DataSnapshot
                    let category = categoryName.key
                    
                    // if category has children nodes
                    if categoryName.hasChildren() {
                        
                        // all paint can objects
                        for item in categoryName.children.allObjects {
                            
                            // paint can item
                            let productData = item as! DataSnapshot
                            let itemProfile = productData.value as? NSDictionary
                            
                            // check whether the product has been flagged more or equal to 5 times
                            if productData.hasChild("flagged") {
                                if productData.childSnapshot(forPath: "flagged").childrenCount >= 5 {
                                    continue
                                }
                            }
                            
                            // get scanned product
                            let type = itemProfile?["type"] as! String
                            let name = itemProfile?["name"] as! String
                            let manufacturer = itemProfile?["manufacturer"] as! String
                            let upcCode = itemProfile?["barcode"] as! String
                            let image = itemProfile?["image"] as! String
                            let timestamp = itemProfile?["timestamp"] as! String
                            
                            let uniqueID = productData.key
                            
                            // paint can
                            let paintCan = PaintCan()
                            paintCan.uniqueID = uniqueID
                            paintCan.type = type
                            paintCan.name = name
                            paintCan.manufacturer = manufacturer
                            paintCan.upcCode = upcCode
                            paintCan.image = image
                            paintCan.timestamp = timestamp
                            
                            // check for business added item
                            if productData.hasChild("businessAdded") {
                                // set business property of product
                                let businessName = itemProfile?["businessAdded"] as! String
                                
                                paintCan.businessAdded = businessName
                            }
                            
                            // paint can category
                            if productData.hasChild("category") {
                                // set business property of product
                                let category = itemProfile?["category"] as! String
                                
                                paintCan.category = category
                            }
                            
                            // paint can code
                            if productData.hasChild("code") {
                                // set business property of product
                                let code = itemProfile?["code"] as! String
                                
                                paintCan.code = code
                            }
                            
                            // check for colour
                            if productData.hasChild("colour") {
                                let colourProfile = itemProfile?["colour"] as? NSDictionary
                                let colourName = colourProfile?["name"] as! String
                                let hexcode = colourProfile?["hexcode"] as! String
                                let colourManufacturerID = colourProfile?["manufacturerID"] as! String
                                let colourManufacturer = colourProfile?["manufacturer"] as! String
                                let productCode = colourProfile?["productCode"] as! String
                                
                                let colour = Colour(manufacturerID: colourManufacturerID, productCode: productCode, name: colourName, hexCode: hexcode, manufacturer: colourManufacturer)
                                
                                paintCan.colour = colour
                            }
                            // add to temp array
                            itemsArray.append(paintCan)
                        }
                        address.categoryItems?.updateValue(itemsArray, forKey: category)
                    }
                    else {
                        address.categoryItems?.updateValue([], forKey: category)
                    }
                }
            }
            
            // update searchable addresses
            self.loadAddressDelegate?.addressLoadingComplete(allAddresses: self.allAddresses)
            
        }) { (error) in
            self.errorDelegate?.loadError(error)
        }
    }
    
}
