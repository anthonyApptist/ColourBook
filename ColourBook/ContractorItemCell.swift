//
//  ContractorItemCell.swift
//  ColourBook
//
//  Created by Mark Meritt on 2017-02-21.
//  Copyright © 2017 Apptist. All rights reserved.
//

import UIKit

class ContractorItemCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel?
    @IBOutlet weak var imgView: UIImageView?
    @IBOutlet weak var logoImgView: UIImageView?
        
    var businessImage: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Set View
    func setViewFor(product: PaintCan) {
        self.logoImgView?.contentMode = .scaleAspectFit
        
        if businessImage == "" || businessImage == nil {
            self.logoImgView?.image = UIImage(named: "darkgreen")
        }
        else {
            self.logoImgView?.image = self.setImageFrom(urlString: businessImage!)
        }
        self.titleLbl?.text = product.timestamp
        
        if product.image == "N/A" {
            self.imgView?.image = UIImage(named: "darkgreen")
        }
        else {
            self.imgView?.image = self.setImageFrom(urlString: product.image!)
            self.imgView?.contentMode = .scaleAspectFit
        }
        /*
        if let colour = product.colour {
            self.swatchView?.backgroundColor = UIColor(hexString: colour.hexCode)
        }
        else {
            
        }
         */
    }
}
