//
//  DataService - Transfer.swift
//  ColourBook
//
//  Created by Anthony Ma on 10/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation

// Transfer a set of products from personal list to an address

extension DataService {
    
    // MARK: - Transfer
    func transfer(products: [PaintCan], location: String?, category: String, destination: String) {
        for item in products {
            // remove from user list
            self.removeScannedProductFor(screenState: .personal, uniqueID: item.uniqueID!, location: location, category: category)
            
            self.savePaintCanToDashboard(screenState: .homes, location: location, product: item, category: destination)
        }
    }
}
