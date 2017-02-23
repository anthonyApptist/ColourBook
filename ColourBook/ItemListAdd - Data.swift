//
//  ItemListAdd - Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 8/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension ItemListAddVC {
    
    func getLocationLists(screenState: ScreenState, user: User) {
        getLocationsRefFor(user: user, screenState: screenState)
        let locationsRef = DataService.instance.generalRef
        
        locationsRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                    for child in snapshot.children.allObjects {
                        let addressProfile = child as! FIRDataSnapshot
                        let profile = addressProfile.value as? NSDictionary
                        
                        let postalCode = profile?["postalCode"] as! String
                        let locationName = addressProfile.key
                        
                        let image = profile?["image"] as? String
                        let name = profile?["name"] as? String
                        
                        let location = Location(locationName: locationName, postalCode: postalCode)
                        location.image = image
                        location.name = name
                        
                        self.locations.append(location)
                    }
                    self.tableView?.reloadData()
                    self.hideActivityIndicator()
            }
            
            else {
                self.hideActivityIndicator()
            }
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
            self.hideActivityIndicator()
        })
    }
    
    func getLocationsRefFor(user: User, screenState: ScreenState) {
        if screenState == .business {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard)
        }
        else if screenState == .homes {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(AddressDashboard)
        }
    }

}
