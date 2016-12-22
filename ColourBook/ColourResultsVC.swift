//
//  ColourResultsVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 19/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class ColourResultsVC: UIViewController {
    
    var colour: Colour?
    
    var colourName: UILabel!
    
    var colourHexCode: UILabel!
    
    var productCode: UILabel!
    
    var manufacturerID: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // MARK: View
        
        // colour name label
        
        let colourNameOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: 50)
        
        let colourNameSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.10)
        
        colourName = UILabel(frame: CGRect(origin: colourNameOrigin, size: colourNameSize))
        
        colourName.backgroundColor = UIColor.clear
        
        colourName.textColor = UIColor.black
        
        colourName.text = colour?.colourName
        
        
        // colour hexcode label
        
        let hexcodeOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.maxY + 10)
        
        let hexcodeSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.10)
        
        colourHexCode = UILabel(frame: CGRect(origin: hexcodeOrigin, size: hexcodeSize))
        
        colourHexCode.backgroundColor = UIColor(hexString: (colour?.colourHexCode)!)
        
         // product code label
         
         let productCodeOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.maxY)
         
         let productCodeSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.10)
         
         productCode = UILabel(frame: CGRect(origin: productCodeOrigin, size: productCodeSize))
         
         productCode.backgroundColor = UIColor.clear
         
         productCode.textColor = UIColor.black
         
         productCode.text = colour?.productCode
         
         // manufacturer label
         
         let manufacturerOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.maxY)
         
         let manufacturerSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.10)
         
         manufacturerID = UILabel(frame: CGRect(origin: manufacturerOrigin, size: manufacturerSize))
         
         manufacturerID.backgroundColor = UIColor.clear
         
         manufacturerID.text = colour?.manufacturerID
        
        
        // add to view
        
        view.addSubview(colourName)
        
        view.addSubview(colourHexCode)
        
         view.addSubview(productCode)
         
         view.addSubview(manufacturerID)
        
        
    }


}
