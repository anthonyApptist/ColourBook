//
//  IconView.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-11-23.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class IconView: UIView {
    
    var imageView : UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //  self.frame = CGRect(x: 0, y: 0, width: 129, height: 183)
        self.layer.cornerRadius = 16.0
        self.imageView?.contentMode = .scaleAspectFit
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
