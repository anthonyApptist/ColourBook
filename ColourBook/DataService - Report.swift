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
    
    // MARK: - Report
    func reportPressedFor(user: String, location: String, category: String, uniqueID: String) {
        // report only public lists
        let addressRef = self.addressRef.child(location).child("categories").child(category).child(uniqueID).child("flagged")
        
        addressRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(user) {
                // do nothing
                // already flagged
            }
            else {
                addressRef.setValue([user:"flag"])
            }
            
        }) { (error) in
            // error
        }
        
    }

}
