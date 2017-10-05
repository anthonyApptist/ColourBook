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
    
    // Get Business Info
    func getBusinessInfo() {
        self.showActivityIndicator()
        let userUID = standardUserDefaults.value(forKey: "uid") as! String
        let userRef = DataService.instance.usersRef.child(userUID)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("businessCreated") {
                let businessName = snapshot.childSnapshot(forPath: "businessCreated").value as! String
                let businessRef = userRef.parent?.parent?.child("public").child("businesses").child(businessName)
                
                businessRef?.observe(.value, with: { (snapshot) in
                    for item in snapshot.children.allObjects {
                        let businessProfile = snapshot.value as? NSDictionary
                        
                        let name = businessProfile?["name"] as! String
                        let location = businessProfile?["address"] as! String
                        let phoneNumber = businessProfile?["phoneNumber"] as? String
                        let website = businessProfile?["website"] as? String
                        let postalCode = businessProfile?["postalCode"] as? String
                        let image = businessProfile?["image"] as? String
                        
                        // update ui with fields
                        self.nameTextField?.text = name
                        self.locationTextField?.text = location
                        self.siteTextField?.text = website
                        self.phoneTextField?.text = phoneNumber
                        self.postalCodeTextField.text = postalCode
                        
                        // there is an image
                        self.imgView.image = self.setImageFrom(urlString: image!)
                    }
                    self.hideActivityIndicator()
                }, withCancel: { (error) in
                    // error
                })
            }
            else {
                self.nameTextField?.text = ""
                self.locationTextField?.text = ""
                self.siteTextField?.text = ""
                self.phoneTextField?.text = ""
                self.postalCodeTextField.text = ""
                self.imgView.image = kDarkGreenLogo
                
                self.hideActivityIndicator()
            }
            
        }, withCancel: { (error) in
            // error
            self.nameTextField?.text = ""
            self.locationTextField?.text = ""
            self.siteTextField?.text = ""
            self.phoneTextField?.text = ""
            self.postalCodeTextField.text = ""
            self.imgView.image = kDarkGreenLogo
            
            self.hideActivityIndicator()
        })
    }
}
