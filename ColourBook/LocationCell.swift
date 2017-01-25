//
//  LocationCell.swift
//  ColourBook
//
//  Created by Anthony Ma on 23/1/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit

class LocationCell: UITableViewCell {
    
    var box1: UILabel?
    var box2: UILabel?
    var addressImageView: UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        box1 = UILabel()
        box2 = UILabel()
        addressImageView = UIImageView()
    }
    
    override func layoutSubviews() {
        // box 1
        
        box1?.frame = CGRect(x: self.contentView.bounds.minX, y: self.contentView.bounds.minY, width: self.contentView.frame.width * 0.50, height: self.contentView.frame.height)
        box1?.backgroundColor = UIColor.white
        box1?.textColor = UIColor.black
        box1?.textAlignment = .center
        box1?.adjustsFontSizeToFitWidth = true
        box1?.font = UIFont(name: "HelveticaNeue-Medium", size: (box1?.frame.height)! * 0.3)
        
        // box 2
        
        box2?.frame = CGRect(x: (box1?.frame.maxX)!, y: self.contentView.bounds.minY, width: self.contentView.frame.width * 0.25, height: self.contentView.frame.height)
        box2?.backgroundColor = UIColor.white
        box2?.textColor = UIColor.black
        box2?.textAlignment = .center
        box2?.adjustsFontSizeToFitWidth = true
        box2?.font = UIFont(name: "HelveticaNeue-Medium", size: (box2?.frame.height)! * 0.3)
        
        // image view
        
        addressImageView?.frame = CGRect(x: (box2?.frame.maxX)!, y: self.contentView.bounds.minY, width: self.contentView.frame.width * 0.25, height: self.contentView.frame.height)
        addressImageView?.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(box1!)
        self.contentView.addSubview(box2!)
        self.contentView.addSubview(addressImageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
