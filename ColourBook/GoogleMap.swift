//
//  GoogleMap.swift
//  ColourBook
//
//  Created by Anthony Ma on 3/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps

class GoogleMap: CustomVC {
    
    let locationManager = CLLocationManager()
    
    override func loadView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButtonNeeded = true
    }
}
