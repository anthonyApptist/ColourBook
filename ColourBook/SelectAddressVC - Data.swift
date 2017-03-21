//
//  SelectAddressVC - Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 25/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension SelectAddressVC {
    
    func getLocationLists(screenState: ScreenState, user: User) {
        
        getLocationsRefFor(user: user, screenState: screenState)
        
        let locationsRef = DataService.instance.generalRef
        
        locationsRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if screenState == .business {
                if snapshot.hasChild("Business") {
                    
                    let businessProfile = snapshot.childSnapshot(forPath: "Business").childSnapshot(forPath: "profile").value as? NSDictionary
                    
                    // get business location
                    let name = businessProfile?["name"] as! String
                    let businessLocation = businessProfile?["location"] as! String
                    let businessPhoneNumber = businessProfile?["phoneNumber"] as? String
                    let businessWebsite = businessProfile?["website"] as? String
                    let businessPostalCode = businessProfile?["postalCode"] as? String
                    let businessImage = businessProfile?["image"] as? String
                    
                    let business = Business(name: name, location: businessLocation, phoneNumber: businessPhoneNumber, website: businessWebsite, postalCode: businessPostalCode, image: businessImage)
                    
                    self.business = business
                    
                    // add the business
                    
                    if snapshot.hasChild("addresses") {
                        
                        for child in snapshot.childSnapshot(forPath: "addresses").children.allObjects {
                            let addressProfile = child as! FIRDataSnapshot
                            let profile = addressProfile.value as? NSDictionary
                            let postalCode = profile?["postalCode"] as! String
                            let image = profile?["image"] as? String
                            let name = profile?["name"] as? String
                            let locationName = addressProfile.key
                            let location = Location(locationName: locationName, postalCode: postalCode)
                            location.image = image
                            location.name = name
                            
                            self.locations.append(location)
                        }
                        self.tableView.reloadData()
                        self.hideActivityIndicator()
                        
                    }
                    else {
                        self.displayNoAddresses()
                    }
                }
                else {
                    self.displayNoBusinessPage()
                }
            }
            if screenState == .homes || screenState == .transfer {
                
                if snapshot.hasChildren() {
                    
                    for child in snapshot.children.allObjects {
                        let addressProfile = child as! FIRDataSnapshot
                        let profile = addressProfile.value as? NSDictionary
                        let locationName = addressProfile.key
                        let postalCode = profile?["postalCode"] as! String
                        let image = profile?["image"] as? String
                        let name = profile?["name"] as? String
                        let location = Location(locationName: locationName, postalCode: postalCode)
                        
                        location.image = image
                        location.name = name
                        
                        self.locations.append(location)
                    }
                    self.tableView.reloadData()
                    self.hideActivityIndicator()
                    
                }
                else {
                    self.displayNoAddresses()
                }
            }
            
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
            self.hideActivityIndicator()
            self.displayNoAddresses()
        })
    }
    
    func getLocationsRefFor(user: User, screenState: ScreenState) {
        
        if screenState == .business {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard)
        }
        else if screenState == .homes || screenState == .transfer {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(AddressDashboard)
        }
    }
}
