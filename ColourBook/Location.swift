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
        case nameKey
        case codeKey
        case imageKey
    }
    
    enum Structure: String {
        case house = "house"
        case apartment = "apartment"
        case commercial = "commercial"
    }
    
    
    // MARK: - Properties
    
    var locationName: String
    var postalCode: String
    var image: String
    
    // MARK: - Initializers
    
    init(locationName: String, postalCode: String, image: String) {
        self.locationName = locationName
        self.postalCode = postalCode
        self.image = image
    }
    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        locationName = aDecoder.decodeObject(forKey: CoderKeys.nameKey.rawValue) as! String
        postalCode = aDecoder.decodeObject(forKey: CoderKeys.codeKey.rawValue) as! String
        image = aDecoder.decodeObject(forKey: CoderKeys.imageKey.rawValue) as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(locationName, forKey: CoderKeys.nameKey.rawValue)
        aCoder.encode(postalCode, forKey: CoderKeys.codeKey.rawValue)
        aCoder.encode(image, forKey: CoderKeys.imageKey.rawValue)
    }
    
}
