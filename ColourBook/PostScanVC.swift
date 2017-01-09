//
//  AfterScanViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 6/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class PostScanViewController: CustomVC {
    
    var barcode: String = "0023906001698"
    
    var productImageView: UIImageView!
    var manufacturer: UILabel!
    var productName: UILabel!
    var category: UILabel!
    var code: UILabel!
    var productTypeLabel: UILabel!
    
    // buttons
    var addColourButton: UIButton!
    var addToPersonalButton: UIButton!
    var addToBusinessButton: UIButton!
    var addToHomeButton: UIButton!
    
    var product: Any?
    var hexcode: String?
    
    var colourView: ChooseColourVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButtonNeeded = false
        
        view.backgroundColor = UIColor.white
        
        // MARK: View

        // product type label
        
        let productTypeLabelOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.03)
        let productTypeLabelSize = CGSize(width: view.frame.width * 0.6, height: 50)
        productTypeLabel = UILabel(frame: CGRect(origin: productTypeLabelOrigin, size: productTypeLabelSize))
        productTypeLabel.backgroundColor = UIColor.clear
        
        // image view
        
        let imageViewOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.4)/2), y: view.frame.height * 0.08)
        let imageViewSize = CGSize(width: view.frame.width * 0.4, height: view.frame.height * 0.4)
        productImageView = UIImageView(frame: CGRect(origin: imageViewOrigin, size: imageViewSize))
        
        
        // manufacturer label
        
        let manufacturerLabelOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.50)
        let manufacturerLabelSize = CGSize(width: view.frame.width * 0.6, height: 50)
        manufacturer = UILabel(frame: CGRect(origin: manufacturerLabelOrigin, size: manufacturerLabelSize))
        manufacturer.backgroundColor = UIColor.clear
    
        // product name label
        
        let nameLabelOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.55)
        let nameLabelSize = CGSize(width: view.frame.width * 0.6, height: 50)
        productName = UILabel(frame: CGRect(origin: nameLabelOrigin, size: nameLabelSize))
        productName.backgroundColor = UIColor.clear

        // code label
        
        let codeLabelOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.60)
        let codeLabelSize = CGSize(width: view.frame.width * 0.6, height: 50)
        code = UILabel(frame: CGRect(origin: codeLabelOrigin, size: codeLabelSize))
        code.backgroundColor = UIColor.clear
        
        // category label
        
        let categoryLabelOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.65)
        let categoryLabelSize = CGSize(width: view.frame.width * 0.6, height: 50)
        category = UILabel.init(frame: CGRect(origin: categoryLabelOrigin, size: categoryLabelSize))
        category.backgroundColor = UIColor.clear
        
        // add to view
        
        view.addSubview(productTypeLabel)
        view.addSubview(productImageView)
        view.addSubview(manufacturer)
        view.addSubview(productName)
        view.addSubview(code)
        view.addSubview(category)
        
        // MARK: - Buttons
        
        // add to personal list button
        
        addToPersonalButton = UIButton(type: .system)
        
        let addToPersonalListButtonOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.15)/2) - ((view.frame.width * 0.15)/2) - (view.frame.width * 0.15), y: view.frame.height * 0.85)
        
        let addToPersonalListButtonSize = CGSize(width: view.frame.width * 0.15, height: view.frame.width * 0.15)
        
        addToPersonalButton.frame = CGRect(origin: addToPersonalListButtonOrigin, size: addToPersonalListButtonSize)
        
        addToPersonalButton.setTitle("P", for: .normal)
        addToPersonalButton.setTitleColor(UIColor.black, for: .normal)
        
        addToPersonalButton.addTarget(self, action: #selector(addToPersonalButtonFunction), for: .touchUpInside)
        
        // add to business list button
        
        addToBusinessButton = UIButton(type: .system)
        
        let addToBusinessButtonOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.15)/2), y: view.frame.height * 0.85)
        
        let addToBusinessButtonSize = CGSize(width: view.frame.width * 0.15, height: view.frame.width * 0.15)
        
        addToBusinessButton.frame = CGRect(origin: addToBusinessButtonOrigin, size: addToBusinessButtonSize)
        addToBusinessButton.setTitle("B", for: .normal)
        addToBusinessButton.setTitleColor(UIColor.black, for: .normal)
        addToBusinessButton.addTarget(self, action: #selector(addToBusinessButtonFunction), for: .touchUpInside)
        
        // add to home list button
        
        addToHomeButton = UIButton(type: .system)
        let addToHomeButtonOrigin = CGPoint(x: view.center.x + ((view.frame.width * 0.15)/2) + ((view.frame.width * 0.15)/2), y: view.frame.height * 0.85)
        let addToHomeButtonSize = CGSize(width: view.frame.width * 0.15, height: view.frame.width * 0.15)
        addToHomeButton.frame = CGRect(origin: addToHomeButtonOrigin, size: addToHomeButtonSize)
        addToHomeButton.setTitle("H", for: .normal)
        addToHomeButton.setTitleColor(UIColor.black, for: .normal)
        addToHomeButton.addTarget(self, action: #selector(addToAddressButtonFunction), for: .touchUpInside)
        
        // add colour button
        
        addColourButton = UIButton(type: .system)
        
        let addColourButtonOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.75)
        let addColourButtonSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.08)
        addColourButton.frame = CGRect(origin: addColourButtonOrigin, size: addColourButtonSize)
        addColourButton.setTitle("Add colour", for: .normal)
        addColourButton.setTitleColor(UIColor.black, for: .normal)
        addColourButton.addTarget(self, action: #selector(addColourFunction), for: .touchUpInside)
        addColourButton.layer.borderWidth = 3.0
        
        addColourButton.layer.borderColor = UIColor.black.cgColor
        
        view.addSubview(addColourButton)
        
        addColourButton.alpha = 0.0
        
        view.addSubview(addToPersonalButton)
        view.addSubview(addToBusinessButton)
        view.addSubview(addToHomeButton)
        
        lookup(barcode: self.barcode)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let colourView = self.colourView {
            
            // check if choose colour view is being dismissed
            if colourView.isBeingDismissed {
                self.product = colourView.paint
                self.hexcode = colourView.paint?.colour
                if self.hexcode == "" {
                    
                }
                else {
                    self.check(product: "Paint")
                    self.addColourButton.setTitle("", for: .normal)
                    self.addColourButton.backgroundColor = UIColor(hexString: self.hexcode!)
                }
            }
        }
    }
    
    func addToPersonalButtonFunction() {
        
        self.screenState = .personal
        
        let paint = self.product as? Paint
        
        let paintProfile: Dictionary<String, String> = ["manufacturer": paint!.manufacturer, "productName": paint!.productName, "category": paint!.category, "code": paint!.code, "image": paint!.image, "product": "Paint", "colour": paint!.colour]
        
        DataService.instance.saveProductFor(user: self.signedInUser.uid, screenState: self.screenState, location: "", barcode: self.barcode, value: paintProfile)
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
        
    }
    
    func addToBusinessButtonFunction() {
        
        let selectView = SelectAddressVC()
        selectView.screenState = .business
        selectView.barcode = self.barcode
        selectView.productProfile = self.product as? Paint
        self.present(selectView, animated: true, completion: { (error) in
            
        })

        
        
    }
    
    func addToAddressButtonFunction() {
        
        let selectView = SelectAddressVC()
        selectView.screenState = .homes
        selectView.barcode = self.barcode
        selectView.productProfile = self.product as? Paint
        self.present(selectView, animated: true, completion: { (error) in
            
        })
        
    }
    
    func lookup(barcode: String) {
        
        // get barcode information
        
        DataService.instance.barcodeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // get barcodes
            
            if (snapshot.hasChild(self.barcode)) {
                
                // barcode database
                
                let barcodeDatabase = snapshot.value as? NSDictionary
                let profile = barcodeDatabase?[self.barcode] as? NSDictionary
                let paintCanProfile = profile?["profile"] as? NSDictionary
                
                let paint = Paint(manufacturer: paintCanProfile?["manufacturer"] as! String, productName: paintCanProfile?["productName"] as! String, category: paintCanProfile?["category"] as! String, code: paintCanProfile?["code"] as! String, upcCode: self.barcode, image: paintCanProfile?["image"] as! String, colour: paintCanProfile?["colour"] as! String)

                self.product = paint
                
                // get product type
                
                self.productTypeLabel.text = paintCanProfile?["product"] as! String?
                self.productTypeLabel.textAlignment = .center
                
                // product image
                
                let image = self.showProductImage(url: paint.image)
                self.productImageView.image = image
                self.productImageView.contentMode = .scaleAspectFill
                
                // manufacturer text
                
                self.manufacturer.text = paint.manufacturer
                self.manufacturer.textAlignment = .center
                self.manufacturer.textColor = UIColor.black
                
                // product name
                
                self.productName.text = paint.productName
                self.productName.adjustsFontSizeToFitWidth = true
                self.productName.textColor = UIColor.black
                
                // product code
                
                self.code.text = paint.code
                self.code.textColor = UIColor.black
                
                // product category
                
                self.category.text = paint.category
                self.category.textColor = UIColor.black
                
                // check product type
                
                self.check(product: self.productTypeLabel.text!)
                
            }
                
            else {
                
                let alertView = UIAlertController.init(title: "Barcode not in database", message: "", preferredStyle: .alert)
                
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertView.addAction(alertAction)
                
                self.present(alertView, animated: true, completion: nil)
                
            }
            
        })
        
    }
    
    // check if paint can
    
    func check(product: String) {
        
        if product == "Paint" {
            
            UIView.animate(withDuration: 1.0, animations: {
                self.addColourButton.alpha = 1.0
            })

        }
            
        else {
            
        }
        
    }

    
    // add to colour function
    
    func addColourFunction() {
        self.colourView = ChooseColourVC()
        self.colourView?.paint = self.product as? Paint
        self.present(self.colourView!, animated: true, completion: nil)
    }
    
    // show product image
    
    func showProductImage(url: String?) -> UIImage {
        
        if let urlString = url {
            let imageURL = NSURL(string: urlString)
            let imageData = NSData(contentsOf: imageURL as! URL)
            let image = UIImage(data: imageData as! Data)
            return image!
        }
        else {
            let image = UIImage(contentsOfFile: "darkgreen.jpg")
            return image!
        }
        
        
    }

}
