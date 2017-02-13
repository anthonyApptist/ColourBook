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
                let name = snapshot.childSnapshot(forPath: "name").value as! String
                if name != "" {
                    if screenState == .personal {
                        self.signedInUser.name = name
                        self.titleLbl?.text = name
                    }
                    if screenState == .business || screenState == .homes {
                        self.titleLbl?.text = name
                        self.selectedLocation?.name = name
                    }
                    self.subTitleLbl?.text = self.selectedCategory
                }
                else {
                    self.titleLbl?.text = ""
                    if screenState == .personal {
                        self.signedInUser.name = ""
                    }
                    if screenState == .business || screenState == .homes {
                        self.selectedLocation?.name = ""
                    }
                }
            }
            if snapshot.hasChild("image") {
                let imageString = snapshot.childSnapshot(forPath: "image").value as? String
                if imageString != "" {
                    if screenState == .personal {
                        self.signedInUser.image = imageString
                    }
                    if screenState == .business || screenState == .homes {
                        self.selectedLocation?.image = imageString
                    }
                }
                else {
                    if screenState == .personal {
                        self.signedInUser.image = ""
                    }
                    if screenState == .business || screenState == .homes {
                        self.selectedLocation?.image = ""
                    }
                }
            }
            self.hideActivityIndicator()
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
            self.hideActivityIndicator()
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
        if screenState == .searching {
            DataService.instance.generalRef = DataService.instance.addressRef.child(location!)
        }
    }
}
