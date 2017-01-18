//
//  AddressVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class AddressVC: UIView {
    
    var addressImageView: UIImageView!
    
    var addressName: UILabel!
    
    var addressLocation: UILabel!
    
    var latitude: UILabel!
    
    var longitude: UILabel!

    init(frame: CGRect, location: Location) {
        
        super.init(frame: frame)

        backgroundColor = UIColor.white
        
        let wrapView = CGRect(x: 0, y: 20, width: frame.width, height: frame.height - 20 - 20)
        

        // MARK: View
        
        // image view
        
        let addressImageOrigin = CGPoint(x: 0, y: 0)
        let addressImageSize = CGSize(width: frame.width, height: wrapView.height/2)
        addressImageView = UIImageView(frame: CGRect(origin: addressImageOrigin, size: addressImageSize))
        addressImageView.contentMode = .scaleAspectFit
        
        let remainingFrameA = UIView(frame: CGRect(x: 0, y: addressImageView.frame.maxY, width: frame.width, height: wrapView.height/4))
        
        // address name label
        
        let addressNameOrigin = CGPoint(x: remainingFrameA.center.x - ((frame.width * 0.6)/2), y: remainingFrameA.center.y - ((remainingFrameA.frame.height * 0.50)/2))
        let addressNameSize = CGSize(width: frame.width * 0.6, height: remainingFrameA.frame.height * 0.50)
        addressName = UILabel(frame: CGRect(origin: addressNameOrigin, size: addressNameSize))
        addressName.backgroundColor = UIColor.white
        addressName.textColor = UIColor.black
        addressName.numberOfLines = 0
        addressName.textAlignment = .center
        
        let remainingFrameB = UIView(frame: CGRect(x: 0, y: remainingFrameA.frame.maxY, width: frame.width, height: wrapView.height/4))
        
        // address location label
 
        let addressLocationOrigin = CGPoint(x: remainingFrameB.center.x - ((frame.width * 0.6)/2), y: remainingFrameB.center.y - ((remainingFrameB.frame.height * 0.50)/2))
        let addressLocationSize = CGSize(width: frame.width * 0.6, height: remainingFrameB.frame.height * 0.50)
        addressLocation = UILabel(frame: CGRect(origin: addressLocationOrigin, size: addressLocationSize))
        addressLocation.backgroundColor = UIColor.white
        addressLocation.textColor = UIColor.black
        addressLocation.numberOfLines = 0
        addressLocation.textAlignment = .center
        
        // add to view
        
        self.addSubview(addressImageView)
        self.addSubview(addressName)
        self.addSubview(addressLocation)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}


 
