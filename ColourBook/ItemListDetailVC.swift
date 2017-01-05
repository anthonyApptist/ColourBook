//
//  ItemListDetailVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-06.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class ItemListDetailVC: CustomVC {
    @IBOutlet var imgView: UIImageView?
 
    @IBOutlet var nameLbl: UILabel?
    
    @IBOutlet weak var titleLbl: UILabel?

    @IBOutlet var productIdLbl: UILabel?
    
    @IBOutlet var hexCodeLbl: UILabel?

    var detailItem: ScannedProduct?
    
    override func viewDidAppear(_ animated: Bool) {
        
        titleLbl?.text = detailItem?.productType
        nameLbl?.text = detailItem?.manufacturer
        productIdLbl?.text = detailItem?.upcCode
        hexCodeLbl?.text = " "
        
        self.imgView?.contentMode = .scaleAspectFill
        
        if let imageUrlString = detailItem?.image {
            
            let image = self.setImageFrom(urlString: imageUrlString)
                
            self.imgView?.image = image
            
        }
        
        else {
            
            let image = UIImage(contentsOfFile: "darkgreen.jpg")
            
            self.imgView?.image = image
            
        }
        
    }

}
