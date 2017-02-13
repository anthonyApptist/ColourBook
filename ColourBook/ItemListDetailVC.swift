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
    

    override func viewDidAppear(_ animated: Bool) {
        
        titleLbl?.adjustsFontSizeToFitWidth = true
        
        titleLbl?.text = detailItem?.productType
        barcodeLbl?.text = detailItem?.upcCode
        
        if(screenState == .searching) {
            reportBtn?.isHidden = false
        } else {
            reportBtn?.isHidden = true
            reportBtn?.isUserInteractionEnabled = false
        }

        if let colour = detailItem?.colour {
            hexCodeLbl?.backgroundColor = UIColor(hexString: colour.colourHexCode)
            colourSwatch.backgroundColor = UIColor(hexString: colour.colourHexCode)
            
            productIdLbl?.text = colour.productCode
            colourNameLbl?.text = colour.colourName
        }
        else {
            hexCodeLbl?.text = "No colour added"
        
            productIdLbl?.text = ""
            colourNameLbl?.text = ""
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
        
        if detailItem?.manufacturer == "Benjamin Moore" {
            self.bannerImgView?.image = UIImage(named: "BenjaminMoorePhoto.jpg")
        }
        if detailItem?.manufacturer == "Sherwin Williams" {
            self.bannerImgView?.image = UIImage(named: "Sherwin Williams Photo")
        }
        
    }

}

extension ItemListDetailVC: ReportDelegate {
    func didPressReport() {
        DataService.instance.reportPressedFor(item: detailItem!, user: self.signedInUser)
    }
}
