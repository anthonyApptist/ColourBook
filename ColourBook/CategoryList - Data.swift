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
    
    func getCategoriesFor(screenState: ScreenState, user: User, location: Location?) {
        
        getCategoriesRef(user: user, screenState: screenState, location: location)
        
        let categoriesRef = DataService.instance.generalRef
        
        self.categories = []
        
        self.collectionView.reloadData()
        
        categoriesRef?.observe(.value, with: { (snapshot) in
            
            // check personal name
            if snapshot.hasChild("name") {
                
            }
            
            // check personal image
            if snapshot.hasChild("image") {
                
            }
            
            // personal dashboard
            for child in snapshot.childSnapshot(forPath: PersonalDashboard).children.allObjects {
                let categoryName = child as! FIRDataSnapshot
                let category = categoryName.key
                
                self.categories.append(category)
                
                // temp arrays
                var itemsArray: [ScannedProduct] = []
                
                if categoryName.hasChildren() {
                    for item in categoryName.childSnapshot(forPath: Barcodes).children.allObjects {
                        
                        let productData = item as! FIRDataSnapshot
                        let itemProfile = productData.value as? NSDictionary
                        
                        // check whether the product has been flagged more or equal to 5 times
                        if productData.hasChild("flagged") {
                            if productData.childSnapshot(forPath: "flagged").childrenCount >= 5 {
                                continue
                            }
                        }
                        
                        // get scanned product
                        let productType = itemProfile?["product"] as! String
                        let productName = itemProfile?["productName"] as! String
                        let manufacturer = itemProfile?["manufacturer"] as! String
                        let upcCode = itemProfile?["barcode"] as! String
                        let image = itemProfile?["image"] as! String
                        let timestamp = itemProfile?["timestamp"] as! String
                        
                        let uniqueID = productData.key
                        
                        let product = ScannedProduct(productType: productType, productName: productName, manufacturer: manufacturer, upcCode: upcCode, image: image)
                        
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
                            let colourName = colourProfile?["colourName"] as! String
                            let hexcode = colourProfile?["hexcode"] as! String
                            let colourManufacturerID = colourProfile?["manufacturerID"] as! String
                            let colourManufacturer = colourProfile?["manufacturer"] as! String
                            let productCode = colourProfile?["productCode"] as! String
                            
                            let colour = Colour(manufacturerID: colourManufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: colourManufacturer)
                            
                            product.colour = colour
                        }
                        // add to temp array
                        itemsArray.append(product)
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
    
    func getCategoriesRef(user: User, screenState: ScreenState, location: Location?) {
        if screenState == .personal {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid)
        }
        if screenState == .business {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard).child("addresses").child((location?.locationName)!).child("categories")
        }
        if screenState == .homes {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(AddressDashboard).child((location?.locationName)!).child("categories")
        }
        if screenState == .searching {
            DataService.instance.generalRef = DataService.instance.addressRef.child((location?.locationName)!).child("categories")
        }
    }
    
}

