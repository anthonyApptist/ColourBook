//
//  DatabaseVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 2017-10-01.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class DatabaseVC: UIViewController {
    
    

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        AuthService.instance.login(email: "anthony.ma111@gmail.com", password: "123456")
        
        self.view.backgroundColor = UIColor.blue
//        self.moveColoursToPublic()
//        movePaintCansToPublic()
        /*
        removeNodes(name: "addresses")
        removeNodes(name: "businesses")
        removeNodes(name: "colours")
        removeNodes(name: "paintData")
         */
    }
    
    func removeNodes(name: String) {
        DataService.instance.mainRef.child(name).removeValue()
    }
    
    /*
    // functions to move database nodes
    
    // move paint cans
    func movePaintCansToPublic() {
        let barcodesRef = DataService.instance.mainRef.child("barcodes")
        
        var allBarcodes: [PaintCan] = []
        
        barcodesRef.observe(.value, with: { (snapshot) in
            for barcodeObject in snapshot.children.allObjects {
                let barcodeProfile = barcodeObject as! DataSnapshot
                let profileObject = barcodeProfile.value as? NSDictionary
                let profile = profileObject?["profile"] as? NSDictionary
                print(profile)
                
                
                
                // profile variables
                let barcode = barcodeProfile.key
                var category: String? = nil
                var code: String? = nil
                
                print(barcode)
                if let productCategory = profile?["category"] as? String {
                    category = productCategory
                }
                if let productCode = profile?["code"] as? String {
                    code = productCode
                }
                
                let image = profile?["image"] as! String
                let manufacturer = profile?["manufacturer"] as! String
                let name = profile?["productName"] as! String
                let type = profile?["product"] as! String
                
                let paintCan = PaintCan()
                paintCan.category = category
                paintCan.code = code
                paintCan.image = image
                paintCan.manufacturer = manufacturer
                paintCan.name = name
                paintCan.type = type
                
                paintCan.upcCode = barcode
                
                allBarcodes.append(paintCan)
            }
            // save to public ref
            self.saveAllBarcodesToPublic(allBarcodes)
        }) { (error) in
            // error
        }
    }
    
    // save paint cans to public
    func saveAllBarcodesToPublic(_ allBarcodes: [PaintCan]) {
        for paintCan in allBarcodes {
            let barcode = paintCan.upcCode!
            let category = paintCan.category
            let code = paintCan.code
            let image = paintCan.image!
            let manufacturer = paintCan.manufacturer!
            let name = paintCan.name!
            let type = paintCan.type!
            
            var childUpdate: [String:String] = [:]
            if category != nil {
                childUpdate.updateValue(category!, forKey: "category")
            }
            if code != nil {
                childUpdate.updateValue(code!, forKey: "code")
            }
            childUpdate.updateValue(image, forKey: "image")
            childUpdate.updateValue(manufacturer, forKey: "manufacturer")
            childUpdate.updateValue(name, forKey: "name")
            childUpdate.updateValue(type, forKey: "type")
            
            DataService.instance.publicRef.child("barcodes").child(barcode).updateChildValues(childUpdate)
        }
    }
    
    // move colours to public
    func moveColoursToPublic() {
        let coloursRef = DataService.instance.mainRef.child("colours")
        
        var allCompanyColours: [String:[Colour]] = [:]
        
        // all colours and values
        coloursRef.observe(.value, with: { (snapshot) in
            // company
            for colourCompany in snapshot.children.allObjects {
                let companyColours = colourCompany as! DataSnapshot
                var allColours: [Colour] = []
                // all colours in company
                for colour in companyColours.children.allObjects {
                    let colourSnapshot = colour as! DataSnapshot
                    let colourProfile = colourSnapshot.value as? NSDictionary
                    
                    // colour profile variables
                    let colourProductCode = colourSnapshot.key
                    let colourName = colourProfile?["colourName"] as? String
                    let colourHexcode = colourProfile?["hexcode"] as? String
                    let colourManufacturer = colourProfile?["manufacturer"] as? String
                    let colourManufacturerID = colourProfile?["manufacturerID"] as? String
                    
                    // parse colour
                    var aColour = Colour()
                    aColour.name = colourName
                    aColour.hexCode = colourHexcode
                    aColour.manufacturer = colourManufacturer
                    aColour.manufacturerID = colourManufacturerID
                    aColour.productCode = colourProductCode
                    
                    allColours.append(aColour)
                }
                allCompanyColours.updateValue(allColours, forKey: companyColours.key)
            }
            self.saveAllColours(allCompanyColours)
        }) { (error) in
            // error
        }
    }
    
    // save colours
    func saveAllColours(_ allColours: [String:[Colour]]) {
        for company in allColours.keys {
            let companyColours = allColours[company]
            for colour in companyColours! {
                var childUpdate: [String:String] = [:]
                
                let hexcode = colour.hexCode!
                let productCode = colour.productCode!
                let name = colour.name!
                let manufacturer = colour.manufacturer!
                let manufacturerID = colour.manufacturerID!
                
                childUpdate.updateValue(hexcode, forKey: "hexcode")
                childUpdate.updateValue(productCode, forKey: "productCode")
                childUpdate.updateValue(name, forKey: "name")
                childUpdate.updateValue(manufacturer, forKey: "manufacturer")
                childUpdate.updateValue(manufacturerID, forKey: "manufacturerID")
                
                DataService.instance.publicRef.child("colours").child(company).child(productCode).updateChildValues(childUpdate)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
     */
}
