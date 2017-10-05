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

// Detail view of an item from ItemListEditVC
class ItemListDetailVC: ColourBookVC {
    
    // Properties
    @IBOutlet var imgView: UIImageView?
    @IBOutlet var bannerImgView: UIImageView?
    @IBOutlet var barcodeLbl: UILabel?
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var productIdLbl: UILabel?
    @IBOutlet var colourNameLbl: UILabel?
    @IBOutlet var hexCodeLbl: UILabel?
    @IBOutlet var reportBtn: UIButton?
    @IBOutlet weak var colourSwatch: SwatchView!

    var detailItem: PaintCan?
    
    var currentLocation: String?
    var currentCategory: String?
    
    // MARK: - Flag Btn Pressed
    @IBAction func flagBtnPressed() {
        ReportHandler.sharedInstance.show(container: self)
        ReportHandler.sharedInstance.reportView.reportDelegate = self
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        titleLbl?.adjustsFontSizeToFitWidth = true
        
        titleLbl?.text = detailItem?.type
        barcodeLbl?.text = detailItem?.upcCode
        
        if(screenState == .searching) {
            reportBtn?.isHidden = false
        } else {
            reportBtn?.isHidden = true
            reportBtn?.isUserInteractionEnabled = false
        }
        
        if let colour = detailItem?.colour {
            hexCodeLbl?.backgroundColor = UIColor(hexString: colour.hexCode!)
            colourSwatch.backgroundColor = UIColor(hexString: colour.hexCode!)
            
            productIdLbl?.text = colour.productCode
            colourNameLbl?.text = colour.name
        }
        else {
            hexCodeLbl?.text = "No colour added"
        
            productIdLbl?.text = ""
            colourNameLbl?.text = "No colour added"
            colourNameLbl?.adjustsFontSizeToFitWidth = true
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
        
        // check manufacturer of item
        if detailItem?.manufacturer == "Benjamin Moore" {
            self.bannerImgView?.image = kBenjaminMoore
        }
        if detailItem?.manufacturer == "Sherwin Williams" {
            self.bannerImgView?.image = kSherwinWilliams
        }
    }
}

extension ItemListDetailVC: ReportDelegate {
    func didPressReport() {
        let userUID = standardUserDefaults.value(forKey: "uid") as! String
        let productUniqueID = detailItem?.uniqueID
        DataService.instance.reportPressedFor(user: userUID, location: self.currentLocation!, category: self.currentCategory!, uniqueID: productUniqueID!)
    }
}
