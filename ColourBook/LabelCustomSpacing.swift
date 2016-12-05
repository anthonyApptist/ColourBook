//
//  LabelCustomSpacing.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-04.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class LabelCustomSpacing: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var space: CGFloat = 1.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.setSpacing(space: space)
        
    }

}
