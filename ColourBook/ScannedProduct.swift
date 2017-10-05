//
//  ScannedProduct.swift
//  ColourBook
//
//  Created by Anthony Ma on 24/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import Foundation

// Model for a scanned product
class ScannedProduct: NSObject {
    
    // Properties
    var upcCode: String?
    var image: String?
    var name: String?
    var type: String?
    
    // Init
    override init() {
        super.init()
        self.upcCode = nil
        self.image = nil
        self.name = nil
        self.type = nil
    }
    
    /*
    // MARK: - Types
    enum CoderKeys: String {
        case typeKey
        case nameKey
        case manufacturerKey
        case upcCodeKey
        case imageKey
        case timeKey
        case uniqueIDKey
    }
    
    // MARK: - Properties 
    
    // product
    let upcCode: String
    let productName: String
    let manufacturer: String
    let image: String
    let productType: String
    
    var category: String?
    var code: String? // manufacturer code
    
    // add on
    var uniqueID: String?
    var timestamp: String?
    var colour: Colour?
    var businessAdded: String?
 
    // MARK: - Initializers
    init(productType: String, productName: String, manufacturer: String, upcCode: String, image: String) {
        self.productType = productType
        self.productName = productName
        self.manufacturer = manufacturer
        self.upcCode = upcCode
        self.image = image
    }
     
    // MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {
        productType = aDecoder.decodeObject(forKey: CoderKeys.typeKey.rawValue) as! String
        productName = aDecoder.decodeObject(forKey: CoderKeys.nameKey.rawValue) as! String
        manufacturer = aDecoder.decodeObject(forKey: CoderKeys.manufacturerKey.rawValue) as! String
        upcCode = aDecoder.decodeObject(forKey: CoderKeys.upcCodeKey.rawValue) as! String
        image = aDecoder.decodeObject(forKey: CoderKeys.imageKey.rawValue) as! String
        timestamp = aDecoder.decodeObject(forKey: CoderKeys.timeKey.rawValue) as? String
        uniqueID = aDecoder.decodeObject(forKey: CoderKeys.uniqueIDKey.rawValue) as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(productType, forKey: CoderKeys.typeKey.rawValue)
        aCoder.encode(productType, forKey: CoderKeys.nameKey.rawValue)
        aCoder.encode(manufacturer, forKey: CoderKeys.manufacturerKey.rawValue)
        aCoder.encode(upcCode, forKey: CoderKeys.upcCodeKey.rawValue)
        aCoder.encode(image, forKey: CoderKeys.imageKey.rawValue)
        aCoder.encode(image, forKey: CoderKeys.timeKey.rawValue)
        aCoder.encode(uniqueID, forKey: CoderKeys.uniqueIDKey.rawValue)
    }
    */
}
