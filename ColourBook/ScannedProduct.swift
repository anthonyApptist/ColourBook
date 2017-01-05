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
//        case timeKey
    }
    
    enum Product: String {
        case paint = "Paint"
    }
    
    
    // MARK: - Properties 
    
    let productType: String
    let manufacturer: String
    let upcCode: String
    let image: String
//    let timestamp: DateFormatter
    
    // MARK: - Initializers
    
    init(productType: String, manufacturer: String, upcCode: String, image: String) {
        self.productType = productType
        self.manufacturer = manufacturer
        self.upcCode = upcCode
        self.image = image
//        self.timestamp = timeStamp
    }
    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        productType = aDecoder.decodeObject(forKey: CoderKeys.typeKey.rawValue) as! String
        manufacturer = aDecoder.decodeObject(forKey: CoderKeys.manufacturerKey.rawValue) as! String
        upcCode = aDecoder.decodeObject(forKey: CoderKeys.upcCodeKey.rawValue) as! String
        image = aDecoder.decodeObject(forKey: CoderKeys.imageKey.rawValue) as! String
//        timestamp = aDecoder.decodeObject(forKey: CoderKeys.timeKey.rawValue) as! DateFormatter
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(productType, forKey: CoderKeys.typeKey.rawValue)
        aCoder.encode(manufacturer, forKey: CoderKeys.manufacturerKey.rawValue)
        aCoder.encode(upcCode, forKey: CoderKeys.upcCodeKey.rawValue)
        aCoder.encode(image, forKey: CoderKeys.imageKey.rawValue)
//        aCoder.encode(image, forKey: CoderKeys.timeKey.rawValue)
    }
    
}
