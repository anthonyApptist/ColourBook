//
//  IconView.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-11-23.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

// Icons in the dashboard

class IconView: UIView {
    
    // Properties
    var imageView : UIImageView?
    
    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 16.0
        self.imageView?.contentMode = .scaleAspectFit
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
