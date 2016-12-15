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
    
    var detailItem: Paint?
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(false)
        
        titleLbl?.text = detailItem?.productName
        nameLbl?.text = detailItem?.manufacturer
        productIdLbl?.text = detailItem?.code
        hexCodeLbl?.text = detailItem?.upcCode
        
        self.imgView?.contentMode = .scaleAspectFill
        self.imgView?.image = UIImage(named: (detailItem?.image)!)
        
        // Do any additional setup after loading the view.
    }

 

}
