//
//  DataService - Transfer.swift
//  ColourBook
//
//  Created by Anthony Ma on 10/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation

extension DataService {
    
    // transfer to a home in address list
    
    func transfer(products: [ScannedProduct], user: User, location: String?, category: String, destination: String) {
        for item in products {
            
            self.removeScannedProductFor(user: user, screenState: .personal, barcode: item.uniqueID!, location: nil, category: category)
            
            self.saveProductIn(user: user.uid, screenState: .homes, location: location, product: item, category: destination)
            
            self.saveProductFor(location: location, screenState: .homes, product: item, category: destination)
        }
    }
    
}
