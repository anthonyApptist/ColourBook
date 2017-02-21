//
//  GoogleMap - Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 17/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension GoogleMap {
    
    func getAddressLists(location: Location) {
        let addressRef = DataService.instance.addressRef
        
        addressRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children {
                let profile = child as! FIRDataSnapshot
                let addressProfile = profile.value as? NSDictionary
                
                let postalCode = addressProfile?["postalCode"] as! String
                let locationName = profile.key
                
                let image = addressProfile?["image"] as? String
                let name = addressProfile?["name"] as? String
                
                let location = Location(locationName: locationName, postalCode: postalCode)
                location.image = image
                location.name = name
                
                let categories = addressProfile?["categories"] as? NSDictionary
                
                // data model
                var categoriesItems: [String:[Paint]] = [:]
                var categoriesItemsArray: [[String:[Paint]]] = []
                var paintArray: [Paint] = []
                
                
                for category in (categories?.allKeys)! {
                    let categoryString = category as! String
                    if snapshot.childSnapshot(forPath: "categories").childSnapshot(forPath: categoryString).hasChildren() {
                        
                        for items in snapshot.childSnapshot(forPath: "categories").childSnapshot(forPath: categoryString).childSnapshot(forPath: Barcodes).children.allObjects {
                            let product = items as! FIRDataSnapshot
                            let itemProfile = product.value as? NSDictionary
                            
                            let productType = itemProfile?["productName"] as! String
                            let manufacturer = itemProfile?["manufacturer"] as! String
                            let productCategory = itemProfile?["category"] as! String
                            let code = itemProfile?["code"] as! String
                            let upcCode = product.key
                            let image = itemProfile?["image"] as! String
                            let timestamp = itemProfile?["timestamp"] as! String
                            
                            // check whether the product has been flagged more or equal to 5 times
                            if product.hasChild("flagged") {
                                if product.childSnapshot(forPath: "flagged").childrenCount >= 5 {
                                    continue
                                }
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
                                
                                let paint = Paint(manufacturer: manufacturer, productName: productType, category: productCategory, code: code, upcCode: upcCode, image: image)
                                paint.colour = colour
                                
                                paintArray.append(paint)
                            }
                            else {
                                let paint = Paint(manufacturer: manufacturer, productName: productType, category: productCategory, code: code, upcCode: upcCode, image: image)
                                
                                paintArray.append(paint)
                            }
                            categoriesItems.updateValue(paintArray, forKey: categoryString)
                            categoriesItemsArray.append(categoriesItems)
                        }
                        
                        self.databaseAddresses.updateValue(categoriesItemsArray, forKey: location.locationName)
                        
                    }
                    // no items
                    else {
                        categoriesItems.updateValue(paintArray, forKey: categoryString)
                        categoriesItemsArray.append(categoriesItems)
                    }
                    
                    self.databaseAddresses.updateValue(categoriesItemsArray, forKey: location.locationName)
                }
                
            }
        })
    }
    
}
