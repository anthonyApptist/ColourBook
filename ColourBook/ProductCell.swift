//
//  ProductCell.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/1/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit

class ProductCell: UITableViewCell {
    
    var barcode: UILabel!
    var paint: UILabel!
    var colour: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // results title label
        
        let barcodeOrigin = CGPoint(x: 0, y: 0)
        let barcodeSize = CGSize(width: contentView.frame.width * 0.50, height: contentView.frame.height)
        barcode = UILabel(frame: CGRect(origin: barcodeOrigin, size: barcodeSize))
        barcode.backgroundColor = UIColor.white
        barcode.textColor = UIColor.black
        barcode.textAlignment = .center
        barcode.adjustsFontSizeToFitWidth = true
        barcode.numberOfLines = 0

        // results title label
        
        let paintOrigin = CGPoint(x: barcode.frame.maxX, y: 0)
        let paintSize = CGSize(width: contentView.frame.width * 0.25, height: contentView.frame.height)
        paint = UILabel(frame: CGRect(origin: paintOrigin, size: paintSize))
        paint.backgroundColor = UIColor.white
        paint.textColor = UIColor.black
        paint.textAlignment = .center
        paint.text = "Paint"
        paint.numberOfLines = 0

        // results title label
        
        let colourOrigin = CGPoint(x: paint.frame.maxX, y: 0)
        let colourSize = CGSize(width: contentView.frame.width * 0.25, height: contentView.frame.height)
        colour = UILabel(frame: CGRect(origin: colourOrigin, size: colourSize))
        colour.backgroundColor = UIColor.white
        colour.textColor = UIColor.black
        colour.textAlignment = .center
        colour.numberOfLines = 0
        
        contentView.addSubview(barcode)
        contentView.addSubview(paint)
        contentView.addSubview(colour)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implmented")
    }
    
}
