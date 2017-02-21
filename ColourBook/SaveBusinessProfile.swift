//
//  SaveBusinessProfile.swift
//  ColourBook
//
//  Created by Anthony Ma on 7/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation

extension DataService {
    
    func saveBusinessProfile(profile: Array<String>, user: User) {
        let business = Business(name: "", location: "", phoneNumber: "", website: "", postalCode: "", image: "")
        
        for property in profile {
            switch profile.index(of: property) {
            case 0?: // name
                business.name = property
                continue
            case 1?: // location
                business.location = property
                continue
            case 2?: // phoneNumber
                business.phoneNumber = property
                continue
            case 3?: // website
                business.website = property
                continue
            case 4?: // postalCode
                business.postalCode = property
                continue
            case 5?: // image
                business.image = property
                continue
            default:
                break
            }
        }
        
        // new business profile
        let newBusinessProfile = ["name": business.name, "location": business.location, "phoneNumber": business.phoneNumber, "website": business.website, "postalCode": business.postalCode, "image": business.image]
        
        // save to user businesss dashboard
        self.usersRef.child(user.uid).child(BusinessDashboard).child("Business").child("profile").setValue(newBusinessProfile)
        
        let pubBusinessProfile = ["name": business.name, "phoneNumber": business.phoneNumber, "website": business.website, "postalCode": business.postalCode, "image": business.image]
        
        // save to public entry
        self.businessRef.child("businesses").child(business.location).setValue(pubBusinessProfile)
        
    }
    
}
