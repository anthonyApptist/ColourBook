//
//  ItemListEdit - Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 8/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension ItemListEditVC {
    func getInfo(user: User, screenState: ScreenState, location: String?) {
        self.getRef(user: user, screenState: screenState, location: location)
        
        let ref = DataService.instance.generalRef
        
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild("name") {
                
            }
            if snapshot.hasChild("image") {
                let imageString = snapshot.childSnapshot(forPath: "image").value as! String
                
            }
            
            
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
    }
    
    func getRef(user: User, screenState: ScreenState, location: String?) {
        if screenState == .personal {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid)
        }
        if screenState == .business {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard).child("addresses").child(location!)
        }
        if screenState == .homes {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(AddressDashboard).child(location!)
        }
    }
}
