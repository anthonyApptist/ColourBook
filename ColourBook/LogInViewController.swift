//
//  LogInViewController.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-11-21.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class LogInViewController : UIViewController {
    
    @IBOutlet weak var topBar: UIView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var logInBtn: UIButton!
    
    @IBOutlet weak var usernameTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBAction func signUpBtnPressed() {
        AuthService.instance.login(email: usernameTxtField.text!, password: passwordTxtField.text!, onComplete: nil)
    }
    
    @IBAction func logInBtnPressed() {
        AuthService.instance.login(email: usernameTxtField.text!, password: passwordTxtField.text!, onComplete: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
