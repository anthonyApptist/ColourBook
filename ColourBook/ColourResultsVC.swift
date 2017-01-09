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
    var colourView: UILabel!
    var colourName: UILabel!
    var colourHexCode: UILabel!
    var productCode: UILabel!
    var manufacturerID: UILabel!
    
    init(frame: CGRect, colour: Colour) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        // MARK: View
        
        // colour view
        
        let colourViewOrigin = CGPoint(x: 0, y: 0)
        let colourViewSize = CGSize(width: frame.width, height: frame.height * 0.15)
        colourView = UILabel(frame: CGRect(origin: colourViewOrigin, size: colourViewSize))
        colourView.backgroundColor = UIColor(hexString: colour.colourHexCode)
        
        // colour name label
        
        let colourNameOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: colourView.frame.maxY + 20)
        let colourNameSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
        colourName = UILabel(frame: CGRect(origin: colourNameOrigin, size: colourNameSize))
        colourName.backgroundColor = UIColor.white
        colourName.textColor = UIColor.black
        colourName.textAlignment = .center
        colourName.text = colour.colourName
        
        // colour hexcode label
        
        let hexcodeOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: colourName.frame.maxY + 25)
        let hexcodeSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
        colourHexCode = UILabel(frame: CGRect(origin: hexcodeOrigin, size: hexcodeSize))
        colourHexCode.backgroundColor = UIColor.white
        colourHexCode.textColor = UIColor.black
        colourHexCode.textAlignment = .center
        colourHexCode.text = colour.colourHexCode
        
        // product code label
        
        let productCodeOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: colourHexCode.frame.maxY + 25)
        let productCodeSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
        productCode = UILabel(frame: CGRect(origin: productCodeOrigin, size: productCodeSize))
        productCode.backgroundColor = UIColor.white
        productCode.textColor = UIColor.black
        productCode.textAlignment = .center
        productCode.text = colour.productCode
        
        // manufacturer label
        
        let manufacturerOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: productCode.frame.maxY + 25)
        let manufacturerSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
        manufacturerID = UILabel(frame: CGRect(origin: manufacturerOrigin, size: manufacturerSize))
        manufacturerID.backgroundColor = UIColor.white
        manufacturerID.textColor = UIColor.black
        manufacturerID.textAlignment = .center
        manufacturerID.text = colour.manufacturerID
        
        // add to view
        
        addSubview(colourView)
        addSubview(colourName)
        addSubview(colourHexCode)
        addSubview(productCode)
        addSubview(manufacturerID)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
