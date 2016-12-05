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
    
    @IBOutlet var emailField: CustomTextFieldContainer!
    
    @IBOutlet var passwordField: CustomTextFieldContainer!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    let app = UIApplication.shared.delegate as! AppDelegate

    @IBAction func logInBtnPressed() {
        
        _ = validate(showError: true)
        
        if(!validate(showError: true)) {
            return
        } else {
                    AuthService.instance.login(email: self.emailField.textField.text!, password: self.passwordField.textField.text!) {
                    Completion in
                    
                    if(Completion.0 == nil) {
                        self.performSegue(withIdentifier: "LoginToConnect", sender: nil)
                        self.app.userDefaults.set(true, forKey: "userLoggedIn")
                        self.app.userDefaults.set(true, forKey: "userJoined")
                        self.app.userDefaults.synchronize()
                    } else {
                            ErrorHandler.sharedInstance.show(message: Completion.0!, container: self)
                        
                    }
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailField.setup(placeholder: "Email", validator: "email", type: "email")
        self.passwordField.setup(placeholder: "Password", validator: "required", type: "password")
        
        
    }
    
    func validate(showError: Bool) -> Bool {
        ErrorHandler.sharedInstance.errorMessageView.resetImagePosition()
        if(!emailField.validate()) {
            if(showError) {
                if(emailField.validationError == "blank") {
                    ErrorHandler.sharedInstance.show(message: "Email Field Cannot Be Blank", container: self)
                }
                if(emailField.validationError == "not_email") {
                    ErrorHandler.sharedInstance.show(message: "You should double-check that email address....", container: self)
                }
            }
            return false
        }
        
        if(!passwordField.validate()) {
            if(showError) {
                if(passwordField.validationError == "blank") {
                    ErrorHandler.sharedInstance.show(message: "Password Field Cannot Be Blank", container: self)
                }
            }
            return false
        }
        return true
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailField.textField.resignFirstResponder()
        passwordField.textField.resignFirstResponder()
    }
}
