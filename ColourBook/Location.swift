//
//  Locations.swift
//  ColourBook
//
//  Created by Anthony Ma on 25/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import Foundation

class Location: NSObject, NSCoding {
    
    // MARK: - Types
    
    enum CoderKeys: String {
        case locationNameKey
        case codeKey
        case imageKey
        case nameKey
        case itemsKey
    }
    
    enum Structure: String {
        case house = "house"
        case apartment = "apartment"
        case commercial = "commercial"
    }
    
    // MARK: - Properties
    
    var locationName: String
    var postalCode: String
    var image: String?
    var name: String?
    var items: [Any]?
    
    // MARK: - Initializers
    
    init(locationName: String, postalCode: String) {
        self.locationName = locationName
        self.postalCode = postalCode
    }
    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        locationName = aDecoder.decodeObject(forKey: CoderKeys.locationNameKey.rawValue) as! String
        postalCode = aDecoder.decodeObject(forKey: CoderKeys.codeKey.rawValue) as! String
        image = aDecoder.decodeObject(forKey: CoderKeys.imageKey.rawValue) as? String
        name = aDecoder.decodeObject(forKey: CoderKeys.nameKey.rawValue) as? String
        items = aDecoder.decodeObject(forKey: CoderKeys.itemsKey.rawValue) as? Array
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(locationName, forKey: CoderKeys.locationNameKey.rawValue)
        aCoder.encode(postalCode, forKey: CoderKeys.codeKey.rawValue)
        aCoder.encode(image, forKey: CoderKeys.imageKey.rawValue)
        aCoder.encode(image, forKey: CoderKeys.nameKey.rawValue)
        aCoder.encode(items, forKey: CoderKeys.itemsKey.rawValue)
    }
    
}
