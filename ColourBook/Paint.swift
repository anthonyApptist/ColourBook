//
//  PaintCan.swift
//  ColourBook
//
//  Created by Anthony Ma on 26/11/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class Paint: NSObject {
    
    var manufacturer: String
    var productName: String
    var category: String
    var code: String
    var upcCode: String
    var image: String
    var colour: Colour?
    var timestamp: String?
    var productType: String?
    var uniqueID: String?
    
    init(manufacturer: String, productName: String, category: String, code: String, upcCode: String, image: String) {
        self.manufacturer = manufacturer
        self.productName = productName
        self.category = category
        self.code = code
        self.upcCode = upcCode
        self.image = image
    }
}
