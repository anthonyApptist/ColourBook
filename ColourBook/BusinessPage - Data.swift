//
//  BusinessPage - Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 18/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

extension AddEditImageVCBusiness {
    
    func getBusinessInfo(user: User) {
        self.showActivityIndicator()
        
        let userBusinessRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard).child("Business")
        
        userBusinessRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                let businessProfile = snapshot.childSnapshot(forPath: "profile").value as? NSDictionary
                
                let name = businessProfile?["name"] as! String
                let location = businessProfile?["location"] as! String
                let phoneNumber = businessProfile?["phoneNumber"] as? String
                let website = businessProfile?["website"] as? String
                let postalCode = businessProfile?["postalCode"] as? String
                let image = businessProfile?["image"] as? String
                
                let business = Business(name: name, location: location, phoneNumber: phoneNumber, website: website, postalCode: postalCode, image: image)
                
                self.nameTextField?.text = business.name
                self.locationTextField?.text = business.location
                self.siteTextField?.text = business.website
                self.phoneTextField?.text = business.phoneNumber
                self.postalCodeTextField.text = business.postalCode
                
                if business.image == "" || business.image == nil {
                    self.imgView.image = UIImage(named: "darkgreen.jpg")
                }
                else {
                    self.imgView.image = self.stringToImage(imageName: business.image!)
                }
                
            }
            else {
                self.nameTextField?.text = ""
                self.locationTextField?.text = ""
                self.siteTextField?.text = ""
                self.phoneTextField?.text = ""
                self.postalCodeTextField.text = ""
                self.imgView.image = UIImage(named: "darkgreen.jpg")
                
                self.hideActivityIndicator()
            }
            
            
        }, withCancel: { (error) in
            // error
            self.nameTextField?.text = ""
            self.locationTextField?.text = ""
            self.siteTextField?.text = ""
            self.phoneTextField?.text = ""
            self.postalCodeTextField.text = ""
            self.imgView.image = UIImage(named: "darkgreen.jpg")
            
            self.hideActivityIndicator()
        })
    }
    
}
