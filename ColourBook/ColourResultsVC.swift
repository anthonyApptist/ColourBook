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
        
        let wrapView = CGRect(x: 0, y: 20, width: frame.width, height: frame.height - 20 - 20)
        
        let colourLabel = UIView(frame: CGRect(x: 0, y: wrapView.minY, width: frame.width, height: wrapView.height * 0.15))
        
        let remainingHeight: CGFloat = wrapView.height - (wrapView.height * 0.15)
        
        let firstQuarter = UIView(frame: CGRect(x: 0, y: colourLabel.frame.maxY, width: frame.width, height: remainingHeight/4))
        
        let secondQuarter = UIView(frame: CGRect(x: 0, y: firstQuarter.frame.maxY, width: frame.width, height: remainingHeight/4))
        
        let thirdQuarter = UIView(frame: CGRect(x: 0, y: secondQuarter.frame.maxY, width: frame.width, height: remainingHeight/4))
        
        let fourthQuarter = UIView(frame: CGRect(x: 0, y: thirdQuarter.frame.maxY, width: frame.width, height: remainingHeight/4))
        
        // MARK: View
        
        // colour view
        colourView = UILabel(frame: colourLabel.frame)
        colourView.backgroundColor = UIColor(hexString: colour.colourHexCode)
        
        // colour name label
        
        let colourNameOrigin = CGPoint(x: firstQuarter.center.x - ((firstQuarter.frame.width * 0.6)/2), y: firstQuarter.center.y - ((firstQuarter.frame.height * 0.50)/2))
        let colourNameSize = CGSize(width: firstQuarter.frame.width * 0.6, height: firstQuarter.frame.height * 0.50)
        colourName = UILabel(frame: CGRect(origin: colourNameOrigin, size: colourNameSize))
        colourName.backgroundColor = UIColor.white
        colourName.textColor = UIColor.black
        colourName.textAlignment = .center
        colourName.text = colour.colourName
        
        // colour hexcode label
        
        let hexcodeOrigin = CGPoint(x: secondQuarter.center.x - ((secondQuarter.frame.width * 0.6)/2), y: secondQuarter.center.y - ((secondQuarter.frame.height * 0.50)/2))
        let hexcodeSize = CGSize(width: secondQuarter.frame.width * 0.6, height: secondQuarter.frame.height * 0.50)
        colourHexCode = UILabel(frame: CGRect(origin: hexcodeOrigin, size: hexcodeSize))
        colourHexCode.backgroundColor = UIColor.white
        colourHexCode.textColor = UIColor.black
        colourHexCode.textAlignment = .center
        colourHexCode.text = colour.colourHexCode
        
        // product code label
        
        let productCodeOrigin = CGPoint(x: thirdQuarter.center.x - ((thirdQuarter.frame.width * 0.6)/2), y: thirdQuarter.center.y - ((thirdQuarter.frame.height * 0.50)/2))
        let productCodeSize = CGSize(width: thirdQuarter.frame.width * 0.6, height: thirdQuarter.frame.height * 0.50)
        productCode = UILabel(frame: CGRect(origin: productCodeOrigin, size: productCodeSize))
        productCode.backgroundColor = UIColor.white
        productCode.textColor = UIColor.black
        productCode.textAlignment = .center
        productCode.text = colour.productCode
        
        // manufacturer label
        
        let manufacturerOrigin = CGPoint(x: fourthQuarter.center.x - ((fourthQuarter.frame.width * 0.6)/2), y: fourthQuarter.center.y - ((fourthQuarter.frame.height * 0.50)/2))
        let manufacturerSize = CGSize(width: fourthQuarter.frame.width * 0.6, height: fourthQuarter.frame.height * 0.50)
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
