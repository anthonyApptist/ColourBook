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
                
                self.businessImages.updateValue(image ?? "", forKey: name)
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
                
                // get address items
                for categoryProfile in snapshot.childSnapshot(forPath: location.locationName).childSnapshot(forPath: "categories").children.allObjects {
                    
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
                self.locationItems.updateValue(self.categoryItems, forKey: location.locationName)
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
