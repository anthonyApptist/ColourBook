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
            
            if screenState == .homes {
                
                if snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: user.uid).childSnapshot(forPath: AddressDashboard).exists() {
                    
                    self.locationItems = [:]
                    
                    // get user address data
                    for address in snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: user.uid).childSnapshot(forPath: AddressDashboard).children.allObjects {
                        
                        // user address list
                        let addressProfile = address as! FIRDataSnapshot
                        let addressData = addressProfile.value as? NSDictionary
                        
                        // location mandatory variables
                        let postalCode = addressData?["postalCode"] as! String
                        let locationName = addressProfile.key
                        
                        // image and name
                        let image = addressData?["image"] as? String
                        let name = addressData?["name"] as? String
                        
                        // user name and image for location
                        let location = Location(locationName: locationName, postalCode: postalCode)
                        location.image = image
                        location.name = name
                        
                        // store user location lists (table view model)
                        self.locations.append(location)
                        
                    }
                    
                    // for each location in user list (look at public list)
                    for location in self.locations {
                        
                        // get address items
                        for categoryProfile in snapshot.childSnapshot(forPath: "addresses").childSnapshot(forPath: location.locationName).childSnapshot(forPath: "categories").children.allObjects {
                            
                            let categoryName = categoryProfile as! FIRDataSnapshot
                            let category = categoryName.key
                            
                            if categoryName.hasChildren() {
                                var itemsArray: [ScannedProduct] = []
                                
                                for item in categoryName.childSnapshot(forPath: Barcodes).children.allObjects {
                                    
                                    // potential values
                                    var productBusiness: String?
                                    var itemColour: Colour?
                                    
                                    let productData = item as! FIRDataSnapshot
                                    let itemProfile = productData.value as? NSDictionary
                                    
                                    // get scanned product
                                    let productType = itemProfile?["productName"] as! String
                                    let manufacturer = itemProfile?["manufacturer"] as! String
                                    let upcCode = itemProfile?["barcode"] as! String
                                    let image = itemProfile?["image"] as! String
                                    let timestamp = itemProfile?["timestamp"] as! String
                                    
                                    let uniqueID = productData.key
                                    
                                    let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                                    product.uniqueID = uniqueID
                                    
                                    // check whether the product has been flagged more or equal to 5 times
                                    if productData.hasChild("flagged") {
                                        if productData.childSnapshot(forPath: "flagged").childrenCount >= 5 {
                                            continue
                                        }
                                    }
                                    // check for business added item
                                    if productData.hasChild("businessAdded") {
                                        // set business property of product
                                        let businessName = itemProfile?["businessAdded"] as! String
                                        
                                        productBusiness = businessName
                                    }
                                    
                                    // check for colour
                                    if productData.hasChild("colour") {
                                        let colourProfile = itemProfile?["colour"] as? NSDictionary
                                        let colourName = colourProfile?["colourName"] as! String
                                        let hexcode = colourProfile?["hexcode"] as! String
                                        let colourManufacturerID = colourProfile?["manufacturerID"] as! String
                                        let colourManufacturer = colourProfile?["manufacturer"] as! String
                                        let productCode = colourProfile?["productCode"] as! String
                                        
                                        itemColour = Colour(manufacturerID: colourManufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: colourManufacturer)
                                    }
                                    
                                    // set scanned product colour
                                    if let colour = itemColour {
                                        product.colour = colour
                                    }
                                    // set scanned product businessAdded
                                    if let business = productBusiness {
                                        product.businessAdded = business
                                    }
                                    // add to temp array
                                    itemsArray.append(product)
                                }
                                self.categoryItems.updateValue(itemsArray, forKey: category)
                            }
                            else {
                                self.categoryItems.updateValue([], forKey: category)
                            }
                        }
                        // add to location dictionary 
                        self.userLocations.updateValue(self.categoryItems, forKey: location.locationName)
                    }
                    // update UI
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
                    
                    self.locationItems = [:]
                    
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
                        
                        self.locations.append(location)
                        
                        // get address items
                        for categoryProfile in snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: user.uid).childSnapshot(forPath: BusinessDashboard).childSnapshot(forPath: "addresses").childSnapshot(forPath: location.locationName).childSnapshot(forPath: "categories").children.allObjects {
                            
                            let categoryName = categoryProfile as! FIRDataSnapshot
                            let category = categoryName.key
                            
                            if categoryName.hasChildren() {
                                var itemsArray: [ScannedProduct] = []
                                
                                for item in categoryName.childSnapshot(forPath: Barcodes).children.allObjects {
                                    
                                    // potential values
                                    var productBusiness: String?
                                    var itemColour: Colour?
                                    
                                    let productData = item as! FIRDataSnapshot
                                    let itemProfile = productData.value as? NSDictionary
                                    
                                    // get scanned product
                                    let productType = itemProfile?["productName"] as! String
                                    let manufacturer = itemProfile?["manufacturer"] as! String
                                    let upcCode = itemProfile?["barcode"] as! String
                                    let image = itemProfile?["image"] as! String
                                    let timestamp = itemProfile?["timestamp"] as! String
                                    
                                    let uniqueID = productData.key
                                    
                                    let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                                    product.uniqueID = uniqueID
                                    
                                    // check whether the product has been flagged more or equal to 5 times
                                    if productData.hasChild("flagged") {
                                        if productData.childSnapshot(forPath: "flagged").childrenCount >= 5 {
                                            continue
                                        }
                                    }
                                    // check for business added item
                                    if productData.hasChild("businessAdded") {
                                        // set business property of product
                                        let businessName = itemProfile?["businessAdded"] as! String
                                        
                                        productBusiness = businessName
                                    }
                                    
                                    // check for colour
                                    if productData.hasChild("colour") {
                                        let colourProfile = itemProfile?["colour"] as? NSDictionary
                                        let colourName = colourProfile?["colourName"] as! String
                                        let hexcode = colourProfile?["hexcode"] as! String
                                        let colourManufacturerID = colourProfile?["manufacturerID"] as! String
                                        let colourManufacturer = colourProfile?["manufacturer"] as! String
                                        let productCode = colourProfile?["productCode"] as! String
                                        
                                        itemColour = Colour(manufacturerID: colourManufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: colourManufacturer)
                                    }
                                    
                                    // set scanned product colour
                                    if let colour = itemColour {
                                        product.colour = colour
                                    }
                                    // set scanned product businessAdded
                                    if let business = productBusiness {
                                        product.businessAdded = business
                                    }
                                    // add to temp array
                                    itemsArray.append(product)
                                }
                                self.categoryItems.updateValue(itemsArray, forKey: category)
                            }
                            else {
                                self.categoryItems.updateValue([], forKey: category)
                            }
                        }
                        
                        self.userLocations.updateValue(self.categoryItems, forKey: locationName)
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
