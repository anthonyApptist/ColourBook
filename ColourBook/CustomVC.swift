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

class CustomVC: UIViewController, UITextFieldDelegate {
    
    
    var titleString: String?
    
    var screenState = ScreenState.none
    
    var nextVC: CustomVC?
    
    var backButtonNeeded: Bool?
    
    var backBtnImage = UIImage(named: "arrowBack")
    
    var backBtn = UIButton(frame: CGRect(x: 20, y: 25, width: 40, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()

        //DEFAULT VALUES
        
        self.backButtonNeeded = true
        
        
  

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        print(titleString)
        print(screenState.hashValue)
        
        
        if screenState == ScreenState.personal {
            self.titleString = "personal"
        } else if screenState == ScreenState.business {
            self.titleString = "business"
        } else if screenState == ScreenState.homes {
            self.titleString = "my homes"
        }
        
        
        if(self.backButtonNeeded == true) {
            
            self.backBtn.setImage(self.backBtnImage, for: .normal)
            self.view.addSubview(self.backBtn)
            
            self.backBtn.addTarget(self, action: #selector(self.backBtnPressed(_:)), for: .touchUpInside)
            
        }
        
        if(self.backButtonNeeded == false) {
            
            self.backBtn.removeFromSuperview()
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
   
    func backBtnPressed(_ sender: AnyObject) {
        
        
        self.dismiss(animated: false, completion: nil)
        
        
        
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
   
    
        self.nextVC = segue.destination as? CustomVC
        
        self.nextVC?.screenState = self.screenState
    
 
    }
}
