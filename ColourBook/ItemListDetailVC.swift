//
//  ItemListDetailVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-06.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

protocol ReportDelegate {
    func didPressReport()
}

class ItemListDetailVC: CustomVC {
    @IBOutlet var imgView: UIImageView?
    
    @IBOutlet var bannerImgView: UIImageView?
 
    @IBOutlet var barcodeLbl: UILabel?
    
    @IBOutlet weak var titleLbl: UILabel?

    @IBOutlet var productIdLbl: UILabel?
    
    @IBOutlet var colourNameLbl: UILabel?
    
    @IBOutlet var hexCodeLbl: UILabel?
    
    @IBOutlet var reportBtn: UIButton?

    @IBOutlet weak var colourSwatch: SwatchView!
    
    
    var detailItem: ScannedProduct?
    
    @IBAction func flagBtnPressed() {
        ReportHandler.sharedInstance.show(container: self)
        ReportHandler.sharedInstance.reportView.reportDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(screenState == .searching) {
            reportBtn?.isHidden = false
        } else {
            reportBtn?.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        titleLbl?.text = detailItem?.productType
        barcodeLbl?.text = detailItem?.manufacturer
        productIdLbl?.text = detailItem?.upcCode
        
   
        
        if let colour = detailItem?.colour {
            hexCodeLbl?.text = "HEX"
            hexCodeLbl?.backgroundColor = UIColor(hexString: colour.colourHexCode)
            colourSwatch.backgroundColor = UIColor(hexString: colour.colourHexCode)
            /*
            // set text for productCode and colourName label
            colourProductCodeLabel.text = colour.productCode
            colourNameLabel.text = colour.colourName
            */
        }
        else {
            hexCodeLbl?.text = "No colour added"
            /*
            // set text for productCode and colourName label
            colourProductCodeLabel.text = ""
            colourNameLabel.text = ""
            */
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

extension ItemListDetailVC: ReportDelegate {
    func didPressReport() {
        DataService.instance.reportPressedFor(item: detailItem!, user: self.signedInUser)
    }
}
