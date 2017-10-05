//
//  Address.swift
//  ColourBook
//
//  Created by Anthony Ma on 2017-08-24.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation

class Address: Location {
    
    // Properties
    var categoryItems: [String:[PaintCan]]?
    var image: String?
    var name: String?
    
    // Init
    override init() {
        super.init()
        self.categoryItems = nil
        self.image = nil
        self.name = nil 
    }
    
}
