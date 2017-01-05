//
//  DataService-Delete.swift
//  ColourBook
//
//  Created by Anthony Ma on 30/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DataService {
    
    // MARK: - Remove Location
    
    func removeLocationFor(user: User, screenState: ScreenState, locationName: String) {
        
        getAddressRefFor(user: user, screenState: screenState)
        
        let locationRef = self.generalRef
        
        // remove location from user list
        
        locationRef?.child(locationName).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
        })
        
    }
    
    func getAddressRefFor(user: User, screenState: ScreenState) {
        
        if screenState == .business {
            self.generalRef = self.usersRef.child(user.uid).child(BusinessDashboard)
        }
        if screenState == .homes {
            self.generalRef = self.usersRef.child(user.uid).child(AddressDashboard)
        }
        
    }
    
    
    // MARK: - Remove Product
    
    func removeScannedProductFor(user: User, screeenState: ScreenState, barcode: String, location: String?) {
        
        getBarcodeRefFor(user: user, screenState: screeenState, location: location)
        
        let locationRef = self.generalRef
        
        // remove product from user list
        
        locationRef?.child(barcode).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
        })

        
    }
    
    func getBarcodeRefFor(user: User, screenState: ScreenState, location: String?) {
        
        if screenState == .personal {
            self.generalRef = self.usersRef.child(user.uid).child(PersonalDashboard).child(Barcodes)
        }
        if screenState == .business {
            self.generalRef = self.usersRef.child(user.uid).child(BusinessDashboard).child(location!).child(Barcodes)
        }
        if screenState == .homes {
            self.generalRef = self.usersRef.child(user.uid).child(AddressDashboard).child(location!).child(Barcodes)
        }

    }
    
}
