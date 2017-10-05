//
//  SaveBusinessProfile.swift
//  ColourBook
//
//  Created by Anthony Ma on 7/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation

extension DataService {
    
    func saveBusinessProfile(name: String, address: String, phoneNumber: String, website: String, postalCode: String, image: String) {
        let business = Business()
        business.name = name
        business.address = address
        business.phoneNumber = phoneNumber
        business.website = website
        business.postalCode = postalCode
        business.image = image
        
        // new business profile
        let newBusinessProfile = ["name": business.name, "address": business.address!, "phoneNumber": business.phoneNumber, "website": business.website, "postalCode": business.postalCode]
        
        // save to user businesss dashboard
        self.businessRef.child(business.address!).setValue(newBusinessProfile)
        
        // store business image
        StorageService.instance.storeBusinessImage(imageData: business.image!, location: business.address!)
        
        standardUserDefaults.set(true, forKey: "businessCreated")
        
        let userUID = standardUserDefaults.value(forKey: "uid") as! String
        
        // save to user ref
        self.usersRef.child(userUID).updateChildValues(["businessCreated":business.address!])
        
//        let pubBusinessProfile = ["name": business.name, "location": business.location, "phoneNumber": business.phoneNumber, "website": business.website, "postalCode": business.postalCode, "image": business.image]
//
//        // save to public entry
//        self.businessRef.child(business.location).setValue(pubBusinessProfile)
    }
    
}
