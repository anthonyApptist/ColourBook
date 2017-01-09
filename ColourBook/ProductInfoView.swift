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
    
    var manufacturer: UILabel!
    var productName: UILabel!
    var category: UILabel!
    var code: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let wrapView = UIView(frame: CGRect(x: 0, y: 20, width: frame.width, height: frame.height - 20 - 20))
        
        let firstQuarter = UIView(frame: CGRect(x: 0, y: wrapView.frame.minY, width: frame.width, height: wrapView.frame.height * 0.25))
        
        let secondQuarter = UIView(frame: CGRect(x: 0, y: firstQuarter.frame.maxY, width: frame.width, height: wrapView.frame.height * 0.25))
        
        let thirdQuarter = UIView(frame: CGRect(x: 0, y: secondQuarter.frame.maxY, width: frame.width, height: wrapView.frame.height * 0.25))
        
        let fourthQuarter = UIView(frame: CGRect(x: 0, y: thirdQuarter.frame.maxY, width: frame.width, height: wrapView.frame.height * 0.25))
        
        // manufacturer label
        
        let manufacturerLabelOrigin = CGPoint(x: firstQuarter.center.x - ((wrapView.frame.width * 0.6)/2), y: firstQuarter.center.y - ((firstQuarter.frame.height * 0.50)/2))
        let manufacturerLabelSize = CGSize(width: wrapView.frame.width * 0.6, height: firstQuarter.frame.height * 0.50)
        manufacturer = UILabel(frame: CGRect(origin: manufacturerLabelOrigin, size: manufacturerLabelSize))
        manufacturer.backgroundColor = UIColor.clear
        // category label
        
        let categoryLabelOrigin = CGPoint(x: secondQuarter.center.x - ((wrapView.frame.width * 0.6)/2), y: secondQuarter.center.y - ((secondQuarter.frame.height * 0.50)/2))
        let categoryLabelSize = CGSize(width: wrapView.frame.width * 0.6, height: secondQuarter.frame.height * 0.5)
        category = UILabel.init(frame: CGRect(origin: categoryLabelOrigin, size: categoryLabelSize))
        category.backgroundColor = UIColor.clear
        
        // product name label
        
        let nameLabelOrigin = CGPoint(x: thirdQuarter.center.x - ((wrapView.frame.width * 0.6)/2), y: thirdQuarter.center.y - ((thirdQuarter.frame.height * 0.50)/2))
        let nameLabelSize = CGSize(width: wrapView.frame.width * 0.6, height: thirdQuarter.frame.height * 0.50)
        productName = UILabel(frame: CGRect(origin: nameLabelOrigin, size: nameLabelSize))
        productName.backgroundColor = UIColor.clear
        
        // code label
        
        let codeLabelOrigin = CGPoint(x: fourthQuarter.center.x - ((wrapView.frame.width * 0.6)/2), y: fourthQuarter.center.y - ((fourthQuarter.frame.height * 0.50)/2))
        let codeLabelSize = CGSize(width: wrapView.frame.width * 0.6, height: fourthQuarter.frame.height * 0.50)
        code = UILabel(frame: CGRect(origin: codeLabelOrigin, size: codeLabelSize))
        code.backgroundColor = UIColor.clear
        
        
        addSubview(manufacturer)
        addSubview(productName)
        addSubview(code)
        addSubview(category)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implmented")
    }


}
