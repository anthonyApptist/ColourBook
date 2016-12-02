//
//  MessageView.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-01.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class MessageView: UIView {
    
    var message: String?
    
    var img: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 113, width: 375, height: 396))
        
        self.backgroundColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
        
        let imageView = UIImageView(frame: CGRect(x: 107, y: 196, width: 163, height: 138))
        imageView.image = self.img
        
        let label = UILabel(frame: CGRect(x: 39, y: 376, width: 297, height: 84))
        label.text = self.message
        label.font = UIFont(name: "HelveticaNeue-Light", size: 24)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        
        self.addSubview(imageView)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
