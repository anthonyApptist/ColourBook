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
        
        categoriesRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects {
                let categoryName = child as! FIRDataSnapshot
                let category = categoryName.key
                
                self.categories.append(category)
                
                if categoryName.hasChildren() {
                    var itemsArray: [ScannedProduct] = []
                    for items in categoryName.childSnapshot(forPath: Barcodes).children.allObjects {
                        let product = items as! FIRDataSnapshot
                        let itemProfile = product.value as? NSDictionary
                        
                        let productType = itemProfile?["productName"] as! String
                        let manufacturer = itemProfile?["manufacturer"] as! String
                        let upcCode = product.key
                        let image = itemProfile?["image"] as! String
                        let timestamp = itemProfile?["timestamp"] as! String
                        
                        // check for colour
                        if product.hasChild("colour") {
                            let colourProfile = itemProfile?["colour"] as? NSDictionary
                            let colourName = colourProfile?["colourName"] as! String
                            let hexcode = colourProfile?["hexcode"] as! String
                            let manufacturerID = colourProfile?["manufacturerID"] as! String
                            let manufacturer = colourProfile?["manufacturer"] as! String
                            let productCode = colourProfile?["productCode"] as! String
                            
                            let colour = Colour(manufacturerID: manufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: manufacturer)
                            
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colour, timestamp: timestamp)
                            
                            itemsArray.append(product)
                        }
                        else {
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                            
                            itemsArray.append(product)
                        }
                        
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
    
    func getCategoriesFrom(user: User, screenState: ScreenState, location: Location?) {
        if screenState == .personal {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(PersonalDashboard)
        }
        if screenState == .business {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard).child("address").child((location?.locationName)!).child("categories")
        }
        else if screenState == .homes {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(AddressDashboard).child((location?.locationName)!).child("categories")
        }
        
    }
    
}

