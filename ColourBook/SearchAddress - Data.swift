//
//  SearchAddress - Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 26/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension SearchAddressVC {
    
    func getDatabase() {
        
        // Get address database (both business and address)
        
        let databaseRef = DataService.instance.mainRef
        
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // businesses database check
            
            for child in snapshot.childSnapshot(forPath: "businesses").children.allObjects {
                
                let locationProfile = child as! FIRDataSnapshot
                let locationData = locationProfile.value as? NSDictionary
                let postalCode = locationData?["postalCode"] as! String
                let name = locationData?["name"] as? String
                let image = locationData?["image"] as? String
                let locationName = locationProfile.key
                
                let location = Location(locationName: locationName, postalCode: postalCode)
                
                location.name = name
                location.image = image
                
                self.addressDictionary.updateValue("Address", forKey: location)
                self.allAddresses.append(location)
            }
            
            // addresses database check
            
            for child in snapshot.childSnapshot(forPath: "addresses").children.allObjects {
                
                let locationProfile = child as! FIRDataSnapshot
                let locationData = locationProfile.value as? NSDictionary
                let postalCode = locationData?["postalCode"] as! String
                let name = locationData?["name"] as? String
                let image = locationData?["image"] as? String
                let locationName = locationProfile.key
                
                let location = Location(locationName: locationName, postalCode: postalCode)
                
                location.name = name
                location.image = image
                
                self.addressDictionary.updateValue("Address", forKey: location)
                self.allAddresses.append(location)
            }
            
            let resultsUpdater = self.addressSC?.searchResultsUpdater as! SearchResultsTableVC
            resultsUpdater.allAddresses = self.allAddresses
            
            self.hideActivityIndicator()
            self.searchButton.isUserInteractionEnabled = true
        })
    }
    
}
