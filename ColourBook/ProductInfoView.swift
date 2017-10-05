//
//  ProductInfoView.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/1/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit

// Product info view for PostScanVC with product name, and banner for the specific brand

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
        
        productLabel = UILabel(frame: CGRect(x: 0, y: labelBox.frame.minY, width: frame.width, height: labelBox.frame.height))
        productLabel.adjustsFontSizeToFitWidth = true
        productLabel.allowsDefaultTighteningForTruncation = true
        productLabel.numberOfLines = 0
        productLabel.textAlignment = .center
        
        brandImgView = UIImageView()
        brandImgView.frame = CGRect(x: 0, y: remainingFrame.frame.minY, width: frame.width, height: remainingFrame.frame.height)
        brandImgView.contentMode = .scaleToFill

        addSubview(productLabel!)
        addSubview(brandImgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implmented")
    }


}
