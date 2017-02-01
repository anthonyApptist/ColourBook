//
//  ItemListEdit-Category.swift
//  ColourBook
//
//  Created by Anthony Ma on 31/1/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

/*
func getItemsForCategoryFor(screenState: ScreenState, user: User, location: Location?, category: String) {
    
    getRefFor(screenState: screenState, user: user, location: location, category: category)
    let ref = DataService.instance.generalRef
    
    ref?.observeSingleEvent(of: .value, with: { (snapshot) in
        // get items
        for child in snapshot.children.allObjects {
            let paintProfile = child as! FIRDataSnapshot
            
            let profile = paintProfile.value as? NSDictionary
            let productType = profile?["productName"] as! String
            let manufacturer = profile?["manufacturer"] as! String
            let upcCode = paintProfile.key
            let image = profile?["image"] as! String
            let timestamp = profile?["timestamp"] as! String
            
            // check for colour
            if paintProfile.hasChild("colour") {
                let colourProfile = profile?["colour"] as? NSDictionary
                let colourName = colourProfile?["colourName"] as! String
                let hexcode = colourProfile?["hexcode"] as! String
                let manufacturerID = colourProfile?["manufacturerID"] as! String
                let manufacturer = colourProfile?["manufacturer"] as! String
                let productCode = colourProfile?["productCode"] as! String
                
                let colour = Colour(manufacturerID: manufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: manufacturer)
                
                let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colour, timestamp: timestamp)
                
                self.products.append(product)
            }
            else {
                let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                
                self.products.append(product)
            }
        }
    }, withCancel: { (error) in
        // no items
    })
}

func getRefFor(screenState: ScreenState, user: User, location: Location?, category: String) {
    if screenState == .personal {
        DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(PersonalDashboard).child(category).child(Barcodes)
    }
    if screenState == .business {
        DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard).child((location?.locationName)!).child(category).child(Barcodes)
    }
    if screenState == .homes {
        DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(AddressDashboard).child((location?.locationName)!).child(category).child(Barcodes)
    }
}
 */
