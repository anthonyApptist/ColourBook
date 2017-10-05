//
//  AuthService.swift
//  ColourBook
//
//  Created by Anthony Ma on 27/11/2016.
//  Copyright © 2016 Anthony Ma. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit

enum AuthEnum: String {
    case signedIn = "signedIn"
}

// sign up protocol and actions
protocol SignUpProtocol {
    func errorSigningUp(error: Error)
    func emailVerficationSent()
    func goToLoginVC()
}

// log in protocol and actions
protocol LogInProtocol {
    func errorLoggingIn(error: Error)
    func verifyEmail()
    func passwordReset()
    func loggedIn()
}

// Handle authentication services using firebase functions
class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    // sign in delegate
    var signUpDelegate: SignUpProtocol?
    var logInDelegate: LogInProtocol?
    
    // MARK: - Sign Up Function
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                self.signUpDelegate?.errorSigningUp(error: error!)
            }
            else {
                // email is verified
                if (Auth.auth().currentUser?.isEmailVerified)! {
                    self.signUpDelegate?.goToLoginVC()
                }
                else {
                    // send verification email
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                        if error != nil {
                            self.signUpDelegate?.errorSigningUp(error: error!)
                        }
                        else {
                            self.signUpDelegate?.emailVerficationSent()
                            let userUID = user?.uid
                            let email = user?.email
                            DataService.instance.saveNewUser(uid: userUID!, email: email!)
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - Login Function
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.logInDelegate?.errorLoggingIn(error: error!)
            }
            else {
                // check if email is verified
                if (user?.isEmailVerified)! {
                    self.logInDelegate?.loggedIn()
                    // user uid
                    let userUID = user?.uid
                    standardUserDefaults.set(userUID, forKey: "uid")
                    self.signedInStatus()
                }
                else {
                    self.logInDelegate?.verifyEmail()
                }
            }
        })
    }
    
    // MARK: - Check Signed In
    func checkSignedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: - Check User Exists
    func checkUserExists() -> Bool {
        if standardUserDefaults.value(forKey: "uid") != nil {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: - Perform Sign Out
    func performSignOut() {
        try! Auth.auth().signOut()
    }
    
    // MARK: - Password Reset Email
    func passwordReset(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                self.logInDelegate?.errorLoggingIn(error: error!)
            }
            else {
                self.logInDelegate?.passwordReset()
            }
        }
    }
    
    // MARK: - Save Signed In from Phone
    func signedInStatus() {
        standardUserDefaults.set(true, forKey: AuthEnum.signedIn.rawValue)
    }
    
    // check
    func checkSignedInRecord() -> Bool {
        let record = standardUserDefaults.bool(forKey: AuthEnum.signedIn.rawValue)
        return record
    }
    
    /*
    // MARK: - Save Display Name
    func saveDisplay(name: String) {
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
            changeRequest.displayName = name
            changeRequest.commitChanges(completion: { (error) in
                print(error?.localizedDescription)
            })
        }
    }
     */
}
