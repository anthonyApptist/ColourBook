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
    
    var colour: String?
    
    override func viewDidAppear(_ animated: Bool) {
        
        titleLbl?.text = detailItem?.productType
        nameLbl?.text = detailItem?.manufacturer
        productIdLbl?.text = detailItem?.upcCode
        
        if self.colour == "" {
            hexCodeLbl?.text = "No colour added"
        }
        else {
            hexCodeLbl?.text = ""
            hexCodeLbl?.backgroundColor = UIColor(hexString: self.colour!)
        }
        
        self.imgView?.contentMode = .scaleAspectFill
        
        if detailItem?.image == "N/A" {
            let image = UIImage(named: "darkgreen.jpg")
            self.imgView?.image = image
        }
        else {
            let image = self.setImageFrom(urlString: (detailItem?.image)!)
            self.imgView?.image = image
        }
        
    }

}
