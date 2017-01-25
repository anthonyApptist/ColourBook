//
//  AddressView.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class AddressView: UIView {
    
    var addressImageView: UIImageView!
    
    var addressName: UILabel!
    
    var addressLocation: UILabel!
    
    var latitude: UILabel!
    
    var longitude: UILabel!

    init(frame: CGRect, location: Location) {
        
        super.init(frame: frame)

        backgroundColor = UIColor.white
        
        let wrapView = UIView(frame: CGRect(x: 0, y: 20, width: frame.width, height: frame.height - 20 - 20))
        
        let imageWrap = UIView(frame: CGRect(x: 0, y: wrapView.bounds.minY, width: frame.width, height: wrapView.frame.height/2))
        
        let remainingHeight = wrapView.frame.height - imageWrap.frame.height
        
        let remainingFrameA = UIView(frame: CGRect(x: 0, y: imageWrap.frame.maxY, width: frame.width, height: remainingHeight/2))
        
        let remainingFrameB = UIView(frame: CGRect(x: 0, y: remainingFrameA.frame.maxY, width: frame.width, height: remainingHeight/2))

        // MARK: View
        
        // image view
        
        let addressImageOrigin = CGPoint(x: imageWrap.frame.minX, y: imageWrap.frame.minY)
        let addressImageSize = CGSize(width: imageWrap.frame.width, height: imageWrap.frame.height)
        addressImageView = UIImageView(frame: CGRect(origin: addressImageOrigin, size: addressImageSize))
        addressImageView.contentMode = .scaleAspectFit
        
        
        // address name label
        
        let addressNameOrigin = CGPoint(x: remainingFrameA.frame.minX, y: remainingFrameA.frame.minY)
        let addressNameSize = CGSize(width: remainingFrameA.frame.width, height: remainingFrameA.frame.height)
        addressName = UILabel(frame: CGRect(origin: addressNameOrigin, size: addressNameSize))
        addressName.backgroundColor = UIColor.white
        addressName.textColor = UIColor.black
        addressName.numberOfLines = 0
        addressName.textAlignment = .center
        
        
        // address location label
 
        let addressLocationOrigin = CGPoint(x: remainingFrameB.frame.minX, y: remainingFrameB.frame.minY)
        let addressLocationSize = CGSize(width: remainingFrameB.frame.width, height: remainingFrameB.frame.height)
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


 
