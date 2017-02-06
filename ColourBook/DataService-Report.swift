//
//  DataService-Report.swift
//  ColourBook
//
//  Created by Anthony Ma on 4/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DataService {
    func reportPressedFor(item: ScannedProduct, user: User) {
        let userItemRef = self.usersRef.child(user.uid).child(item.upcCode).child("flagged")
        
        userItemRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(user.uid) {
                // do nothing
            }
            else {
                userItemRef.setValue([user.uid:"flag"])
            }
            
        }) { (error) in
            userItemRef.child("flagged").setValue([user.uid:"flag"])
        }
    }
}
