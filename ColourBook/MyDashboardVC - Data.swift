//
//  MyDashboardVC - Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 7/3/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

extension MyDashboardVC {
    
    // Businesses
    
    func getBusinessAndImages() {
        
        self.scrollView.isScrollEnabled = false
        self.showActivityIndicator()
        
        self.businessRef.observe(.value, with: { (snapshot) in
            
            for business in snapshot.children.allObjects {
                let businessProfile = business as! FIRDataSnapshot
                let businessData = businessProfile.value as? NSDictionary
                
                // business
                let name = businessData?["name"] as! String
                let locationName = businessProfile.key
                
                let phoneNumber = businessData?["phoneNumber"] as? String
                let website = businessData?["website"] as? String
                let postalCode = businessData?["postalCode"] as? String
                let image = businessData?["image"] as? String
                
                let aBusiness = Business(name: name, location: locationName, phoneNumber: phoneNumber, website: website, postalCode: postalCode, image: image)
                
                self.businessImages.updateValue(image ?? "", forKey: locationName)
                self.cbBusinesses.append(aBusiness)
            }
            
            self.viewBtn.isUserInteractionEnabled = true
            
            self.hideActivityIndicator()
            
        }) { (error) in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getPublicAddresses() {
        
        self.showActivityIndicator()
        
        // reset model
        self.allAddress = []
        self.locationItems = [:]
        
        self.addressRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for address in snapshot.children.allObjects {
                
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
                
                self.allAddress.append(location)
                print(locationName)
                
                self.categoryItems = [:]
                
                for categoryProfile in snapshot.childSnapshot(forPath: locationName).childSnapshot(forPath: "categories").children.allObjects {
                    
                    let categoryName = categoryProfile as! FIRDataSnapshot
                    let category = categoryName.key
                    
                    var itemsArray: [ScannedProduct] = []
                    
                    if categoryName.hasChildren() {
                        
                        itemsArray.removeAll()
                        
                        for item in categoryName.childSnapshot(forPath: "barcodes").children.allObjects {
                            
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
                        self.categoryItems.updateValue(itemsArray, forKey: category)
                    }
                    else {
                        self.categoryItems.updateValue([], forKey: category)
                    }
                    // location with items
                    self.locationItems.updateValue(self.categoryItems, forKey: location.locationName)
                }
                
                // get public items
                if snapshot.childSnapshot(forPath: locationName).hasChild("businessAdded") {
                    
                    self.categoryItems = [:]
                    
                    for categoryProfile in snapshot.childSnapshot(forPath: locationName).childSnapshot(forPath: "businessAdded").childSnapshot(forPath: "categories").children.allObjects {
                        
                        let categoryName = categoryProfile as! FIRDataSnapshot
                        let category = categoryName.key
                        
                        var itemsArray: [ScannedProduct] = []
                        
                        if categoryName.hasChildren() {
                            
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
                            // append items from user items
                            
                            let array = self.locationItems[location.locationName]?[category]
                            
                            if array != nil {
                                let allItems = itemsArray + array!
                                self.categoryItems.updateValue(allItems, forKey: category)
                            }
                            else {
                                self.categoryItems.updateValue(itemsArray, forKey: category)
                            }
                        }
                            // category has no children
                        else {
                            
                            // append items from user items
                            
                            let array = self.locationItems[location.locationName]?[category]
                            
                            if array != nil {
                                let allItems = itemsArray + array!
                                self.categoryItems.updateValue(allItems, forKey: category)
                            }
                            else {
                                self.categoryItems.updateValue(itemsArray, forKey: category)
                            }
                        }
                    }
                    self.locationItems.updateValue(self.categoryItems, forKey: locationName)
                }
                else {
                    continue
                }
            }
            
            self.hideActivityIndicator()
            
            // update searchable addresses
            self.resultsUpdater?.allAddresses = self.allAddress

        }) { (error) in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

}
