//
//  GoogleMap-Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 20/3/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CoreLocation

extension GoogleMap {
    func getPublicList() {
        
        let addressRef = DataService.instance.addressRef
        
        addressRef.observe(.value, with: { (snapshot) in
            // for each location in user list (look at public list)
            for location in snapshot.children.allObjects {
                
                let locationData = location as! FIRDataSnapshot
                let locationProfile = locationData.value as? NSDictionary
                
                let locationName = locationData.key
                let postalCode = locationProfile?["postalCode"] as! String
                
                self.locations.append(locationName)
            }
            print(self.locations)
            
            // update UI and user location
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            self.locationManager.startUpdatingLocation()
            self.searchButton?.isUserInteractionEnabled = true
            self.hideActivityIndicator()
        })
    }

}
