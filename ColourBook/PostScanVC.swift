//
//  AfterScanViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 6/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class PostScanViewController: UIViewController {
    
    var barcode: String = ""
    
    var productImageView: UIImageView!
    
    var manufacturer: UILabel!
    
    var productName: UILabel!
    
    var category: UILabel!
    
    var code: UILabel!
    
    var productTypeLabel: UILabel!
    
    var addColourButton: UIButton!
    
    var addToPersonalButton: UIButton!
    
    var addToBusinessButton: UIButton!
    
    var addToHomeButton: UIButton!
    
    var product: Any?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // MARK: View

        // product type label
        
        let productTypeLabelOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.03)
        
        let productTypeLabelSize = CGSize(width: view.frame.width * 0.6, height: 50)
        
        productTypeLabel = UILabel.init(frame: CGRect(origin: productTypeLabelOrigin, size: productTypeLabelSize))
        
        productTypeLabel.backgroundColor = UIColor.clear
        
        // image view
        
        let imageViewOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.4)/2), y: view.frame.height * 0.08)
        
        let imageViewSize = CGSize(width: view.frame.width * 0.4, height: view.frame.height * 0.4)
        
        productImageView = UIImageView.init(frame: CGRect(origin: imageViewOrigin, size: imageViewSize))
        
        
        // manufacturer label
        
        let manufacturerLabelOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.50)
        
        let manufacturerLabelSize = CGSize(width: view.frame.width * 0.6, height: 50)
        
        manufacturer = UILabel.init(frame: CGRect(origin: manufacturerLabelOrigin, size: manufacturerLabelSize))
        
        manufacturer.backgroundColor = UIColor.clear
    
        // product name label
        
        let nameLabelOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.55)
        
        let nameLabelSize = CGSize(width: view.frame.width * 0.6, height: 50)
        
        productName = UILabel.init(frame: CGRect(origin: nameLabelOrigin, size: nameLabelSize))
        
        productName.backgroundColor = UIColor.clear

        // code label
        
        let codeLabelOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.60)
        
        let codeLabelSize = CGSize(width: view.frame.width * 0.6, height: 50)
        
        code = UILabel.init(frame: CGRect(origin: codeLabelOrigin, size: codeLabelSize))
        
        code.backgroundColor = UIColor.clear
        
        // category label
        
        let categoryLabelOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.65)
        
        let categoryLabelSize = CGSize(width: view.frame.width * 0.6, height: 50)
        
        category = UILabel.init(frame: CGRect(origin: categoryLabelOrigin, size: categoryLabelSize))
        
        category.backgroundColor = UIColor.clear
        
        view.addSubview(productTypeLabel)
        
        view.addSubview(productImageView)
        
        view.addSubview(manufacturer)
        
        view.addSubview(productName)
        
        view.addSubview(code)
        
        view.addSubview(category)
        
        // add to personal list button
        
        let addToPersonalListButtonOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.15)/2) - ((view.frame.width * 0.15)/2) - (view.frame.width * 0.15), y: view.frame.height * 0.85)
        
        let addToPersonalListButtonSize = CGSize(width: view.frame.width * 0.15, height: view.frame.width * 0.15)
        
        addToPersonalButton = UIButton.init(frame: CGRect(origin: addToPersonalListButtonOrigin, size: addToPersonalListButtonSize))
        
        addToPersonalButton.setTitle("P", for: .normal)
        
        addToPersonalButton.setTitleColor(UIColor.black, for: .normal)
        
        addToPersonalButton.layer.borderWidth = 3.0
        
        addToPersonalButton.layer.borderColor = UIColor.black.cgColor
        
        addToPersonalButton.addTarget(self, action: #selector(addToPersonalButtonFunction), for: .touchUpInside)
        
        // add to business list button
        
        let addToBusinessButtonOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.15)/2), y: view.frame.height * 0.85)
        
        let addToBusinessButtonSize = CGSize(width: view.frame.width * 0.15, height: view.frame.width * 0.15)
        
        addToBusinessButton = UIButton.init(frame: CGRect(origin: addToBusinessButtonOrigin, size: addToBusinessButtonSize))
        
        addToBusinessButton.setTitle("B", for: .normal)
        
        addToBusinessButton.setTitleColor(UIColor.black, for: .normal)
        
        addToBusinessButton.layer.borderWidth = 3.0
        
        addToBusinessButton.layer.borderColor = UIColor.black.cgColor
        
        addToBusinessButton.addTarget(self, action: #selector(addToBusinessButtonFunction), for: .touchUpInside)
        
        // add to home list button
        
        let addToHomeButtonOrigin = CGPoint(x: view.center.x + ((view.frame.width * 0.15)/2) + ((view.frame.width * 0.15)/2), y: view.frame.height * 0.85)
        
        let addToHomeButtonSize = CGSize(width: view.frame.width * 0.15, height: view.frame.width * 0.15)
        
        addToHomeButton = UIButton.init(frame: CGRect(origin: addToHomeButtonOrigin, size: addToHomeButtonSize))
        
        addToHomeButton.setTitle("H", for: .normal)
        
        addToHomeButton.setTitleColor(UIColor.black, for: .normal)
        
        addToHomeButton.layer.borderWidth = 3.0
        
        addToHomeButton.layer.borderColor = UIColor.black.cgColor
        
        addToHomeButton.addTarget(self, action: #selector(addToAddressButtonFunction), for: .touchUpInside)
        
        view.addSubview(addToPersonalButton)
        
        view.addSubview(addToBusinessButton)
        
        view.addSubview(addToHomeButton)
        
        // get barcode information
        
        DataService.instance.barcodeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // get barcodes
            
            if (snapshot.hasChild(self.barcode)) {
                
                let barcodeDatabase = snapshot.value as? NSDictionary
                
                let profile = barcodeDatabase?[self.barcode] as? NSDictionary
                
                let paintCanProfile = profile?["profile"] as? NSDictionary
                
                let paint = Paint(manufacturer: paintCanProfile?["manufacturer"] as! String, productName: paintCanProfile?["productName"] as! String, category: paintCanProfile?["category"] as! String, code: paintCanProfile?["code"] as! String, upcCode: self.barcode, image: paintCanProfile?["image"] as! String, colour: paintCanProfile?["colour"] as! String)
                
                self.product = paint
                
                self.productTypeLabel.text = paintCanProfile?["product"] as! String?
                
                self.productTypeLabel.textAlignment = .center
                
                let imageURL = NSURL.init(string: paint.image)
                
                let imageData = NSData.init(contentsOf: imageURL as! URL)
                
                let image = UIImage.init(data: imageData as! Data)
                
                self.productImageView.image = image
                
                self.productImageView.contentMode = .scaleAspectFill
                
                self.manufacturer.text = paint.manufacturer
                
                self.manufacturer.textAlignment = .center
                
                self.manufacturer.textColor = UIColor.black
                
                self.productName.text = paint.productName
                
                self.productName.adjustsFontSizeToFitWidth = true
                
                self.productName.textColor = UIColor.black
                
                self.code.text = paint.code
                
                self.code.textColor = UIColor.black
                
                self.category.text = paint.category
                
                self.category.textColor = UIColor.black
                
                self.checkProductType()
                
            }
            
            else {
                
                let alertView = UIAlertController.init(title: "Barcode not in database", message: "", preferredStyle: .alert)
                
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertView.addAction(alertAction)
                
                self.present(alertView, animated: true, completion: nil)
                
            }
            
        })
        
    }
    
    func checkProductType() {
        
        if productTypeLabel.text == "Paint" {
            
            let addColourButtonOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.75)
            
            let addColourButtonSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.08)
            
            let addColourButton = UIButton.init(frame: CGRect(origin: addColourButtonOrigin, size: addColourButtonSize))
            
            addColourButton.setTitle("Add colour", for: .normal)
            
            addColourButton.setTitleColor(UIColor.black, for: .normal)
            
            addColourButton.layer.borderWidth = 3.0
            
            addColourButton.layer.borderColor = UIColor.black.cgColor
            
            view.addSubview(addColourButton)
        }
        
        else {
            
        }
        
    }
    
    func addToPersonalButtonFunction() {
        
        let signedInUser = AuthService.instance.getSignedInUser()
        
        let signedInUserUID = signedInUser.uid
        
        let paint = self.product as! Paint
        
        let paintProfile: Dictionary<String, AnyObject> = ["manufacturer": paint.manufacturer as AnyObject, "productName": paint.productName as AnyObject, "category": paint.category as AnyObject, "code": paint.code as AnyObject, "image": paint.image as AnyObject, "product": "Paint" as AnyObject]
        
        DataService.instance.usersRef.child(signedInUserUID).child("personalDashboard").child("barcodes").child(self.barcode).setValue(paintProfile)
        
        
    }
    
    func addToBusinessButtonFunction() {
        
        let signedInUser = AuthService.instance.getSignedInUser()
        
        let signedInUserUID = signedInUser.uid
        
        let paint = self.product as! Paint
        
        let paintCanProfile: Dictionary<String, AnyObject> = ["manufacturer": paint.manufacturer as AnyObject, "productName": paint.productName as AnyObject, "category": paint.category as AnyObject, "code": paint.code as AnyObject, "image": paint.image as AnyObject, "product": "Paint" as AnyObject]
        
        
        DataService.instance.usersRef.child(signedInUserUID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild("businessDashboard") {
                
                DataService.instance.usersRef.child(signedInUserUID).child("businessDashboard").child("barcodes").child(self.barcode).child("profile").setValue(paintCanProfile)
                
                return
            }
            
            else {
                let alertView = UIAlertController(title: "No Business Listings", message: "Go to you business bucket list and add an address", preferredStyle: .alert)
                
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertView.addAction(alertAction)
                
                self.present(alertView, animated: true, completion: { (error) in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
            
            }
            
        })
        
        
    }
    
    func addToAddressButtonFunction() {
        
        let selectView = SelectAddressVC()
        
        selectView.state = "homes"
        
        selectView.barcode = self.barcode
        
        selectView.productProfile = self.product as! Paint
        
        self.present(selectView, animated: true, completion: { (error) in
            
//            currentVC.dismiss(animated: true, completion: nil)
        
        })
        /*
        let signedInUser = AuthService.instance.getSignedInUser()
        
        let signedInUserUID = signedInUser.uid
        
        let paintCan = self.product as! Paint
        
        let paintCanProfile: Dictionary<String, AnyObject> = ["manufacturer": paintCan.manufacturer as AnyObject, "productName": paintCan.productName as AnyObject, "category": paintCan.category as AnyObject, "code": paintCan.code as AnyObject, "image": paintCan.image as AnyObject, "product": "Paint" as AnyObject]
        
        DataService.instance.usersRef.child(signedInUserUID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild("addressDashboard") {
                
                DataService.instance.usersRef.child(signedInUserUID).child("addressDashboard").child(self.barcode).setValue(paintCanProfile)
                
                return
            }
                
            else {
                let alertView = UIAlertController(title: "No address added", message: "Go to you address bucket list and add an address", preferredStyle: .alert)
                
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertView.addAction(alertAction)
                
                self.present(alertView, animated: true, completion: nil)
            }
            
        })
 */
        
    }

}
