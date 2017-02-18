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
                
                
            }
        })
    }
    
}
