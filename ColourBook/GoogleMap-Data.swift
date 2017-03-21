//
//  GoogleMap-Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 20/3/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension GoogleMap {
    func getPublicList() {
        
        let addressRef = DataService.instance.addressRef
        
        addressRef.observe(.value, with: { (snapshot) in
            // for each location in user list (look at public list)
            for location in snapshot.children.allObjects {
                
                let locationData = location as! FIRDataSnapshot
                let locationProfile = locationData.value as? NSDictionary
                
                let locationName = locationData.key
                let postalCode = locationProfile?["postalCode"] as! String
                
                self.locations.append(locationName)
                
                /*
                 // get address items
                 for categoryProfile in snapshot.childSnapshot(forPath: "addresses").childSnapshot(forPath: locationName).childSnapshot(forPath: "categories").children.allObjects {
                 
                 let categoryName = categoryProfile as! FIRDataSnapshot
                 let category = categoryName.key
                 
                 if categoryName.hasChildren() {
                 var itemsArray: [Paint] = []
                 
                 for item in categoryName.childSnapshot(forPath: Barcodes).children.allObjects {
                 
                 // potential values
                 var productBusiness: String?
                 var itemColour: Colour?
                 
                 let productData = item as! FIRDataSnapshot
                 let itemProfile = productData.value as? NSDictionary
                 
                 // get scanned product
                 let upcCode = itemProfile?["barcode"] as! String
                 let paintCategory = itemProfile?["category"] as! String
                 let paintCode = itemProfile?["code"] as! String
                 let image = itemProfile?["image"] as! String
                 let manufacturer = itemProfile?["manufacturer"] as! String
                 let productType = itemProfile?["product"] as! String
                 let productName = itemProfile?["productName"] as! String
                 let timestamp = itemProfile?["timestamp"] as! String
                 
                 let uniqueID = productData.key
                 
                 let paintCan = Paint(manufacturer: manufacturer, productName: productName, category: paintCategory, code: paintCode, upcCode: upcCode, image: image)
                 paintCan.uniqueID = uniqueID
                 
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
                 */
            }
            
            // update UI
            self.locationManager.startUpdatingLocation()
            self.searchButton?.isUserInteractionEnabled = true
            self.hideActivityIndicator()
        })
    }

}
