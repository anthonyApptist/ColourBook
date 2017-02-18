//
//  CategoryListBusiness.swift
//  ColourBook
//
//  Created by Anthony Ma on 17/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension CategoriesListVC {
    func getCategoriesListsWithBusiness(screenState: ScreenState, user: User, location: Location?) {
        
        getCategoriesFrom(user: user, screenState: screenState, location: location)
        
        let categoriesRef = DataService.instance.generalRef
        
        categoriesRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects {
                let categoryName = child as! FIRDataSnapshot
                let category = categoryName.key
                
                self.categories.append(category)
                
                if categoryName.hasChildren() {
                    var itemsArray: [ScannedProduct] = []
                    var paintArray: [Paint] = []
                    var addedBy = ""
                    for items in categoryName.childSnapshot(forPath: Barcodes).children.allObjects {
                        let product = items as! FIRDataSnapshot
                        let itemProfile = product.value as? NSDictionary
                        
                        let productType = itemProfile?["productName"] as! String
                        let manufacturer = itemProfile?["manufacturer"] as! String
                        let productCategory = itemProfile?["category"] as! String
                        let code = itemProfile?["code"] as! String
                        let upcCode = product.key
                        let image = itemProfile?["image"] as! String
                        let timestamp = itemProfile?["timestamp"] as! String
                        
                        // check if added by for location
                        if product.hasChild("addedBy") {
                            addedBy = itemProfile?["addedBy"] as! String
                        }
                        
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
                            
                            let scannedProduct = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colour, timestamp: timestamp)
                            
                            // if scanned product added by business
                            scannedProduct.addedBy = addedBy
                            
                            let paint = Paint(manufacturer: manufacturer, productName: productType, category: productCategory, code: code, upcCode: upcCode, image: image)
                            paint.colour = colour
                            
                            paintArray.append(paint)
                            itemsArray.append(scannedProduct)
                        }
                        else {
                            let scannedProduct = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                            
                            let paint = Paint(manufacturer: manufacturer, productName: productType, category: category, code: code, upcCode: upcCode, image: image)
                            
                            // if scanned product added by business
                            scannedProduct.addedBy = addedBy
                            
                            paintArray.append(paint)
                            itemsArray.append(scannedProduct)
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

}
