//
//  ProductInfoView.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/1/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit

class ProductInfoView: UIView {
    
    var productLabel: UILabel!
    var brandImgView: UIImageView!
    
    /*
     var manufacturer: UILabel!
     var productName: UILabel!
    var category: UILabel!
    var code: UILabel!
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // view layout
        let wrapView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        let labelBox = UIView(frame: CGRect(x: 0, y: wrapView.frame.minY, width: frame.width, height: wrapView.frame.height * 0.25))
        
        let remainingFrame = UIView(frame: CGRect(x: 0, y: labelBox.frame.maxY, width: frame.width, height: wrapView.frame.height * 0.75))
        
        /*
         let firstQuarter = UIView(frame: CGRect(x: 0, y: wrapView.frame.minY, width: frame.width, height: wrapView.frame.height * 0.25))
         
         let secondQuarter = UIView(frame: CGRect(x: 0, y: firstQuarter.frame.maxY, width: frame.width, height: wrapView.frame.height * 0.25))
         
         let thirdQuarter = UIView(frame: CGRect(x: 0, y: secondQuarter.frame.maxY, width: frame.width, height: wrapView.frame.height * 0.25))
         
         let fourthQuarter = UIView(frame: CGRect(x: 0, y: thirdQuarter.frame.maxY, width: frame.width, height: wrapView.frame.height * 0.25))
        // manufacturer label
        let manufacturerLabelOrigin = CGPoint(x: firstQuarter.center.x - ((wrapView.frame.width * 0.6)/2), y: firstQuarter.center.y - ((firstQuarter.frame.height * 0.50)/2))
        let manufacturerLabelSize = CGSize(width: wrapView.frame.width * 0.6, height: firstQuarter.frame.height * 0.50)
        manufacturer = UILabel(frame: CGRect(origin: manufacturerLabelOrigin, size: manufacturerLabelSize))
        manufacturer.backgroundColor = UIColor.clear
        
        // product name label
        
        let nameLabelOrigin = CGPoint(x: secondQuarter.center.x - ((wrapView.frame.width * 0.6)/2), y: secondQuarter.center.y - ((secondQuarter.frame.height * 0.50)/2))
        let nameLabelSize = CGSize(width: wrapView.frame.width * 0.6, height: secondQuarter.frame.height * 0.50)
        productName = UILabel(frame: CGRect(origin: nameLabelOrigin, size: nameLabelSize))
        productName.backgroundColor = UIColor.clear
        */
        
        productLabel = UILabel(frame: CGRect(x: 0, y: labelBox.frame.minY, width: frame.width, height: labelBox.frame.height))
        productLabel.adjustsFontSizeToFitWidth = true
        productLabel.allowsDefaultTighteningForTruncation = true
        productLabel.numberOfLines = 0
        productLabel.textAlignment = .center
        
        brandImgView = UIImageView()
        brandImgView.frame = CGRect(x: 0, y: remainingFrame.frame.minY, width: frame.width, height: remainingFrame.frame.height)
        brandImgView.contentMode = .scaleToFill
        
        /*
        // category label
        
        let categoryLabelOrigin = CGPoint(x: secondQuarter.center.x - ((wrapView.frame.width * 0.6)/2), y: secondQuarter.center.y - ((secondQuarter.frame.height * 0.50)/2))
        let categoryLabelSize = CGSize(width: wrapView.frame.width * 0.6, height: secondQuarter.frame.height * 0.5)
        category = UILabel(frame: CGRect(origin: categoryLabelOrigin, size: categoryLabelSize))
        category.backgroundColor = UIColor.clear
        
        // code label
        
        let codeLabelOrigin = CGPoint(x: fourthQuarter.center.x - ((wrapView.frame.width * 0.6)/2), y: fourthQuarter.center.y - ((fourthQuarter.frame.height * 0.50)/2))
        let codeLabelSize = CGSize(width: wrapView.frame.width * 0.6, height: fourthQuarter.frame.height * 0.50)
        code = UILabel(frame: CGRect(origin: codeLabelOrigin, size: codeLabelSize))
        code.backgroundColor = UIColor.clear
         
         addSubview(code)
         addSubview(category)
         addSubview(manufacturer)
         addSubview(productName)
        */
        addSubview(productLabel!)
        addSubview(brandImgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implmented")
    }


}
