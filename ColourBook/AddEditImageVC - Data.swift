//
//  AddEditImageVC - Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 24/3/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension AddEditImageVC {
    
    // Get personal info
    func getPersonalInfo() {
        self.showActivityIndicator()
        let userUID = standardUserDefaults.value(forKey: "uid") as! String
        self.ref = DataService.instance.usersRef.child(userUID)
        
        self.ref?.observe(.value, with: { (snapshot) in
            self.colourer = Colourer()
            
            if snapshot.hasChild("image") {
                let imageString = snapshot.childSnapshot(forPath: "image").value as! String
                self.imgView.image = self.setImageFrom(urlString: imageString)
                self.resizedImg = self.imgView.image
            }
            if snapshot.hasChild("name") {
                let name = snapshot.childSnapshot(forPath: "name").value as! String
                self.textField?.text = name
            }
            self.hideActivityIndicator()
        })
    }
    
    func getAddressInfo() {
        self.showActivityIndicator()
        let homeID = standardUserDefaults.value(forKey: "home") as! String
        self.ref = DataService.instance.homeDashboardRef.child(homeID).child((self.selectedLocation?.address)!)
        
        self.ref?.observe(.value, with: { (snapshot) in
            if snapshot.hasChild("image") {
                let imageString = snapshot.childSnapshot(forPath: "image").value as! String
                self.imgView.image = self.setImageFrom(urlString: imageString)
                self.resizedImg = self.imgView.image
            }
            if snapshot.hasChild("name") {
                let name = snapshot.childSnapshot(forPath: "name").value as! String
                self.textField?.text = name
            }
            self.hideActivityIndicator()
        })
    }
    
}
