//
//  CustomVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-08.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

enum ScreenState {
    case none
    case personal
    case business
    case homes
}

class CustomVC: UIViewController {
    
    var titleString: String = ""
    
    var screenState = ScreenState.none

    override func viewDidLoad() {
        super.viewDidLoad()

        if titleString == "personal" {
            screenState = ScreenState.personal
        } else if titleString == "business" {
            screenState = ScreenState.business
        } else if titleString == "my homes" {
            screenState = ScreenState.homes
        }
        
        print(screenState)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nextVC = segue.destination as? CustomVC {
            
            nextVC.screenState = self.screenState
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
