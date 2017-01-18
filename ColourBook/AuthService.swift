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

typealias Completion = (_ errorMessage: String?, _ data: AnyObject?) -> Void

class AuthService {
    private static let _instance = AuthService()
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    if errCode == .errorCodeUserNotFound {
                        
                        // create user if it doesn't exist
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                            }
                            else {
                                if user?.uid != nil {
                    
                                    // save user uid to database
                                    DataService.instance.createNewUser(uid: user!.uid, email: email, image: "")
                                    
                                    FIRAuth.auth()!.signIn(withEmail: email, password: password, completion: { (user, error) in
                                        
                                        if error != nil {
                                            print(error!.localizedDescription)
                                        }
                                        else {
                                            let createdUser = User(uid: user!.uid, email: user!.email!, name: "", image: "")
                                            print(createdUser.email)
                                            print("signed in created user")
                                            onComplete?(nil, user)
                                        }
                                    })
                                    
                                }
                                else {
                                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                                }
                            }
                        })
                    }
                    else {
                        // handle other errors
                        self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                    }
                }
            }
            else {
                if (user?.displayName != nil) {
                    
                    let signedInUser = User(uid: (user?.uid)!, email: (user?.email!)!, name: (user?.displayName!)!, image: "")
                    
                    print(signedInUser.uid, signedInUser.email, user?.displayName!)
                    
                }
                    
                else {
                    
                    let signedInUser = User(uid: (user?.uid)!, email: (user?.email!)!, name: "", image: "")
                    
                    print(signedInUser.uid, signedInUser.email, "")
                    
                }
            
                print("signed in")
                onComplete?(nil, user)
            }
        })
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        print(error.debugDescription)
        if let errorCode = FIRAuthErrorCode(rawValue: error._code) {
            switch errorCode {
            case .errorCodeInvalidEmail:
                onComplete?("Invalid email address", nil)
                break
            case .errorCodeWrongPassword:
                onComplete?("Invalid password", nil)
                break
            case .errorCodeEmailAlreadyInUse, .errorCodeAccountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil)
                break
            default:
                onComplete?("There was a problem authenticating. Try again.", nil)
            }
        }
    }
    
    func getSignedInUser() -> User {
        if let user = FIRAuth.auth()?.currentUser {
            
            if user.displayName != nil {
                
                let signedInUser = User(uid: user.uid, email: user.email!, name: user.displayName!, image: "")
                
                print(signedInUser.uid, signedInUser.email, user.displayName!)
                
                return signedInUser
                
            }
                
            else {
                
                let signedInUser = User(uid: user.uid, email: user.email!, name: "", image: "")
                
                print(signedInUser.uid, signedInUser.email, "")
                
                return signedInUser

            }
        }
        
        else {
            
            let noUserSignedIn = User(uid: "", email: "", name: "", image: "")
            
            return noUserSignedIn
            
        }
    }
    
    func performSignOut() {
        try! FIRAuth.auth()!.signOut()
        self.app.userDefaults.set(false, forKey: "userLoggedIn")

    }
    
    func passwordReset(email: String) {
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // An error happened.
            } else {
                // Password reset email sent.
            }
        }
    }
    
    func saveDisplay(name: String) {
        
        if let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest() {
            changeRequest.displayName = name
            changeRequest.commitChanges(completion: { (error) in
                print(error?.localizedDescription)
            })
        }
    }
}
