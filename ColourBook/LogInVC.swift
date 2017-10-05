//
//  LogInViewController.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-11-21.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

// Log in page

class LogInVC: UIViewController {
    
    // Properties
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet var emailField: CustomTextFieldContainer!
    @IBOutlet var passwordField: CustomTextFieldContainer!
    @IBOutlet weak var signUpBtn: UIButton!
    
    // MARK: - Forgot Password Btn Fcn
    @IBAction func forgotPwButtonPressed() {
        ErrorHandler.sharedInstance.errorMessageView.resetImagePosition()
        if(!emailField.validate()) {
            if(emailField.validationError == "blank") {
                ErrorHandler.sharedInstance.show(message: "Email Field Cannot Be Blank", container: self)
            }
            if(emailField.validationError == "not_email") {
                ErrorHandler.sharedInstance.show(message: "You should double-check that email address....", container: self)
            }
        }
        else {
            AuthService.instance.passwordReset(email: emailField.textField.text!)
        }
    }

    // MARK: - Log In Btn Fcn
    @IBAction func logInBtnPressed() {
        if (!validate(showError: true)) {
            return
        } else {
            AuthService.instance.login(email: self.emailField.textField.text!, password: self.passwordField.textField.text!)
        }
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AuthService.instance.logInDelegate = self
        
        self.emailField.setup(placeholder: "Email", validator: "email", type: "email")
        self.passwordField.setup(placeholder: "Password", validator: "required", type: "password")
    }
    
    // MARK: - Validate
    func validate(showError: Bool) -> Bool {
        ErrorHandler.sharedInstance.errorMessageView.resetImagePosition()
        if (!emailField.validate()) {
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
        if (!passwordField.validate()) {
            if(showError) {
                if(passwordField.validationError == "blank") {
                    ErrorHandler.sharedInstance.show(message: "Password Field Cannot Be Blank", container: self)
                }
            }
            return false
        }
        return true
    }

    // MARK: - Touches Ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailField.textField.resignFirstResponder()
        passwordField.textField.resignFirstResponder()
    }
}

extension LogInVC: LogInProtocol {
    func errorLoggingIn(error: Error) {
        self.createAlertController(title: "Error", message: error.localizedDescription)
    }
    
    func verifyEmail() {
        self.createAlertController(title: "Please verify your email", message: "")
    }
    
    func passwordReset() {
        self.createAlertController(title: "Password Reset Email Sent To:", message: emailField.textField.text!)
    }
    
    func loggedIn() {
        // present dashboard
        let cbDashboard = ColourBookDashboard(screenState: .none)
        let dashboard = storyboardInstantiate("MyDashboardVC") as! MyDashboardVC
        dashboard.cbDashboard = cbDashboard
        dashboard.cbDashboard?.errorDelegate = dashboard
        dashboard.cbDashboard?.loadAddressDelegate = dashboard
        self.present(dashboard, animated: true, completion: nil)
    }
}
