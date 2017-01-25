//
//  ColourView.swift
//  ColourBook
//
//  Created by Anthony Ma on 19/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class ColourView: UIView {
    
    // properties
    var colourSwatch: UILabel!
    var colourName: UILabel!
    var productCode: UILabel!

    
    init(frame: CGRect, colour: Colour) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        // view layout
        let wrapView = CGRect(x: 0, y: 20, width: frame.width, height: frame.height - 20 - 20)
        let colourLabel = UIView(frame: CGRect(x: 0, y: wrapView.minY, width: frame.width, height: wrapView.height * 0.50))
        let remainingHeight: CGFloat = wrapView.height - (wrapView.height * 0.50)
        let firstHalf = UIView(frame: CGRect(x: 0, y: colourLabel.frame.maxY, width: frame.width, height: remainingHeight/2))
        let secondHalf = UIView(frame: CGRect(x: 0, y: firstHalf.frame.maxY, width: frame.width, height: remainingHeight/2))
        
        // MARK: View
        
        // colour swatch
        colourSwatch = UILabel(frame: colourLabel.frame)
        colourSwatch.backgroundColor = UIColor(hexString: colour.colourHexCode)
        
        // colour name label
        let colourNameOrigin = CGPoint(x: firstHalf.center.x - ((firstHalf.frame.width * 0.6)/2), y: firstHalf.center.y - ((firstHalf.frame.height * 0.50)/2))
        let colourNameSize = CGSize(width: firstHalf.frame.width * 0.6, height: firstHalf.frame.height * 0.50)
        colourName = UILabel(frame: CGRect(origin: colourNameOrigin, size: colourNameSize))
        colourName.backgroundColor = UIColor.white
        colourName.textColor = UIColor.black
        colourName.textAlignment = .center
        colourName.text = colour.colourName
        
        // product code label
        let productCodeOrigin = CGPoint(x: secondHalf.center.x - ((secondHalf.frame.width * 0.6)/2), y: secondHalf.center.y - ((secondHalf.frame.height * 0.50)/2))
        let productCodeSize = CGSize(width: secondHalf.frame.width * 0.6, height: secondHalf.frame.height * 0.50)
        productCode = UILabel(frame: CGRect(origin: productCodeOrigin, size: productCodeSize))
        productCode.backgroundColor = UIColor.white
        productCode.textColor = UIColor.black
        productCode.textAlignment = .center
        productCode.text = colour.productCode
        
        // add to view
        addSubview(colourSwatch)
        addSubview(colourName)
        addSubview(productCode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
