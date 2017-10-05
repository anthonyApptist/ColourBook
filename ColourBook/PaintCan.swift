//
//  PaintCan.swift
//  ColourBook
//
//  Created by Anthony Ma on 2017-08-19.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation

// Paint Can product with possible properties based on database

class PaintCan: ScannedProduct {
    
    // Properties
    var manufacturer: String?
    var category: String?
    var code: String?
    
    var colour: Colour?
    
    var uniqueID: String?
    var timestamp: String?
    
    // business
    var businessAdded: String?
    
    // Init
    override init() {
        super.init()
        self.manufacturer = nil
        self.type = nil
        self.category = nil
        self.code = nil
        self.colour = nil
        self.uniqueID = nil
        self.timestamp = nil
        self.businessAdded = nil
    }
    
}
