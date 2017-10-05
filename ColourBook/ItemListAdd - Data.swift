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
    
    // MARK: - Get Location Lists
    func getLocationLists(screenState: ScreenState) {
        self.ref?.observe(.value, with: { (snapshot) in
            
            // reset model
            self.locations = []
            
            if screenState == .homes {
                // get user address data
                for address in snapshot.children.allObjects {
                    // user address list
                    let addressProfile = address as! DataSnapshot
                    let addressData = addressProfile.value as? NSDictionary
                    
                    // location mandatory variables
                    let postalCode = addressData?["postalCode"] as! String
                    let locationName = addressProfile.key
                    
                    // image and name
                    let image = addressData?["image"] as? String
                    let name = addressData?["name"] as? String
                    
                    // user name and image for location
                    let address = Address()
                    address.postalCode = postalCode
                    address.address = locationName
                    address.image = image
                    address.name = name
                    
                    // store user location lists (table view model)
                    self.locations.append(address)
                }
                
                // for each location in user list (look at public list)
                for location in self.locations {
                    location.categoryItems = [:]
                    // get address items
                    self.ref?.parent?.parent?.child("addresses").observe(.value, with: { (snapshot) in
                        for categoryProfile in snapshot.childSnapshot(forPath: location.address!).childSnapshot(forPath: "categories").children.allObjects {
                            let categoryName = categoryProfile as! DataSnapshot
                            let category = categoryName.key
                            
                            if categoryName.hasChildren() {
                                var itemsArray: [PaintCan] = []
                                
                                for item in categoryName.children.allObjects {
                                    
                                    let productData = item as! DataSnapshot
                                    let itemProfile = productData.value as? NSDictionary
                                    
                                    // check whether the product has been flagged more or equal to 5 times
                                    if productData.hasChild("flagged") {
                                        if productData.childSnapshot(forPath: "flagged").childrenCount >= 5 {
                                            continue
                                        }
                                    }
                                    
                                    // get scanned product
                                    let productType = itemProfile?["type"] as! String
                                    let productName = itemProfile?["name"] as! String
                                    let manufacturer = itemProfile?["manufacturer"] as! String
                                    let upcCode = itemProfile?["barcode"] as! String
                                    let image = itemProfile?["image"] as! String
                                    let timestamp = itemProfile?["timestamp"] as! String
                                    
                                    // unique id of item
                                    let uniqueID = productData.key
                                    
                                    // paint can
                                    let product = PaintCan()
                                    
                                    product.type = productType
                                    product.name = productName
                                    product.manufacturer = manufacturer
                                    product.upcCode = upcCode
                                    product.image = image
                                    product.timestamp = timestamp
                                    product.uniqueID = uniqueID
                                    
                                    // check for business added item
                                    if productData.hasChild("businessAdded") {
                                        // set business property of product
                                        let businessName = itemProfile?["businessAdded"] as! String
                                        product.businessAdded = businessName
                                    }
                                    
                                    if productData.hasChild("category") {
                                        // set business property of product
                                        let category = itemProfile?["category"] as! String
                                        product.category = category
                                    }
                                    
                                    if productData.hasChild("code") {
                                        // set business property of product
                                        let code = itemProfile?["code"] as! String
                                        product.code = code
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
                                        
                                        product.colour = colour
                                    }
                                    // add to temp array
                                    itemsArray.append(product)
                                }
                                // update category itemlist
                                location.categoryItems?.updateValue(itemsArray, forKey: category)
                            }
                            else {
                                location.categoryItems?.updateValue([], forKey: category)
                            }
                            // update UI
                            self.tableView?.reloadData()
                            self.hideActivityIndicator()
                        }
                    }, withCancel: { (error) in
                        // error
                    })
                    
                }
            }
                // business screen state
            else {
                // user business list with addresses
                for address in snapshot.children.allObjects {
                    // address
                    let addressProfile = address as! DataSnapshot
                    let profile = addressProfile.value as? NSDictionary
                    
                    let postalCode = profile?["postalCode"] as! String
                    let locationName = addressProfile.key
                    
                    let image = profile?["image"] as? String
                    let name = profile?["name"] as? String
                    
                    // user name and image for location
                    let address = Address()
                    address.postalCode = postalCode
                    address.address = locationName
                    address.image = image
                    address.name = name
                    address.categoryItems = [:]
                    self.locations.append(address)
                    
                    // get address items
                    for categoryProfile in snapshot.childSnapshot(forPath: locationName).childSnapshot(forPath: "categories").children.allObjects {
                        
                        let categoryName = categoryProfile as! DataSnapshot
                        let category = categoryName.key
                        
                        // categories
                        if categoryName.hasChildren() {
                            var itemsArray: [PaintCan] = []
                            
                            // all items in category
                            for item in categoryName.children.allObjects {
                                
                                let productData = item as! DataSnapshot
                                let itemProfile = productData.value as? NSDictionary
                                
                                // check whether the product has been flagged more or equal to 5 times
                                if productData.hasChild("flagged") {
                                    if productData.childSnapshot(forPath: "flagged").childrenCount >= 5 {
                                        continue
                                    }
                                }
                                
                                // get scanned product
                                let productType = itemProfile?["type"] as! String
                                let productName = itemProfile?["name"] as! String
                                let manufacturer = itemProfile?["manufacturer"] as! String
                                let upcCode = itemProfile?["barcode"] as! String
                                let image = itemProfile?["image"] as! String
                                let timestamp = itemProfile?["timestamp"] as! String
                                
                                let uniqueID = productData.key
                                
                                // paint can
                                let product = PaintCan()
                                product.type = productType
                                product.name = productName
                                product.manufacturer = manufacturer
                                product.upcCode = upcCode
                                product.image = image
                                product.timestamp = timestamp
                                product.uniqueID = uniqueID
                                
                                // check for business added item
                                if productData.hasChild("businessAdded") {
                                    // set business property of product
                                    let businessName = itemProfile?["businessAdded"] as! String
                                    product.businessAdded = businessName
                                }
                                
                                if productData.hasChild("category") {
                                    // set business property of product
                                    let category = itemProfile?["category"] as! String
                                    product.category = category
                                }
                                
                                if productData.hasChild("code") {
                                    // set business property of product
                                    let code = itemProfile?["code"] as! String
                                    product.code = code
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
                                    
                                    product.colour = colour
                                }
                                
                                // add to temp array
                                itemsArray.append(product)
                            }
                            address.categoryItems?.updateValue(itemsArray, forKey: category)
                        }
                        else {
                            address.categoryItems?.updateValue([], forKey: category)
                        }
                    }
                    self.tableView?.reloadData()
                    self.hideActivityIndicator()
                }
            }
        })
    }
}
