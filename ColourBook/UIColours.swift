//
//  Colours.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-11-23.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class UIColours {
    
    var colour: UIColor
    
    init(col: UIColor) {
        self.colour = col
    }
    
    func getColour() -> UIColor {
        return colour
    }
    
    func setColour(colour: UIColor) -> UIColor {
            let newColour = colour
            return newColour
    }
    
    func goldColour() -> UIColor {
        return UIColor.init(red: 210/255, green: 197/255, blue: 173/255, alpha: 1.0)
    }
    
    func pinkColour() -> UIColor {
        return UIColor.init(red: 207/255, green: 184/255, blue: 184/255, alpha: 1.0)
    }
    
    func purpleColour() -> UIColor {
        return UIColor.init(red: 192/255, green: 189/255, blue: 207/255, alpha: 1.0)
    }
    
    func greenColour() -> UIColor {
        return UIColor.init(red: 185/255, green: 209/255, blue: 207/255, alpha: 1.0)
    }
}
