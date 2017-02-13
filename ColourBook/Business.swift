//
//  Business.swift
//  ColourBook
//
//  Created by Anthony Ma on 7/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation

class Business: NSObject, NSCoding {
    
    // MARK: - Types
    
    enum CoderKeys: String {
        case nameKey
        case locationKey
        case phoneNumberKey
        case websiteKey
        case postalCodeKey
        case imageKey
    }
    
    // MARK: - Properties
    
    var name: String
    var location: String
    var phoneNumber: String?
    var website: String?
    var postalCode: String?
    var image: String?
    
    // MARK: - Initializers
    
    init(name: String, location: String, phoneNumber: String?, website: String?, postalCode: String?, image: String?) {
        self.name = name
        self.location = location
        self.phoneNumber = phoneNumber
        self.website = website
        self.postalCode = postalCode
        self.image = image
    }
    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: CoderKeys.nameKey.rawValue) as! String
        location = aDecoder.decodeObject(forKey: CoderKeys.locationKey.rawValue) as! String
        phoneNumber = aDecoder.decodeObject(forKey: CoderKeys.phoneNumberKey.rawValue) as? String
        website = aDecoder.decodeObject(forKey: CoderKeys.websiteKey.rawValue) as? String
        postalCode = aDecoder.decodeObject(forKey: CoderKeys.postalCodeKey.rawValue) as? String
        image = aDecoder.decodeObject(forKey: CoderKeys.imageKey.rawValue) as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CoderKeys.nameKey.rawValue)
        aCoder.encode(location, forKey: CoderKeys.locationKey.rawValue)
        aCoder.encode(phoneNumber, forKey: CoderKeys.phoneNumberKey.rawValue)
        aCoder.encode(website, forKey: CoderKeys.websiteKey.rawValue)
        aCoder.encode(postalCode, forKey: CoderKeys.postalCodeKey.rawValue)
        aCoder.encode(image, forKey: CoderKeys.imageKey.rawValue)
    }

    
}
