//
//  StorageService.swift
//  ColourBook
//
//  Created by Anthony Ma on 2017-10-03.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService: DataBase {
    // public instance
    private static let _instance = StorageService()
    
    static var instance: StorageService {
        return _instance
    }
    
    // MARK: - Store Personal Image
    func storePersonalImage(name: String, imageData: Data) {
        let userUID = standardUserDefaults.value(forKey: "uid") as! String
        let uniqueID = self.createUniqueID()
        // store in firebase storage
        self.mainStorageRef.child("personalImages").child(uniqueID).putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                // handle error
            }
            else {
                let storageRef = metadata?.downloadURL()?.absoluteString
                
                let personalUpdate: [String:String] = ["image":storageRef!, "name":name]
                
                // store in database
                DataService.instance.usersRef.child(userUID).updateChildValues(personalUpdate)
            }
        }
    }
    
    // MARK: - Store Address Image
    func storeAddressImage(imageData: Data, location: String, name: String) {
        let homeID = standardUserDefaults.value(forKey: "home") as! String
        let uniqueID = self.createUniqueID()
        // store in firebase storage
        self.mainStorageRef.child("addressImages").child(uniqueID).putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                // handle error
            }
            else {
                let storageRef = metadata?.downloadURL()?.absoluteString
                
                let imageUpdate: [String:String] = ["image":storageRef!, "name":name]
                
                // store in database
                DataService.instance.homeDashboardRef.child(homeID).child(location).updateChildValues(imageUpdate)
            }
        }
    }
    
    // MARK: - Store Business Image
    func storeBusinessImage(imageData: String, location: String) {
        let data = Data(base64Encoded: imageData)
        let uniqueID = self.createUniqueID()
        // store in firebase storage
        self.mainStorageRef.child("businessImages").child(uniqueID).putData(data!, metadata: nil) { (metadata, error) in
            if let error = error {
                // handle error
            }
            else {
                let storageRef = metadata?.downloadURL()?.absoluteString
                
                let imageUpdate: [String:String] = ["image":storageRef!]
                
                // store in database
                DataService.instance.businessRef.child(location).updateChildValues(imageUpdate)
            }
        }
    }
}
