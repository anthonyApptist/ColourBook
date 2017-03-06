//
//  SwatchView.swift
//  ColourBook
//
//  Created by Mark Meritt on 2017-02-12.
//  Copyright © 2017 Apptist. All rights reserved.
//

import UIKit

class SwatchView: UIView {

    var productIdLbl: UILabel?
    
    var colourNameLbl: UILabel?
    
    var hexCodeLbl: UILabel?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
 
    
    var isExpanded: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(isExpanded == false) {
            
            isExpanded = true
            self.animateToScale(scaleX: 1.0, scaleY: 15.0)
            UIView.animate(withDuration: 1.0, animations: { 
            })
        } else if(isExpanded == true) {
            
            isExpanded = false
            self.animateToScale(scaleX: 1.0, scaleY: 1.0)
            UIView.animate(withDuration: 1.0, animations: {
                
            })
        }
        
    }
    
 

}
