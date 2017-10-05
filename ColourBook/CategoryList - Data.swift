//
//  CategoryList - Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 31/1/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension CategoriesListVC {
    func getCategoriesFor(screenState: ScreenState, location: Address?) {
        let ref = getCategoriesRef(screenState: screenState, location: location)
        
        ref.observe(.value, with: { (snapshot) in
            self.showActivityIndicator()
            
            self.categories = []
            
            // check personal name
            if snapshot.hasChild("name") {
                
            }
            
            // check personal image
            if snapshot.hasChild("image") {
                
            }
            
            // personal dashboard
            for child in snapshot.children.allObjects {
                let categoryName = child as! DataSnapshot
                let category = categoryName.key
                
                self.categories.append(category)
                
                // temp arrays
                var itemsArray: [PaintCan] = []
                
                if categoryName.hasChildren() {
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
                        let type = itemProfile?["type"] as! String
                        let productName = itemProfile?["name"] as! String
                        let manufacturer = itemProfile?["manufacturer"] as! String
                        let upcCode = itemProfile?["barcode"] as! String
                        let image = itemProfile?["image"] as! String
                        let timestamp = itemProfile?["timestamp"] as! String
                        
                        let uniqueID = productData.key
                        
                        let aPaintCan = PaintCan()
                        aPaintCan.type = type
                        aPaintCan.name = productName
                        aPaintCan.manufacturer = manufacturer
                        aPaintCan.upcCode = upcCode
                        aPaintCan.image = image
                        aPaintCan.timestamp = timestamp
                        aPaintCan.uniqueID = uniqueID
                        
                        // check for business added item
                        
                        // set business property of product
                        if let businessName = itemProfile?["businessAdded"] as? String {
                            aPaintCan.businessAdded = businessName
                        }
                            // set business property of product
                        if let category = itemProfile?["category"] as? String {
                            aPaintCan.category = category
                        }
                        // set business property of product
                        if let code = itemProfile?["code"] as? String {
                            aPaintCan.code = code
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
                            
                            aPaintCan.colour = colour
                        }
                        // add to temp array
                        itemsArray.append(aPaintCan)
                    }
                    self.categoriesItems.updateValue(itemsArray, forKey: category)
                }
                else {
                    self.categoriesItems.updateValue([], forKey: category)
                }
            }
            
            // update UI
            self.hideActivityIndicator()
            self.collectionView.reloadData()
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
            self.displayErrorMessage(error: error)
        })
    }
    
    func getCategoriesRef(screenState: ScreenState, location: Address?) -> DatabaseReference {
        if screenState == .personal {
            let personalID = standardUserDefaults.value(forKey: "personal") as! String
            return DataService.instance.personalDashboardRef.child(personalID)
        }
        if screenState == .business {
            let businessID = standardUserDefaults.value(forKey: "business") as! String
            return DataService.instance.businessDashboardRef.child(businessID).child((location?.address)!).child("categories")
        }
        if screenState == .homes {
            let homeID = standardUserDefaults.value(forKey: "home") as! String
            return DataService.instance.homeDashboardRef.child(homeID).child((location?.address)!).child("categories")
        }
        if screenState == .searching {
            return DataService.instance.addressRef.child((location?.address)!).child("categories")
        }
        return DataService.instance.publicRef
    }
}

