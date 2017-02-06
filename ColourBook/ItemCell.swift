//
//  ItemCell.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-01.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel?
    
    @IBOutlet weak var imgView: UIImageView?
    
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
