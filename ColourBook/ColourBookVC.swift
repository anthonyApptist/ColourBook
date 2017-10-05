//
//  ColourBookVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-08.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

// Base View Controller Model for all UIViewControllers

enum ScreenState { // different screen states to determine functions
    case none
    case personal
    case business
    case homes
    case transfer
    case searching
}

class ColourBookVC: UIViewController, UITextFieldDelegate {
    
    // Properties
    var titleString: String?
    var screenState = ScreenState.none
    var backButtonNeeded: Bool?
    var backBtnImage = UIImage(named: "arrowBack")
    var backBtn = UIButton(frame: CGRect(x: 20, y: 25, width: 40, height: 40))
    
//    var nextVC: CustomVC?

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backButtonNeeded = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
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
    
    // MARK: - Textfield End Editing
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
    // MARK: - Touches Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
    }
    
    // MARK: - Back Btn Function
    func backBtnPressed(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
 
    /*
    // MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.nextVC = segue.destination as? CustomVC
        
        // reload table view if in upcoming view
        if let itemListAdd = self.nextVC as? ItemListAddVC {
            itemListAdd.tableView?.reloadData()
        }
        self.nextVC?.screenState = self.screenState
    }
     */
    
    // MARK: - Set Title for Edit Screen
    func setAddEditAddressTitle(screenState: ScreenState) -> String {
        
        if screenState == .business {
            return "edit business"
        }
        else if screenState == .homes {
            return "edit address"
        }
        else {
            return ""
        }
    }
}
