//
//  Colourer.swift
//  ColourBook
//
//  Created by Anthony Ma on 2017-08-24.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation

class Colourer: User {
    
    // Properties
    var name: String?
    var image: String?
    
    // Init
    override init() {
        super.init()
        self.name = nil
        self.image = nil
    }
    
}
