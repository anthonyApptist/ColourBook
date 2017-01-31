//
//  SettingsVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-06.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class SettingsVC: CustomVC {
 
    var selectedLocation: Location?
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(false)

        // Do any additional setup after loading the view.
        
        

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
      
        if segue.identifier == "ShowInfo" {
            
            if let detail = segue.destination as? AddEditImageVC {
                
                detail.selectedLocation = selectedLocation
                detail.screenState = screenState
            }

        }
        
    
        
    }
    
}
