//
//  Business.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-06.
//  Copyright © 2016 Apptist. All rights reserved.
//

import Foundation
import MapKit

class Business {
    
    var name: String
    
    var addressName: String
    
    var latitude: Double
    
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D?
    
    var items: [Paint]
    
    private var _imageName: String?
    
    //var currentlyContracting: NSDictionary
    
    var imageName: String {
        return _imageName!
    }
    
    var image: UIImage?
    
    init(name: String, address: String, lat: Double, long: Double) {
        self.name = name
        self.latitude = lat
        self.longitude = long
        self.addressName = address
        self.items = []
        _imageName = "darkred"
        
        self.image = UIImage(named: _imageName!)
        
        self.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        
    }
    
    func addItem(item: Paint) {
        items.append(item)
    }
    
}
