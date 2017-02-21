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
    
    @IBOutlet weak var swatchView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setViewFor(product: ScannedProduct) {
        self.titleLbl?.text = product.timestamp
        if product.image == "N/A" {
            self.imgView?.image = UIImage(named: "darkgreen")
        }
        else {
            self.imgView?.image = self.setImageFrom(urlString: product.image)
            self.imgView?.contentMode = .scaleAspectFit
        }
        if let colour = product.colour {
            self.swatchView?.backgroundColor = UIColor(hexString: colour.colourHexCode)
        }
        else {
            
        }
    }
    
    func setImageFrom(urlString: String) -> UIImage {
        
        let imageURL = NSURL(string: urlString)
        let imageData = NSData(contentsOf: imageURL as! URL)
        let image = UIImage(data: imageData as! Data)
        return image!
    }
    
}
