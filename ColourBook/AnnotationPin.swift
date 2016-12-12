//
//  AnnotationPin.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-10.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class AnnotationPin: NSObject, MKAnnotation {

    var coordinate = CLLocationCoordinate2D()

    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    
        
    }
}
