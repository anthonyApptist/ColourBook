//
//  AddEditImageVC - Data.swift
//  ColourBook
//
//  Created by Anthony Ma on 24/3/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension AddEditImageVC {
    
    func getPersonalInfo() {
        
        self.showActivityIndicator()
        
        self.ref?.observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild("image") {
                
            }
            
            if snapshot.hasChild("name") {
                
            }
            
            
        })
        
    }
    
}
