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
        
        // add to business list button
        
        let addToBusinessButtonOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.15)/2), y: view.frame.height * 0.85)
        
        let addToBusinessButtonSize = CGSize(width: view.frame.width * 0.15, height: view.frame.width * 0.15)
        
        addToBusinessButton = UIButton.init(frame: CGRect(origin: addToBusinessButtonOrigin, size: addToBusinessButtonSize))
        
        addToBusinessButton.setTitle("B", for: .normal)
        
        addToBusinessButton.setTitleColor(UIColor.black, for: .normal)
        
        addToBusinessButton.layer.borderWidth = 3.0
        
        addToBusinessButton.layer.borderColor = UIColor.black.cgColor
        
        // add to home list button
        
        let addToHomeButtonOrigin = CGPoint(x: view.center.x + ((view.frame.width * 0.15)/2) + ((view.frame.width * 0.15)/2), y: view.frame.height * 0.85)
        
        let addToHomeButtonSize = CGSize(width: view.frame.width * 0.15, height: view.frame.width * 0.15)
        
        addToHomeButton = UIButton.init(frame: CGRect(origin: addToHomeButtonOrigin, size: addToHomeButtonSize))
        
        addToHomeButton.setTitle("H", for: .normal)
        
        addToHomeButton.setTitleColor(UIColor.black, for: .normal)
        
        addToHomeButton.layer.borderWidth = 3.0
        
        addToHomeButton.layer.borderColor = UIColor.black.cgColor
        
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
                
                let paintCan = PaintCan(manufacturer: paintCanProfile?["manufactuer"] as! String, productName: paintCanProfile?["productName"] as! String, category: paintCanProfile?["category"] as! String, code: paintCanProfile?["code"] as! String, upcCode: self.barcode, image: paintCanProfile?["image"] as! String)
                
                self.productTypeLabel.text = paintCanProfile?["product"] as! String?
                
                self.productTypeLabel.textAlignment = .center
                
                let imageURL = NSURL.init(string: paintCan.image)
                
                let imageData = NSData.init(contentsOf: imageURL as! URL)
                
                let image = UIImage.init(data: imageData as! Data)
                
                self.productImageView.image = image
                
                self.productImageView.contentMode = .scaleAspectFill
                
                self.manufacturer.text = paintCan.manufacturer
                
                self.manufacturer.textAlignment = .center
                
                self.manufacturer.textColor = UIColor.black
                
                self.productName.text = paintCan.productName
                
                self.productName.adjustsFontSizeToFitWidth = true
                
                self.productName.textColor = UIColor.black
                
                self.code.text = paintCan.code
                
                self.code.textColor = UIColor.black
                
                self.category.text = paintCan.category
                
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
        
        if productTypeLabel.text == "paint can" {
            
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

}