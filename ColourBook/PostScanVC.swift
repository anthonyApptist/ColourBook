//
//  AfterScanViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 6/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

protocol ColourAdded {
    func setLabelFor(colour: String)
    func set(colour: Colour)
}

class PostScanViewController: CustomVC {
    
    var barcode: String!
    
    var productTypeLabel: UILabel!
    var productImageView: UIImageView!

    var productInfo: UIView!
    
    // buttons
    var addColourButton: UIButton!
    var addToPersonalButton: UIButton!
    var addToBusinessButton: UIButton!
    var addToHomeButton: UIButton!
    
    // scanned product
    var product: Any?
    
    var colour: Colour?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButtonNeeded = true
        
        self.showActivityIndicator()
        
        view.backgroundColor = UIColor.white
        
        // MARK: - Buttons
        
        // add to personal list button
        
        addToPersonalButton = UIButton(type: .system)
        let addToPersonalListButtonOrigin = CGPoint(x: 0, y: view.frame.maxY - (view.frame.height * 0.1))
        let addToPersonalListButtonSize = CGSize(width: view.frame.width / 3, height: view.frame.height * 0.1)
        addToPersonalButton.frame = CGRect(origin: addToPersonalListButtonOrigin, size: addToPersonalListButtonSize)
        addToPersonalButton.setTitle("P", for: .normal)
        addToPersonalButton.setTitleColor(UIColor.white, for: .normal)
        addToPersonalButton.backgroundColor = UIColor.black
        addToPersonalButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: addToPersonalButton.frame.height * 0.4)
        addToPersonalButton.addTarget(self, action: #selector(addToPersonalButtonFunction), for: .touchUpInside)
        
        // add to business list button
        
        addToBusinessButton = UIButton(type: .system)
        let addToBusinessButtonOrigin = CGPoint(x: addToPersonalButton.frame.maxX, y: view.frame.maxY - (view.frame.height * 0.1))
        let addToBusinessButtonSize = CGSize(width: view.frame.width / 3, height: view.frame.height * 0.1)
        addToBusinessButton.frame = CGRect(origin: addToBusinessButtonOrigin, size: addToBusinessButtonSize)
        addToBusinessButton.setTitle("B", for: .normal)
        addToBusinessButton.setTitleColor(UIColor.white, for: .normal)
        addToBusinessButton.backgroundColor = UIColor.black
        addToBusinessButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: addToBusinessButton.frame.height * 0.4)
        addToBusinessButton.addTarget(self, action: #selector(addToBusinessButtonFunction), for: .touchUpInside)
        
        // add to home list button
        
        addToHomeButton = UIButton(type: .system)
        let addToHomeButtonOrigin = CGPoint(x: addToBusinessButton.frame.maxX, y: view.frame.maxY - (view.frame.height * 0.1))
        let addToHomeButtonSize = CGSize(width: view.frame.width / 3, height: view.frame.height * 0.1)
        addToHomeButton.frame = CGRect(origin: addToHomeButtonOrigin, size: addToHomeButtonSize)
        addToHomeButton.setTitle("H", for: .normal)
        addToHomeButton.setTitleColor(UIColor.white, for: .normal)
        addToHomeButton.backgroundColor = UIColor.black
        addToHomeButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: addToHomeButton.frame.height * 0.4)
        addToHomeButton.addTarget(self, action: #selector(addToAddressButtonFunction), for: .touchUpInside)
        
        // add colour button
        
        addColourButton = UIButton(type: .system)
        let addColourButtonOrigin = CGPoint(x: 0, y: addToPersonalButton.frame.minY - view.frame.height * 0.1)
        let addColourButtonSize = CGSize(width: view.frame.width, height: view.frame.height * 0.1)
        addColourButton.frame = CGRect(origin: addColourButtonOrigin, size: addColourButtonSize)
        addColourButton.setTitle("Add colour", for: .normal)
        addColourButton.setTitleColor(UIColor.white, for: .normal)
        addColourButton.addTarget(self, action: #selector(addColourFunction), for: .touchUpInside)
        addColourButton.layer.borderWidth = 3.0
        addColourButton.layer.borderColor = UIColor.clear.cgColor
        addColourButton.backgroundColor = UIColor.black
        addColourButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: addColourButton.frame.height * 0.4)
        addColourButton.alpha = 0.0
        
        // MARK: View

        // product type label
        
        let productTypeLabelOrigin = CGPoint(x: 0, y: 60)
        let productTypeLabelSize = CGSize(width: view.frame.width, height: view.frame.height * 0.1)
        productTypeLabel = UILabel(frame: CGRect(origin: productTypeLabelOrigin, size: productTypeLabelSize))
        productTypeLabel.backgroundColor = UIColor.black
        productTypeLabel.textColor = UIColor.white
        productTypeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: productTypeLabel.frame.height * 0.4)
        
        // image view
        
        let imageViewOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.5)/2), y: productTypeLabel.frame.maxY)
        let imageViewSize = CGSize(width: view.frame.width * 0.5, height: view.frame.width * 0.5)
        productImageView = UIImageView(frame: CGRect(origin: imageViewOrigin, size: imageViewSize))

        
        // add to view
        
        view.addSubview(productTypeLabel)
        view.addSubview(productImageView)
        
        view.addSubview(addColourButton)
        view.addSubview(addToPersonalButton)
        view.addSubview(addToBusinessButton)
        view.addSubview(addToHomeButton)
        
        lookup(barcode: self.barcode)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.check(product: "Paint")
    }
    
    // MARK: - Save to Lists
    
    // personal
    
    func addToPersonalButtonFunction() {
        
        // set to personal save
        self.screenState = .personal
        
        let paint = self.product as? Paint
        
        if let colour = self.colour {
            let timestamp = createTimestamp()
            
            let colourProfile: Dictionary<String, String> = ["productCode": colour.productCode, "colourName": colour.colourName, "manufacturer": colour.manufacturer, "manufacturerID": colour.manufacturerID, "hexcode": colour.colourHexCode]
            let paintProfile: Dictionary<String, Any> = ["manufacturer": paint!.manufacturer, "productName": paint!.productName, "category": paint!.category, "code": paint!.code, "image": paint!.image, "product": "Paint", "colour": colourProfile, "timestamp": timestamp]
            DataService.instance.saveProductFor(user: self.signedInUser.uid, screenState: self.screenState, location: "", barcode: self.barcode, value:paintProfile)
        }
        else {
            let timestamp = createTimestamp()
            
            let paintProfile: Dictionary<String, String> = ["manufacturer": paint!.manufacturer, "productName": paint!.productName, "category": paint!.category, "code": paint!.code, "image": paint!.image, "product": "Paint", "timestamp": timestamp]
            DataService.instance.saveProductFor(user: self.signedInUser.uid, screenState: self.screenState, location: "", barcode: self.barcode, value: paintProfile)
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // business
    
    func addToBusinessButtonFunction() {
        let selectView = SelectAddressVC()
        selectView.screenState = .business
        
        let paint = self.product as? Paint
        
        if let colour = self.colour {
            let timestamp = createTimestamp()
            
            // colour profile
            let colourProfile: Dictionary<String, String> = ["productCode": colour.productCode, "colourName": colour.colourName, "manufacturer": colour.manufacturer, "manufacturerID": colour.manufacturerID, "hexcode": colour.colourHexCode]
            
            // paint profile
            let paintProfile: Dictionary<String, Any> = ["manufacturer": paint!.manufacturer, "productName": paint!.productName, "category": paint!.category, "code": paint!.code, "image": paint!.image, "product": "Paint", "colour": colourProfile, "timestamp": timestamp]
            
            selectView.productProfile = paintProfile
        }
        else {
            let timestamp = createTimestamp()
            
            let paintProfile: Dictionary<String, String> = ["manufacturer": paint!.manufacturer, "productName": paint!.productName, "category": paint!.category, "code": paint!.code, "image": paint!.image, "product": "Paint", "timestamp": timestamp]

            selectView.productProfile = paintProfile
        }
        
        selectView.barcode = self.barcode
        
        self.present(selectView, animated: true, completion: { (error) in
            
        })
        
    }
    
    // homes
    
    func addToAddressButtonFunction() {
        let selectView = SelectAddressVC()
        selectView.screenState = .homes
        
        let paint = self.product as? Paint
        
        if let colour = self.colour {
            let timestamp = createTimestamp()
            
            // colour profile
            let colourProfile: Dictionary<String, String> = ["productCode": colour.productCode, "colourName": colour.colourName, "manufacturer": colour.manufacturer, "manufacturerID": colour.manufacturerID, "hexcode": colour.colourHexCode]
            
            // paint profile
            let paintProfile: Dictionary<String, Any> = ["manufacturer": paint!.manufacturer, "productName": paint!.productName, "category": paint!.category, "code": paint!.code, "image": paint!.image, "product": "Paint", "colour": colourProfile, "timestamp": timestamp]
            
            selectView.productProfile = paintProfile
        }
        else {
            let timestamp = createTimestamp()
            
            let paintProfile: Dictionary<String, String> = ["manufacturer": paint!.manufacturer, "productName": paint!.productName, "category": paint!.category, "code": paint!.code, "image": paint!.image, "product": "Paint", "timestamp": timestamp]
            
            selectView.productProfile = paintProfile
        }
        
        selectView.barcode = self.barcode
        
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
                
                self.productInfo = UIView(frame: CGRect(x: 0, y: self.productImageView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - 60 - (self.view.frame.width * 0.5) - (self.view.frame.height * 0.1) - (self.view.frame.width * 0.1) - (self.view.frame.height * 0.1)))
                
                self.view.addSubview(self.productInfo)
                
                let productView = ProductInfoView(frame: self.productInfo.bounds)
                
                self.productInfo.addSubview(productView)
                
                // manufacturer text
                
                productView.manufacturer.text = paint.manufacturer
                productView.manufacturer.textAlignment = .center
                productView.manufacturer.textColor = UIColor.black
                
                // product name
                
                productView.productName.text = paint.productName
                productView.productName.adjustsFontSizeToFitWidth = true
                productView.productName.textColor = UIColor.black
                
                // product code
                
                productView.code.text = paint.code
                productView.code.textColor = UIColor.black
                
                // product category
                
                productView.category.text = paint.category
                productView.category.textColor = UIColor.black
                
                // check product type
                
                self.check(product: self.productTypeLabel.text!)
                
                self.hideActivityIndicator()
            }
            else {
                
                let alertView = UIAlertController.init(title: "Barcode not in database", message: "", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertView.addAction(alertAction)
                
                self.hideActivityIndicator()

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

    // add colour function
    
    func addColourFunction() {
        let colourView = ChooseColourVC()
        // set colour added to paint delegate
        colourView.colourAddedDelegate = self
        self.present(colourView, animated: true, completion: nil)
    }
    
    // show product image
    
    func showProductImage(url: String?) -> UIImage {
        if url == "N/A" {
            let image = UIImage(named: "darkgreen.jpg")
            return image!
        }
        else {
            let imageURL = NSURL(string: url!)
            let imageData = NSData(contentsOf: imageURL as! URL)
            let image = UIImage(data: imageData as! Data)
            return image!
        }
    }
    
    func createTimestamp() -> String {
        // time
        let date = Date()
        let dateFormatter = DateFormatter()
        // date
        dateFormatter.dateStyle = .medium
        let convertedDate = dateFormatter.string(from: date)
        print(convertedDate)
        // time
        dateFormatter.dateFormat = "HH:mm"
        let convertedTime = dateFormatter.string(from: date)
        print(convertedTime)

        return "\(convertedDate) \(convertedTime)"
    }
}

extension PostScanViewController: ColourAdded {
    func setLabelFor(colour: String) {
        self.addColourButton.setTitle("", for: .normal)
        self.addColourButton.backgroundColor = UIColor(hexString: colour)
    }
    func set(colour: Colour) {
        self.colour = colour
    }

}
