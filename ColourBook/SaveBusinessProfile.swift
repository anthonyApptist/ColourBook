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
            case 1?: // name
                business.name = property
            case 2?: // location
                business.location = property
            case 3?: // phoneNumber
                business.phoneNumber = property
            case 4?: // website
                business.website = property
            case 5?: // postalCode
                business.postalCode = property
            case 6?: // image
                business.image = property
            default:
                break
            }
        }
        
        // new business profile
        let newBusinessProfile = ["name": business.name, "location": business.location, "phoneNumber": business.phoneNumber, "website": business.website, "postalCode": business.postalCode, "image": business.image]
        
        // save to user businesss dashboard
        self.usersRef.child(user.uid).child(BusinessDashboard).child("Business").child("profile").setValue(newBusinessProfile)
        
    }
    
}
