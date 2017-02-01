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
    var colourInfo: UILabel!
    var manufacturerImageView: UIImageView!
    
    init(frame: CGRect, colour: Colour) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        // view layout
        let wrapView = CGRect(x: 0, y: 20, width: frame.width, height: frame.height - 20 - 20)
        let colourLabel = UIView(frame: CGRect(x: 0, y: wrapView.minY, width: frame.width, height: wrapView.height * 0.50))
        let remainingHeight: CGFloat = wrapView.height - (wrapView.height * 0.50)
        let firstQuarter = UIView(frame: CGRect(x: 0, y: colourLabel.frame.maxY, width: frame.width, height: remainingHeight/4))
        let rest = UIView(frame: CGRect(x: 0, y: firstQuarter.frame.maxY, width: frame.width, height: (remainingHeight/4) * 3))
        
        // MARK: View
        
        // colour swatch
        colourSwatch = UILabel(frame: colourLabel.frame)
        colourSwatch.backgroundColor = UIColor(hexString: colour.colourHexCode)
        
        // colour name label
        let colourInfoOrigin = CGPoint(x: firstQuarter.frame.minX + 20, y: firstQuarter.frame.minY)
        let colourInfoSize = CGSize(width: firstQuarter.frame.width - 20, height: firstQuarter.frame.height)
        colourInfo = UILabel(frame: CGRect(origin: colourInfoOrigin, size: colourInfoSize))
        colourInfo.backgroundColor = UIColor.white
        colourInfo.textColor = UIColor.black
        colourInfo.textAlignment = .left
        colourInfo.numberOfLines = 0
        let colourName: String = colour.colourName
        let productCode: String = colour.productCode
        colourInfo.text = "\(colourName)\n\(productCode)"
        
        let imageViewOrigin = CGPoint(x: rest.frame.minX, y: rest.frame.minY)
        let imageVIewSize = CGSize(width: rest.frame.width, height: rest.frame.height)
        manufacturerImageView = UIImageView(frame: CGRect(origin: imageViewOrigin, size: imageVIewSize))
        manufacturerImageView.contentMode = .scaleAspectFit
        if colour.manufacturer == "Benjamin Moore" {
            manufacturerImageView.image = UIImage(named: "BMoore.jpg")
        }
        if colour.manufacturer == "Sherwin Williams" {
            
        }
        
        // add to view
        addSubview(colourSwatch)
        addSubview(colourInfo)
        addSubview(manufacturerImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
