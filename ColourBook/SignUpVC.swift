//
//  SignUpViewController.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-11-25.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

// Sign up page
class SignUpVC: UIViewController {
    
    // Properties
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var textfieldStack: UIStackView!
    @IBOutlet var emailField: CustomTextFieldContainer!
    @IBOutlet var passwordField: CustomTextFieldContainer!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    
    // MARK: - Sign Up Btn Pressed
    @IBAction func signUpBtnPressed() {
        if (!validate(showError: true)) {
            return
        }
        else {
            let email = emailField.textField.text
            let password = passwordField.textField.text
            AuthService.instance.signUp(email: email!, password: password!)
        }
    }
    
    // MARK: - Facebook Btn Pressed (Unused)
    @IBAction func facebookBtnPressed() {
        
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sign in process
        AuthService.instance.signUpDelegate = self
        
        emailField.setup(placeholder: "Email", validator: "email", type: "email")
        passwordField.setup(placeholder: "Password", validator: "required", type: "password")
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

extension SignUpVC: SignUpProtocol {
    func errorSigningUp(error: Error) {
        self.createAlertController(title: "Error", message: error.localizedDescription)
    }
    
    func goToLoginVC() {
        // go to log in page
        let logInVC = storyboardInstantiate("LogInVC")
        self.present(logInVC, animated: true, completion: nil)
    }
    
    func emailVerficationSent() {
        // go to log in page
        let logInVC = storyboardInstantiate("LogInVC")
        self.present(logInVC, animated: true, completion: {
            // create alert that it is sent
            logInVC.createAlertController(title: "Verification Email Sent", message: "check your email and log in")
        })
    }
}
