//
//  DataService - Report.swift
//  ColourBook
//
//  Created by Anthony Ma on 4/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DataService {
    func reportPressedFor(item: ScannedProduct, user: User, location: String, category: String) {
        let addressRef = self.addressRef.child(location).child(item.upcCode).child("flagged")
        
        addressRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(user.uid) {
                // do nothing
            }
            else {
                addressRef.setValue([user.uid:"flag"])
            }
            
        }) { (error) in
            // error
        }
    }

}
