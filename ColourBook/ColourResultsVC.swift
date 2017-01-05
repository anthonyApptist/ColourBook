//
//  ColourResultsVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 19/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class ColourResultsVC: UIView {
    
    var colour: Colour?
    
    var colourName: UILabel!
    
    var colourHexCode: UILabel!
    
    var productCode: UILabel!
    
    var manufacturerID: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        // MARK: View
        
        // colour name label
        
        let colourNameOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: 50)
        
        let colourNameSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
        
        colourName = UILabel(frame: CGRect(origin: colourNameOrigin, size: colourNameSize))
        
        colourName.backgroundColor = UIColor.clear
        
        colourName.textColor = UIColor.black
         
        // colour hexcode label
        
        let hexcodeOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: frame.maxY + 10)
        
        let hexcodeSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
        
        colourHexCode = UILabel(frame: CGRect(origin: hexcodeOrigin, size: hexcodeSize))
        
         // product code label
         
         let productCodeOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: frame.maxY)
         
         let productCodeSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
         
         productCode = UILabel(frame: CGRect(origin: productCodeOrigin, size: productCodeSize))
         
         productCode.backgroundColor = UIColor.clear
         
         productCode.textColor = UIColor.black
         
         // manufacturer label
         
         let manufacturerOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: frame.maxY)
         
         let manufacturerSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
         
         manufacturerID = UILabel(frame: CGRect(origin: manufacturerOrigin, size: manufacturerSize))
         
         manufacturerID.backgroundColor = UIColor.clear
        
        
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
