//
//  AddressViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController {
    
    var address: String = ""
    
    var productImageView: UIImageView!
    
    var manufacturer: UILabel!
    
    var productName: UILabel!
    
    var category: UILabel!
    
    var code: UILabel!
    
    var productTypeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

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

    }


}
