//
//  DataService.swift
//  ColourBook
//
//  Created by Anthony Ma on 27/11/2016.
//  Copyright © 2016 Anthony Ma. All rights reserved.
//

import Foundation
import FirebaseDatabase


class DataService {
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    //MARK: Database
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    // users reference
    var usersRef: FIRDatabaseReference {
        return mainRef.child("users")
    }
    
    // address reference
    var addressRef: FIRDatabaseReference {
        return mainRef.child("addresses")
    }
    
    // business reference
    var businessRef: FIRDatabaseReference {
        return mainRef.child("businesses")
    }
    
    // barcode reference
    var barcodeRef: FIRDatabaseReference {
        return mainRef.child("barcodes")
    }
    
    // paint data reference
    var paintDataRef: FIRDatabaseReference {
        return mainRef.child("paintData")
    }
    
    func saveRegisterUser(uid: String, email: String, name: String) {
        let profile: Dictionary<String, AnyObject> = ["email": email as AnyObject, "name": name as AnyObject]
    }
    
    func savePaintData(manufacturerID: String, productCode: String, colourName: String, colourHexCode: String) {
        
        let paintProfile: Dictionary<String, AnyObject> = ["manufacturerID" : manufacturerID as AnyObject, "colourName" : colourName as AnyObject, "productCode": productCode as AnyObject]
        
        let hexCode = colourHexCode
        
        paintDataRef.child(hexCode).setValue(paintProfile)
    }
    
    func savePaintCanData(manufacturer: String, productName: String, category: String, code: String, upcCode: String, image: String, colour: String) {
        
        let paintCanProfile: Dictionary<String, AnyObject> = ["manufacturer": manufacturer as AnyObject, "productName": productName as AnyObject, "category": category as AnyObject, "code": code as AnyObject, "image": image as AnyObject, "colour": "" as AnyObject, "product": "Paint" as AnyObject]
        
        barcodeRef.child(upcCode).child("profile").setValue(paintCanProfile)
        
    }
    
    func createNewUser(uid: String, email: String) {
        
        let dashboards: Dictionary<String, AnyObject> = ["addressDashboard": "" as AnyObject, "businessDashboard": "" as AnyObject, "personalDashboard": "" as AnyObject]
        
        usersRef.child(uid).setValue(dashboards)
        
    }
    
    func addItem(screenState: ScreenState, item: Any) {
        
    }
    
    func editItem(screenState: ScreenState, item: Any) {
        
    }
    
    func getUserItems(screenState: ScreenState, uid: String, user: User) {
        
        var itemsArray: [Paint] = []
        
        if screenState == .personal {
            let personalItemsRef = usersRef.child(uid).child("personalDashboard")
            
            personalItemsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                var paintArray: [Paint] = []
                
                for child in snapshot.children.allObjects {
                    
                    let product = child as? FIRDataSnapshot
                    
                    let productProfile = product?.value as? NSDictionary
                    
                    let category = productProfile?["category"] as? String ?? ""
                    
                    let productName = productProfile?["productName"] as? String ?? ""
                    
                    let code = productProfile?["code"] as? String ?? ""
                    
                    let image = productProfile?["image"] as? String ?? ""
                    
                    let upcCode = productProfile?["upcCode"] as? String ?? ""

                    let manufacturer = productProfile?["manufacturer"] as? String ?? ""
                    
                    let colour = productProfile?["colour"] as? String ?? ""
                    
                    let paint = Paint(manufacturer: manufacturer, productName: productName, category: category, code: code, upcCode: upcCode, image: image, colour: colour)
                    
                    paintArray.append(paint)
                }
                
              itemsArray.append(contentsOf: paintArray)
            
              user.items = itemsArray
                
                
                
            })
            
        }
        
        else {
            user.items = []
        }
        
    }
    
}
