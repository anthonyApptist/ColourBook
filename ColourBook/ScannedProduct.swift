//
//  ScannedProduct.swift
//  ColourBook
//
//  Created by Anthony Ma on 24/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import Foundation

class ScannedProduct: NSObject, NSCoding {
    
    
    // MARK: - Types 
    
    enum CoderKeys: String {
        case typeKey
        case manufacturerKey
        case upcCodeKey
        case imageKey
        case colourKey
        case timeKey
        case uniqueIDKey
        case businessKey
    }
    
    enum Product: String {
        case paint = "Paint"
    }
    
    
    // MARK: - Properties 
    
    let productType: String
    let manufacturer: String
    let upcCode: String
    let image: String
    var colour: Colour?
    let timestamp: String
    var uniqueID: String?
    var businessAdded: String?
    
    // MARK: - Initializers
    
    init(productType: String, manufacturer: String, upcCode: String, image: String, colour: Colour?, timestamp: String) {
        self.productType = productType
        self.manufacturer = manufacturer
        self.upcCode = upcCode
        self.image = image
        self.colour = colour
        self.timestamp = timestamp
    }
    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        productType = aDecoder.decodeObject(forKey: CoderKeys.typeKey.rawValue) as! String
        manufacturer = aDecoder.decodeObject(forKey: CoderKeys.manufacturerKey.rawValue) as! String
        upcCode = aDecoder.decodeObject(forKey: CoderKeys.upcCodeKey.rawValue) as! String
        image = aDecoder.decodeObject(forKey: CoderKeys.imageKey.rawValue) as! String
        colour = aDecoder.decodeObject(forKey: CoderKeys.colourKey.rawValue) as? Colour
        timestamp = aDecoder.decodeObject(forKey: CoderKeys.timeKey.rawValue) as! String
        uniqueID = aDecoder.decodeObject(forKey: CoderKeys.uniqueIDKey.rawValue) as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(productType, forKey: CoderKeys.typeKey.rawValue)
        aCoder.encode(manufacturer, forKey: CoderKeys.manufacturerKey.rawValue)
        aCoder.encode(upcCode, forKey: CoderKeys.upcCodeKey.rawValue)
        aCoder.encode(image, forKey: CoderKeys.imageKey.rawValue)
        aCoder.encode(colour, forKey: CoderKeys.colourKey.rawValue)
        aCoder.encode(image, forKey: CoderKeys.timeKey.rawValue)
        aCoder.encode(uniqueID, forKey: CoderKeys.uniqueIDKey.rawValue)
    }
    
}
