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
    
    // barcode
    var barcode: String!
    
    // view
    var productTypeLabel: UILabel!
    var productImageView: UIImageView!

    // product detail labels view
    var productInfo: UIView!
    
    // buttons
    var addColourButton: UIButton!
    var addToPersonalButton: UIButton!
    var addToBusinessButton: UIButton!
    var addToHomeButton: UIButton!
    
    // scanned product
    var product: ScannedProduct?
    
    // colour for paint
    var colour: Colour?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButtonNeeded = true
        
        self.showActivityIndicator()
        
        view.backgroundColor = UIColor.white
        
        self.apiLookUp()
        
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
        addColourButton.isUserInteractionEnabled = false
        
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
        
    }
    
    // MARK: - Save to Lists
    
    // Personal Dashboard
    
    func addToPersonalButtonFunction() {
        self.screenState = .personal

        let product = self.product
        
        if let colour = self.colour {
            product?.colour = colour
        }
        let timestamp = createTimestamp()
        product?.timestamp = timestamp
        
        let selectCategoryVC = SelectCategoryVC()
        selectCategoryVC.productProfile = product
        selectCategoryVC.screenState = self.screenState
        
        self.present(selectCategoryVC, animated: true, completion: nil)
    }
    
    // business (should check whether user branch BusinessDashboard has (Business Profile) child and then check if there are address else display alert
    
    func addToBusinessButtonFunction() {
        let selectView = SelectAddressVC()
        selectView.screenState = .business

        let product = self.product
        
        if let colour = self.colour {
            product?.colour = colour
        }
        
        let timestamp = createTimestamp()
        product?.timestamp = timestamp
        
        selectView.productProfile = product
        
        self.present(selectView, animated: true, completion: nil)
        
    }
    
    // MARK: - Homes
    
    func addToAddressButtonFunction() {
        let selectView = SelectAddressVC()
        selectView.screenState = .homes
        
        let product = self.product
        
        if let colour = self.colour {
            product?.colour = colour
        }
        
        let timestamp = createTimestamp()
        product?.timestamp = timestamp
        
        selectView.productProfile = product
        
        self.present(selectView, animated: true, completion: nil)
    }
    
    // MARK: - Look up
    func lookup(barcode: String) {
        DataService.instance.barcodeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // get barcodes
            if (snapshot.hasChild(self.barcode)) {
                
                // barcode database
                let barcodeDatabase = snapshot.value as? NSDictionary
                let profile = barcodeDatabase?[self.barcode] as? NSDictionary
                let itemProfile = profile?["profile"] as? NSDictionary
                
                // get scanned product
                let productType = itemProfile?["product"] as! String
                let productName = itemProfile?["productName"] as! String
                let manufacturer = itemProfile?["manufacturer"] as! String
                let image = itemProfile?["image"] as! String
                
                let upcCode = self.barcode
                
                let product = ScannedProduct(productType: productType, productName: productName, manufacturer: manufacturer, upcCode: upcCode!, image: image)
                
                if let code = itemProfile?["code"] {
                    product.code = code as? String
                }
                if let category = itemProfile?["category"] {
                    product.category = category as? String
                }
                
                // get product type
                self.productTypeLabel.textAlignment = .center
                
                // product image
                self.productImageView.image = self.showProductImage(url: image)
                self.productImageView.contentMode = .scaleAspectFit
                
                self.productInfo = UIView(frame: CGRect(x: 0, y: self.productImageView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - self.productImageView.frame.height - (3 * (self.view.frame.height * 0.10)) - 60))
                
                self.view.addSubview(self.productInfo)
                
                let productView = ProductInfoView(frame: self.productInfo.bounds)
                self.productInfo.addSubview(productView)
                
                productView.productLabel.text = "\(manufacturer)\n\(productName)"
                
                if product.manufacturer == "Benjamin Moore" {
                    productView.brandImgView.image = UIImage(named: "BenjaminMoorePhoto.jpg")
                }
                if product.manufacturer == "Coronado" {
                    productView.brandImgView.image = UIImage(named: "CoronadoLogo")
                }
                if product.manufacturer == "Lenmar" {
                    productView.brandImgView.image = UIImage(named: "logo_lenmar")
                }
                if product.manufacturer == "Insulx" {
                    productView.brandImgView.image = UIImage(named: "logo_insulx")
                }
                if product.manufacturer == "CorTech" {
                    productView.brandImgView.image = UIImage(named: "logo_CorTech")
                }
                if product.manufacturer == "Rust-Oleum" {
                    productView.brandImgView.image = UIImage(named: "Rustoleum")
                }
                if product.manufacturer == "Tremclad" {
                    productView.brandImgView.image = UIImage(named: "Tremclad")
                }

                
                self.product = product
                
                /*
                 // manufacturer text
                 
                 productView.manufacturer.text = manufacturer
                 productView.manufacturer.textAlignment = .center
                 productView.manufacturer.textColor = UIColor.black
                 
                 // product name
                 
                 productView.productName.text = productName
                 productView.productName.textAlignment = .center
                 productView.productName.adjustsFontSizeToFitWidth = true
                 productView.productName.textColor = UIColor.black
                 
                // product code
                
                productView.code.text = paint.code
                productView.code.textColor = UIColor.black
                
                // product category
                
                productView.category.text = paint.category
                productView.category.textColor = UIColor.black
                */
                
                // check product type
                
                self.check(product: product)
                
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
    
    // Check product (take out)
    
    func check(product: ScannedProduct) {
        
        let paintCans = ["Benjamin Moore", "Coronado", "Lenmar", "Insulx", "CorTech"]
        
        if paintCans.contains(product.manufacturer) {
            UIView.animate(withDuration: 1.0, animations: {
                self.addColourButton.alpha = 1.0
                self.addColourButton.isUserInteractionEnabled = true
                self.productTypeLabel.text = product.productType
            })
        }
        else {
            UIView.animate(withDuration: 1.0, animations: {
                self.productTypeLabel.text = product.productType
            })
        }
    }

    // MARK: - Add Colour
    
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
            let imageData = NSData(contentsOf: imageURL! as URL)
            let image = UIImage(data: imageData! as Data)
            return image!
        }
    }

}

extension PostScanViewController: ColourAdded {
    func setLabelFor(colour: String) {
        self.addColourButton.setTitle("", for: .normal)
        self.addColourButton.backgroundColor = UIColor(hexString: colour)
    }
    func set(colour: Colour) {
        self.colour = colour
        
        // set dictionary
    }

}
