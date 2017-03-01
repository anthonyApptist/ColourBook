//
//  ItemListAdd - Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 8/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension ItemListAddVC {
    
    func getLocationLists(screenState: ScreenState, user: User) {
        
        self.ref?.observe(.value, with: { (snapshot) in
            
            // reset model
            self.locations = []
            self.businessImages = [:]
            
            // business images
            for business in snapshot.childSnapshot(forPath: "businesses").children.allObjects {
                let businessProfile = business as! FIRDataSnapshot
                let businessData = businessProfile.value as? NSDictionary
                
                // location
                let name = businessData?["name"] as! String
                let locationName = businessProfile.key
                
                let image = businessData?["image"] as? String
                let postalCode = businessData?["postalCode"] as? String
                let phoneNumber = businessData?["phoneNumber"] as? String
                let website = businessData?["website"] as? String
                
                let newBusiness = Business(name: name, location: locationName, phoneNumber: phoneNumber, website: website, postalCode: postalCode, image: image)
                
                if newBusiness.image == "" || newBusiness.image == nil {
                    self.businessImages.updateValue("", forKey: newBusiness.location)
                }
                else {
                    self.businessImages.updateValue(newBusiness.image!, forKey: newBusiness.location)
                }
            }
            
            if screenState == .homes {
                
                if snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: user.uid).childSnapshot(forPath: AddressDashboard).exists() {
                    // get user address data
                    for address in snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: user.uid).childSnapshot(forPath: AddressDashboard).children.allObjects {
                        
                        let addressProfile = address as! FIRDataSnapshot
                        let addressData = addressProfile.value as? NSDictionary
                        
                        // location
                        let postalCode = addressData?["postalCode"] as! String
                        let locationName = addressProfile.key
                        
                        let image = addressData?["image"] as? String
                        let name = addressData?["name"] as? String
                        
                        // user name and image for location
                        let location = Location(locationName: locationName, postalCode: postalCode)
                        location.image = image
                        location.name = name
                        
                        // get user address items
                        for categoryProfile in snapshot.childSnapshot(forPath: "addresses").childSnapshot(forPath: location.locationName).childSnapshot(forPath: "categories").children.allObjects {
                            
                            let categoryName = categoryProfile as! FIRDataSnapshot
                            let category = categoryName.key
                            
                            if categoryName.hasChildren() {
                                var itemsArray: [ScannedProduct] = []
                                
                                for item in categoryName.childSnapshot(forPath: Barcodes).children.allObjects {
                                    
                                    // default value
                                    var addedBy = ""
                                    
                                    let product = item as! FIRDataSnapshot
                                    let itemProfile = product.value as? NSDictionary
                                    
                                    // get scanned product
                                    let productType = itemProfile?["productName"] as! String
                                    let manufacturer = itemProfile?["manufacturer"] as! String
                                    let upcCode = product.key
                                    let image = itemProfile?["image"] as! String
                                    let timestamp = itemProfile?["timestamp"] as! String
                                    
                                    // check whether the product has been flagged more or equal to 5 times
                                    if product.hasChild("flagged") {
                                        if product.childSnapshot(forPath: "flagged").childrenCount >= 5 {
                                            continue
                                        }
                                    }
                                    // check for business added item
                                    if product.hasChild("addedBy") {
                                        
                                        // get image string of business
                                        let businessLocation = itemProfile?["addedBy"] as! String
                                        addedBy = businessLocation
                                    }
                                    
                                    // check for colour
                                    if product.hasChild("colour") {
                                        let colourProfile = itemProfile?["colour"] as? NSDictionary
                                        let colourName = colourProfile?["colourName"] as! String
                                        let hexcode = colourProfile?["hexcode"] as! String
                                        let colourManufacturerID = colourProfile?["manufacturerID"] as! String
                                        let colourManufacturer = colourProfile?["manufacturer"] as! String
                                        let productCode = colourProfile?["productCode"] as! String
                                        
                                        let colour = Colour(manufacturerID: colourManufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: colourManufacturer)
                                        
                                        let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colour, timestamp: timestamp)
                                        product.addedBy = addedBy
                                        itemsArray.append(product)
                                    }
                                    else {
                                        let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                                        product.addedBy = addedBy
                                        itemsArray.append(product)
                                    }
                                }
                                self.userLocationItems.updateValue(itemsArray, forKey: category)
                            }
                            else {
                                self.userLocationItems.updateValue([], forKey: category)
                            }
                        }
                        // locations in database
                        self.locations.append(location)
                        
                        // location with items
                        self.userLocations.updateValue(self.userLocationItems, forKey: location.locationName)
                    }
                    
                    var locationsDisplayed = [String]()
                    
                    for location in self.locations {
                        let locationName = location.locationName
                        locationsDisplayed.append(locationName)
                    }
                    
                    // get public address data
                    for address in snapshot.childSnapshot(forPath: "addresses").children.allObjects {
                        
                        let addressProfile = address as! FIRDataSnapshot
                        let addressData = addressProfile.value as? NSDictionary
                        
                        // location
                        let locationName = addressProfile.key
                        
                        self.databaseLocationItems = [:]
                        
                        if locationsDisplayed.contains(locationName) {
                            
                            // get public items
                            
                            if snapshot.childSnapshot(forPath: "addresses").childSnapshot(forPath: locationName).hasChild("businessAdded") {
                                
                                for categoryProfile in snapshot.childSnapshot(forPath: "addresses").childSnapshot(forPath: locationName).childSnapshot(forPath: "businessAdded").childSnapshot(forPath: "categories").children.allObjects {
                                    
                                    let categoryName = categoryProfile as! FIRDataSnapshot
                                    let category = categoryName.key
                                    
                                    if categoryName.hasChildren() {
                                        var itemsArray: [ScannedProduct] = []
                                        
                                        for item in categoryName.childSnapshot(forPath: Barcodes).children.allObjects {
                                            
                                            // default value
                                            var addedBy = ""
                                            
                                            let product = item as! FIRDataSnapshot
                                            let itemProfile = product.value as? NSDictionary
                                            
                                            // get scanned product
                                            
                                            let productType = itemProfile?["productName"] as! String
                                            let manufacturer = itemProfile?["manufacturer"] as! String
                                            let upcCode = product.key
                                            let image = itemProfile?["image"] as! String
                                            let timestamp = itemProfile?["timestamp"] as! String
                                            
                                            // check whether the product has been flagged more or equal to 5 times
                                            if product.hasChild("flagged") {
                                                if product.childSnapshot(forPath: "flagged").childrenCount >= 5 {
                                                    continue
                                                }
                                            }
                                            
                                            // check for business added item
                                            if product.hasChild("addedBy") {
                                                // get image string of business
                                                let businessLocation = itemProfile?["addedBy"] as! String
                                                addedBy = businessLocation
                                            }
                                            // check for colour
                                            if product.hasChild("colour") {
                                                let colourProfile = itemProfile?["colour"] as? NSDictionary
                                                let colourName = colourProfile?["colourName"] as! String
                                                let hexcode = colourProfile?["hexcode"] as! String
                                                let colourManufacturerID = colourProfile?["manufacturerID"] as! String
                                                let colourManufacturer = colourProfile?["manufacturer"] as! String
                                                let productCode = colourProfile?["productCode"] as! String
                                                
                                                let colour = Colour(manufacturerID: colourManufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: colourManufacturer)
                                                
                                                let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colour, timestamp: timestamp)
                                                product.addedBy = addedBy
                                                itemsArray.append(product)
                                            }
                                                // no colour
                                            else {
                                                let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                                                product.addedBy = addedBy
                                                itemsArray.append(product)
                                            }
                                        }
                                        self.databaseLocationItems.updateValue(itemsArray, forKey: category)
                                    }
                                        // category has no children
                                    else {
                                        self.databaseLocationItems.updateValue([], forKey: category)
                                    }
                                }
                                // locations in database
                                self.allDatabaseLocation.append(locationName)
                                
                                // location with items
                                self.databaseLocations.updateValue(self.databaseLocationItems, forKey: locationName)
                            }
                            else {
                                self.databaseLocations.updateValue([:], forKey: locationName)
                            }
                        }
                        else {
                            continue
                        }
                    }
                    
                    // Update UI
                    self.tableView?.reloadData()
                    self.hideActivityIndicator()
                }
                    
                    // no addresses added
                else {
                    self.hideActivityIndicator()
                }
            }
                
                // business screen state
            else {
                if snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: user.uid).childSnapshot(forPath: BusinessDashboard).childSnapshot(forPath: "addresses").exists() {
                    
                    // user business address list
                    for child in snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: user.uid).childSnapshot(forPath: BusinessDashboard).childSnapshot(forPath: "addresses").children.allObjects {
                        
                        let addressProfile = child as! FIRDataSnapshot
                        let profile = addressProfile.value as? NSDictionary
                        
                        let postalCode = profile?["postalCode"] as! String
                        let locationName = addressProfile.key
                        
                        let image = profile?["image"] as? String
                        let name = profile?["name"] as? String
                        
                        // user name and image for location
                        
                        let location = Location(locationName: locationName, postalCode: postalCode)
                        location.image = image
                        location.name = name
                        
                        self.userLocationItems = [:]
                        
                        // get user address items
                        for categoryProfile in snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: user.uid).childSnapshot(forPath: BusinessDashboard).childSnapshot(forPath: "addresses").childSnapshot(forPath: location.locationName).childSnapshot(forPath: "categories").children.allObjects {
                            
                            let categoryName = categoryProfile as! FIRDataSnapshot
                            let category = categoryName.key
                            
                            if categoryName.hasChildren() {
                                var itemsArray: [ScannedProduct] = []
                                
                                for item in categoryName.childSnapshot(forPath: Barcodes).children.allObjects {
                                    
                                    // default value
                                    var addedBy = ""
                                    
                                    let product = item as! FIRDataSnapshot
                                    let itemProfile = product.value as? NSDictionary
                                    
                                    // get scanned product
                                    let productType = itemProfile?["productName"] as! String
                                    let manufacturer = itemProfile?["manufacturer"] as! String
                                    let upcCode = product.key
                                    let image = itemProfile?["image"] as! String
                                    let timestamp = itemProfile?["timestamp"] as! String
                                    
                                    // check whether the product has been flagged more or equal to 5 times
                                    if product.hasChild("flagged") {
                                        if product.childSnapshot(forPath: "flagged").childrenCount >= 5 {
                                            continue
                                        }
                                    }
                                    // check for business added item
                                    if product.hasChild("addedBy") {
                                        
                                        // get image string of business
                                        let businessLocation = itemProfile?["addedBy"] as! String
                                        addedBy = businessLocation
                                    }
                                    
                                    // check for colour
                                    if product.hasChild("colour") {
                                        let colourProfile = itemProfile?["colour"] as? NSDictionary
                                        let colourName = colourProfile?["colourName"] as! String
                                        let hexcode = colourProfile?["hexcode"] as! String
                                        let colourManufacturerID = colourProfile?["manufacturerID"] as! String
                                        let colourManufacturer = colourProfile?["manufacturer"] as! String
                                        let productCode = colourProfile?["productCode"] as! String
                                        
                                        let colour = Colour(manufacturerID: colourManufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: colourManufacturer)
                                        
                                        let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colour, timestamp: timestamp)
                                        product.addedBy = addedBy
                                        itemsArray.append(product)
                                    }
                                    else {
                                        let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                                        product.addedBy = addedBy
                                        itemsArray.append(product)
                                    }
                                }
                                self.userLocationItems.updateValue(itemsArray, forKey: category)
                            }
                            else {
                                self.userLocationItems.updateValue([], forKey: category)
                            }
                        }
                        self.locations.append(location)
                        
                        self.userLocations.updateValue(self.userLocationItems, forKey: locationName)
                    }
                    self.tableView?.reloadData()
                    self.hideActivityIndicator()
                }
                else {
                    self.hideActivityIndicator()
                }
            }
        })
    }
    
}
