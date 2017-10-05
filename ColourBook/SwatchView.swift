//
//  SwatchView.swift
//  ColourBook
//
//  Created by Mark Meritt on 2017-02-12.
//  Copyright © 2017 Apptist. All rights reserved.
//

import UIKit

// Colour of the current paint can
// A bar at the bottom of item list detail view
class SwatchView: UIView {

    // Properties
    var productIdLbl: UILabel?
    var colourNameLbl: UILabel?
    var hexCodeLbl: UILabel?
    var isExpanded: Bool = false
    
    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Touches Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isExpanded == false) { // if swatch is not expanded, spring the swatch bar up
            isExpanded = true
            self.animateToScale(scaleX: 1.0, scaleY: self.frame.height)
            UIView.animate(withDuration: 1.0, animations: {
                
            })
        }
        if (isExpanded == true) { // if swatch is expanded collapse view
            isExpanded = false
            self.animateToScale(scaleX: 1.0, scaleY: 1.0)
            UIView.animate(withDuration: 1.0, animations: {
            })
        }
        
    }
}
