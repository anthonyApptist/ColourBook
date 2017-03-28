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
        
        getCategoriesFrom(user: user, screenState: screenState, location: location)
        
        let categoriesRef = DataService.instance.generalRef
        
        self.categories = []
        self.paintProducts = [:]
        
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
                
                if categoryName.hasChildren() {
                    
                    // temp arrays
                    var itemsArray: [ScannedProduct] = []
                    var paintArray: [Paint] = []
                    
                    for items in categoryName.childSnapshot(forPath: Barcodes).children.allObjects {
                        let product = items as! FIRDataSnapshot
                        let itemProfile = product.value as? NSDictionary
                        
                        let productBarcode = itemProfile?["barcode"] as! String
                        let productType = itemProfile?["productName"] as! String
                        let manufacturer = itemProfile?["manufacturer"] as! String
                        let productCategory = itemProfile?["category"] as! String
                        let code = itemProfile?["code"] as! String
                        let image = itemProfile?["image"] as! String
                        let timestamp = itemProfile?["timestamp"] as! String
                        
                        // unique ID is child key
                        let productUniqueID = product.key
                        
                        /*
                        // check whether the product has been flagged more or equal to 5 times
                        if product.hasChild("flagged") {
                            if product.childSnapshot(forPath: "flagged").childrenCount >= 5 {
                                continue
                            }
                        }
                        */
                        
                        // check for colour
                        if product.hasChild("colour") {
                            let colourProfile = itemProfile?["colour"] as? NSDictionary
                            let colourName = colourProfile?["colourName"] as! String
                            let hexcode = colourProfile?["hexcode"] as! String
                            let colourManufacturerID = colourProfile?["manufacturerID"] as! String
                            let colourManufacturer = colourProfile?["manufacturer"] as! String
                            let productCode = colourProfile?["productCode"] as! String
                            
                            let colour = Colour(manufacturerID: colourManufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: colourManufacturer)
                            
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: productBarcode, image: image, colour: colour, timestamp: timestamp)
                            // set product unique ID
                            product.uniqueID = productUniqueID
                            
                            let paint = Paint(manufacturer: manufacturer, productName: productType, category: productCategory, code: code, upcCode: productBarcode, image: image)
                            paint.colour = colour
                            
                            paintArray.append(paint)
                            itemsArray.append(product)
                        }
                        else {
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: productBarcode, image: image, colour: nil, timestamp: timestamp)
                            product.uniqueID = productUniqueID
                            
                            let paint = Paint(manufacturer: manufacturer, productName: productType, category: category, code: code, upcCode: productBarcode, image: image)
                            
                            paintArray.append(paint)
                            itemsArray.append(product)
                        }
                    }
                    self.paintProducts.updateValue(paintArray, forKey: category)
                    self.categoriesItems.updateValue(itemsArray, forKey: category)
                }
                else {
                    self.categoriesItems.updateValue([], forKey: category)
                    self.paintProducts.updateValue([], forKey: category)
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
    
    func getCategoriesFrom(user: User, screenState: ScreenState, location: Location?) {
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

