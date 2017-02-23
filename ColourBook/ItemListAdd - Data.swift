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
        let dataRef = DataService.instance.generalRef
        
        dataRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // get business lists and images
            for business in snapshot.childSnapshot(forPath: "businesses").children.allObjects {
                let businessProfile = business as! FIRDataSnapshot
                let businessData = businessProfile.value as? NSDictionary
                
                // location
                let name = businessData?["name"] as! String
                let locationName = businessProfile.key
                
                let image = businessData?["image"] as? String
                let postalCode = businessData?["postalCode"] as? String
                let phoneNumber = businessData?["phoneNumber"] as? String
                let website = businessData?["website"] as? String
                
                let newBusiness = Business(name: name, location: locationName, phoneNumber: phoneNumber, website: website, postalCode: postalCode, image: image)
                
                if newBusiness.image == "" || newBusiness.image == nil {
                    self.businessImages.updateValue("", forKey: newBusiness.location)
                }
                else {
                    self.businessImages.updateValue(newBusiness.image!, forKey: newBusiness.location)
                }
            }
            
            if screenState == .homes {
                if snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: user.uid).childSnapshot(forPath: AddressDashboard).exists() {
                    
                    // get public address data
                    for address in snapshot.childSnapshot(forPath: "addresses").children.allObjects {
                        let addressProfile = address as! FIRDataSnapshot
                        let addressData = addressProfile.value as? NSDictionary
                        
                        // location 
                        let postalCode = addressData?["postalCode"] as! String
                        let locationName = addressProfile.key
                        
                        let image = addressData?["image"] as? String
                        let name = addressData?["name"] as? String
                        
                        let location = Location(locationName: locationName, postalCode: postalCode)
                        location.image = image
                        location.name = name
                        
                        self.locations.append(location)
                    }
                    // get user address data
                    for address in snapshot.childSnapshot(forPath: "users").childSnapshot(forPath: user.uid).childSnapshot(forPath: AddressDashboard).children.allObjects {
                        
                    }
                    
                }
                else {
                    self.hideActivityIndicator()
                }
            }
            // else business screen state
            else {
                
                // user business address list
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
                // no addresses
                else {
                    self.hideActivityIndicator()
                }
            }
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
            self.hideActivityIndicator()
        })
    }
    
    func getLocationsRefFor(user: User, screenState: ScreenState) {
        if screenState == .business {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard).child("addresses")
        }
        else if screenState == .homes {
            DataService.instance.generalRef = DataService.instance.mainRef
        }
    }

}
