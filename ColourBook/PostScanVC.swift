//
//  AfterScanViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 6/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

// View displaying the searched barcode

// After a colour is selected from ChooseColourVC
protocol ColourAdded {
    func setLabelFor(colour: String)
    func set(colour: Colour)
}

class PostScanVC: ColourBookVC { // make controller object for looking up and setting the view functions
    
    // barcode
    var barcode: String!
    
    // MARK: - View
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
    var product: PaintCan?
    
    // colour for paint
    var colour: Colour?

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButtonNeeded = true

        view.backgroundColor = UIColor.white
        
        // add to personal list button
        addToPersonalButton = UIButton(type: .system)
        addToPersonalButton.setTitle("P", for: .normal)
        addToPersonalButton.setTitleColor(UIColor.white, for: .normal)
        addToPersonalButton.backgroundColor = UIColor.black
        addToPersonalButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.frame.height*0.1*0.4)
        addToPersonalButton.addTarget(self, action: #selector(addToPersonalButtonFunction), for: .touchUpInside)
        addToPersonalButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addToPersonalButton)
        addToPersonalButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        addToPersonalButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        addToPersonalButton.widthAnchor.constraint(equalToConstant: self.view.frame.width/3).isActive = true
        addToPersonalButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        
        // add to business list button
        addToBusinessButton = UIButton(type: .system)
        addToBusinessButton.setTitle("B", for: .normal)
        addToBusinessButton.setTitleColor(UIColor.white, for: .normal)
        addToBusinessButton.backgroundColor = UIColor.black
        addToBusinessButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.frame.height*0.1*0.4)
        addToBusinessButton.addTarget(self, action: #selector(addToBusinessButtonFunction), for: .touchUpInside)
        addToBusinessButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addToBusinessButton)
        addToBusinessButton.leadingAnchor.constraint(equalTo: addToPersonalButton.trailingAnchor).isActive = true
        addToBusinessButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        addToBusinessButton.widthAnchor.constraint(equalToConstant: self.view.frame.width/3).isActive = true
        addToBusinessButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        
        // add to home list button
        addToHomeButton = UIButton(type: .system)
        addToHomeButton.setTitle("H", for: .normal)
        addToHomeButton.setTitleColor(UIColor.white, for: .normal)
        addToHomeButton.backgroundColor = UIColor.black
        addToHomeButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.frame.height*0.1*0.4)
        addToHomeButton.addTarget(self, action: #selector(addToAddressButtonFunction), for: .touchUpInside)
        addToHomeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addToHomeButton)
        addToHomeButton.leadingAnchor.constraint(equalTo: addToBusinessButton.trailingAnchor).isActive = true
        addToHomeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        addToHomeButton.widthAnchor.constraint(equalToConstant: self.view.frame.width/3).isActive = true
        addToHomeButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        
        // add colour button
        addColourButton = UIButton(type: .system)
        addColourButton.setTitle("Add Colour", for: .normal)
        addColourButton.setTitleColor(UIColor.white, for: .normal)
        addColourButton.backgroundColor = UIColor.black
        addColourButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: self.view.frame.height*0.1*0.4)
        addColourButton.addTarget(self, action: #selector(addColourFunction), for: .touchUpInside)
        addColourButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addColourButton)
        addColourButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        addColourButton.bottomAnchor.constraint(equalTo: addToPersonalButton.topAnchor).isActive = true
        addColourButton.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        addColourButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        
        // product type label
        let productTypeLabelOrigin = CGPoint(x: 0, y: 60)
        let productTypeLabelSize = CGSize(width: view.frame.width, height: view.frame.height * 0.1)
        productTypeLabel = UILabel(frame: CGRect(origin: productTypeLabelOrigin, size: productTypeLabelSize))
        productTypeLabel.backgroundColor = UIColor.black
        productTypeLabel.textColor = UIColor.white
        productTypeLabel.textAlignment = .center
        productTypeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: productTypeLabel.frame.height * 0.4)
        
        // image view
        let imageViewOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.5)/2), y: productTypeLabel.frame.maxY)
        let imageViewSize = CGSize(width: view.frame.width * 0.5, height: view.frame.width * 0.5)
        productImageView = UIImageView(frame: CGRect(origin: imageViewOrigin, size: imageViewSize))
        productImageView.contentMode = .scaleAspectFit

        // add to view
        self.view.addSubview(productTypeLabel)
        self.view.addSubview(productImageView)
        
        // look up barcode
        self.lookup(barcode: self.barcode)
    }
    
    // MARK: - Personal Btn Function
    func addToPersonalButtonFunction() {
        self.screenState = .personal
        
        if let colour = self.colour {
            product?.colour = colour
        }
        
        let timestamp = self.createTimestamp()
        product?.timestamp = timestamp
        
        let selectCategoryVC = SelectCategoryVC()
        selectCategoryVC.productProfile = self.product
        selectCategoryVC.screenState = self.screenState
        
        self.present(selectCategoryVC, animated: true, completion: nil)
    }
    
    // MARK: - Business Btn Function
    func addToBusinessButtonFunction() {
        let addressSelector = AddressSelector(screenState: .business)
        let selectView = SelectAddressVC(selector: addressSelector)
        selectView.screenState = .business
        selectView.selector?.delegate = selectView
        
        if let colour = self.colour {
            product?.colour = colour
        }
        
        let timestamp = self.createTimestamp()
        product?.timestamp = timestamp
        
        selectView.productProfile = self.product
        
        self.present(selectView, animated: true, completion: nil)
    }
    
    // MARK: - Homes Btn Function
    func addToAddressButtonFunction() {
        let selector = AddressSelector(screenState: .homes)
        let selectView = SelectAddressVC(selector: selector)
        selectView.screenState = .homes
        selectView.selector?.delegate = selectView
        
        if let colour = self.colour {
            product?.colour = colour
        }
        
        let timestamp = self.createTimestamp()
        product?.timestamp = timestamp
        
        selectView.productProfile = self.product
        
        self.present(selectView, animated: true, completion: nil)
    }
    
    // MARK: - Look up
    func lookup(barcode: String) { // look up the barcode
        DataService.instance.barcodeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // get barcodes
            if (snapshot.hasChild(self.barcode)) {
                // barcode database
                let barcodeDatabase = snapshot.value as? NSDictionary
                let profile = barcodeDatabase?[self.barcode] as? NSDictionary
                
                // get scanned product
                
                // product info
                let productName = profile?["name"] as? String
                let manufacturer = profile?["manufacturer"] as? String
                let type = profile?["type"] as? String
                let image = profile?["image"] as? String
                
                // check the product type
                self.product = self.check(productType: type!)
                
                // conditional
                if let code = profile?["code"] as? String {
                    self.product?.code = code
                }
                if let category = profile?["category"] as? String{
                    self.product?.category = category
                }
                
                // set paint can product
                self.product?.name = productName
                self.product?.manufacturer = manufacturer
                self.product?.type = type
                self.product?.image = image
                self.product?.upcCode = self.barcode
                
                // get product type
                self.productTypeLabel.text = type
                
                // product image
                self.productImageView.image = self.showProductImage(image: image!)
                
                self.productInfo = UIView(frame: CGRect(x: 0, y: self.productImageView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - self.productImageView.frame.height - (3 * (self.view.frame.height * 0.10)) - 60))
                
                self.view.addSubview(self.productInfo)
                
                // product info view
                let productView = ProductInfoView(frame: self.productInfo.bounds)
                self.productInfo.addSubview(productView)
                
                productView.productLabel.text = "\(manufacturer!)\n\(productName!)"
                
                // check company image to use
                if self.product?.manufacturer == "Benjamin Moore" {
                    productView.brandImgView.image = kBenjaminMoore
                }
                if self.product?.manufacturer == "Coronado" {
                    productView.brandImgView.image = kCoronado
                }
                if self.product?.manufacturer == "Lenmar" {
                    productView.brandImgView.image = kLenmar
                }
                if self.product?.manufacturer == "Insulx" {
                    productView.brandImgView.image = kInsulx
                }
                if self.product?.manufacturer == "CorTech" {
                    productView.brandImgView.image = kCorTech
                }
                if self.product?.manufacturer == "Rust-Oleum" {
                    productView.brandImgView.image = kRustoleum
                }
                if self.product?.manufacturer == "Tremclad" {
                    productView.brandImgView.image = kTremclad
                }
    
                self.hideActivityIndicator()
            }
            else {
                self.createAlertController(title: "Barcode not in database", message: "Try another")
                self.hideActivityIndicator()
            }
        })
    }
    
    // Check product
    func check(productType: String) -> PaintCan {
//        let paintCans = ["Benjamin Moore", "Coronado", "Lenmar", "Insulx", "CorTech"]
        
        switch productType {
        case "Paint":
            // ability to add a colour
            self.addColourButton.alpha = 1.0
            self.addColourButton.isUserInteractionEnabled = true
            let paintCan = PaintCan()
            return paintCan
        default:
            self.addColourButton.alpha = 0.0
            return PaintCan()
        }
        
        /*
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
         */
    }
    
    // MARK: - Add Colour
    func addColourFunction() {
        let colourView = ChooseColourVC()
        // set colour added to paint delegate
        colourView.colourAddedDelegate = self
        self.present(colourView, animated: true, completion: nil)
    }
    
    func showProductImage(image: String) -> UIImage {
        if image == "N/A" {
            return kDarkGreenLogo
        }
        else {
            let image = self.setImageFrom(urlString: image)
            return image
        }
    }

}

extension PostScanVC: ColourAdded {
    func setLabelFor(colour: String) {
        self.addColourButton.setTitle("", for: .normal)
        self.addColourButton.backgroundColor = UIColor(hexString: colour)
    }
    
    func set(colour: Colour) {
        self.colour = colour
        
        // set dictionary
    }

}
