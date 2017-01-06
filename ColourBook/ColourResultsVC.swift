//
//  ColourResultsVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 19/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class ColourResultsVC: UIView {
    
    // properties
    var colourName: UILabel!
    var colourHexCode: UILabel!
    var productCode: UILabel!
    var manufacturerID: UILabel!
    
    init(frame: CGRect, colour: Colour) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        // MARK: View
        
        // colour name label
        
        let colourNameOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: center.y - ((frame.height * 0.10)/2) - ((frame.height * 0.5)/2))
        let colourNameSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
        colourName = UILabel(frame: CGRect(origin: colourNameOrigin, size: colourNameSize))
        colourName.backgroundColor = UIColor.white
        colourName.textColor = UIColor.black
        colourName.textAlignment = .center
        colourName.text = colour.colourName
        
        // colour hexcode label
        
        let hexcodeOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: center.y - ((frame.height * 0.10)/2))
        let hexcodeSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
        colourHexCode = UILabel(frame: CGRect(origin: hexcodeOrigin, size: hexcodeSize))
        colourHexCode.backgroundColor = UIColor.white
        colourHexCode.textColor = UIColor.black
        colourHexCode.textAlignment = .center
        colourHexCode.text = colour.colourHexCode
        
        // product code label
        
        let productCodeOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: (frame.maxY * 0.75) - (frame.height * 0.10))
        let productCodeSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
        productCode = UILabel(frame: CGRect(origin: productCodeOrigin, size: productCodeSize))
        productCode.backgroundColor = UIColor.white
        productCode.textColor = UIColor.black
        productCode.textAlignment = .center
        productCode.text = colour.productCode
        
        // manufacturer label
        
        let manufacturerOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: (frame.maxY * 0.85) - (frame.height * 0.10))
        let manufacturerSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
        manufacturerID = UILabel(frame: CGRect(origin: manufacturerOrigin, size: manufacturerSize))
        manufacturerID.backgroundColor = UIColor.white
        manufacturerID.textColor = UIColor.black
        manufacturerID.textAlignment = .center
        manufacturerID.text = colour.manufacturerID
        
        // add to view
        
        addSubview(colourName)
        addSubview(colourHexCode)
        addSubview(productCode)
        addSubview(manufacturerID)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
