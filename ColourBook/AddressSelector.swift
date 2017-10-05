//
//  SelectAddressVC - Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 25/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

// for address select
protocol AddressSelect {
    func noBusinessProfile()
    func noAddresses()
    func updateAddresses(_ addresses: [Address])
    func updateBusiness(_ business: String)
}

class AddressSelector: ColourBook {
    
    // delegate
    var delegate: AddressSelect?
    
    // addresses
    var addresses: [Address]?
    var userBusiness: String?

    // MARK: - Retrieve info
    func retreive() {
        switch self.screenState! {
        case .business:
            self.getBusinessAddresses()
            break
        case .homes:
            self.getHomeAddresses()
            break
        default:
            break
        }
    }
    
    // MARK: - Business Addresses
    func getBusinessAddresses() {
        let userUID = standardUserDefaults.value(forKey: "uid") as! String
        let userBusinessRef = DataService.instance.usersRef.child(userUID)
        
        userBusinessRef.observeSingleEvent(of: .value, with: { (snap) in
            if snap.hasChild("businessCreated") {
                let businessName = snap.childSnapshot(forPath: "businessCreated").value as! String
                self.userBusiness = businessName
                
                if let businessID = standardUserDefaults.value(forKey: "business") as? String {
                    self.reference = userBusinessRef.parent?.parent?.child("public").child(kBusinessDashboard).child(businessID)
                    self.reference?.observeSingleEvent(of: .value, with: { (snapshot) in
                        // address array
                        self.addresses = []
                        
                        /*
                        // grab from business info
                        let businessProfile = snapshot.childSnapshot(forPath: "business").value as? NSDictionary
                        
                        // business
                        let postalCode = businessProfile?["postalCode"] as? String
                        let address = businessProfile?["address"] as? String
                        let name = businessProfile?["name"] as? String
                        let phoneNumber = businessProfile?["phoneNumber"] as? String
                        let website = businessProfile?["website"] as? String
                        let image = businessProfile?["image"] as? String
                        
                        let business = Business()
                        
                        business.postalCode = postalCode
                        business.address = address
                        business.name = name
                        business.phoneNumber = phoneNumber
                        business.website = website
                        business.image = image
                        // set model
                        self.userBusiness = business
                         */
                        
                        // grab addresses
                        for address in snapshot.children.allObjects {
                            let addressData = address as! DataSnapshot
                            let addressProfile = addressData.value as? NSDictionary
                            
                            // categories array
                            var categories: [String] = []
                            
                            for category in addressData.childSnapshot(forPath: "categories").children.allObjects {
                                let categoryObject = category as! DataSnapshot
                                let categoryName = categoryObject.key
                                categories.append(categoryName)
                            }
                            
                            // new address
                            let anAddress = Address()
                            
                            let postalCode = addressProfile?["postalCode"] as? String
                            let address = addressData.key
                            
                            anAddress.postalCode = postalCode
                            anAddress.address = address
                            
                            // add to addresses
                            self.addresses?.append(anAddress)
                        }
                        // check if no addresses
                        if (self.addresses?.isEmpty)! {
                            self.delegate?.noAddresses()
                            return
                        }
                        
                        self.delegate?.updateAddresses(self.addresses!)
                        self.delegate?.updateBusiness(self.userBusiness!)
                        
                    }, withCancel: { (error) in
                        // error
                        self.errorDelegate?.loadError(error)
                    })
                }
            }
            else {
                self.delegate?.noBusinessProfile()
            }
        }) { (error) in
            // error
        }
    }
    
    // MARK: - Home Addresses
    func getHomeAddresses() {
        if let homeID = standardUserDefaults.value(forKey: "home") as? String {
            self.reference = DataService.instance.homeDashboardRef.child(homeID)
            self.reference?.observeSingleEvent(of: .value, with: { (snapshot) in
                // address array
                self.addresses = []
                
                // grab addresses
                for address in snapshot.children.allObjects {
                    let addressData = address as! DataSnapshot
                    let addressProfile = addressData.value as? NSDictionary
                    
                    // categories array
                    var categories: [String] = []
                    
                    for category in addressData.childSnapshot(forPath: "categories").children.allObjects {
                        let categoryObject = category as! DataSnapshot
                        let categoryName = categoryObject.key
                        categories.append(categoryName)
                    }
                    
                    // new address
                    let anAddress = Address()
                    
                    let postalCode = addressProfile?["postalCode"] as? String
                    let address = addressData.key
                    
                    anAddress.postalCode = postalCode
                    anAddress.address = address
                    
                    // add to addresses
                    self.addresses?.append(anAddress)
                    
                }
                // check if no addresses
                if (self.addresses?.isEmpty)! {
                    self.delegate?.noAddresses()
                    return
                }
                self.delegate?.updateAddresses(self.addresses!)
                
            }, withCancel: { (error) in
                self.errorDelegate?.loadError(error)
            })
        }
        else {
            self.delegate?.noAddresses()
        }
    }
    
    // remove observers
}

extension SelectAddressVC {
    
    func getLocationLists(screenState: ScreenState, user: User) {
        /*
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
         */
    }
    
    func getLocationsRefFor(user: User, screenState: ScreenState) {
        /*
        if screenState == .business {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard)
        }
        else if screenState == .homes || screenState == .transfer {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(AddressDashboard)
        }
         */
    }
}
