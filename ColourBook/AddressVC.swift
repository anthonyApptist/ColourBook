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

        // MARK: View
        
        // image view
        
        let addressImageOrigin = CGPoint(x: 0, y: 0)
        let addressImageSize = CGSize(width: frame.width, height: frame.height/2)
        addressImageView = UIImageView(frame: CGRect(origin: addressImageOrigin, size: addressImageSize))
        addressImageView.contentMode = .scaleAspectFit
        
        // address name label
        
        let addressNameOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: (frame.height/2) + (frame.height * 0.10) + ((frame.height * 0.5) * 0.10))
        let addressNameSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
        addressName = UILabel(frame: CGRect(origin: addressNameOrigin, size: addressNameSize))
        addressName.backgroundColor = UIColor.white
        addressName.textColor = UIColor.black
        addressName.textAlignment = .center
        
        // address location label
 
        let addressLocationOrigin = CGPoint(x: center.x - ((frame.width * 0.6)/2), y: (frame.maxY * 0.75) + (frame.height * 0.10))
        let addressLocationSize = CGSize(width: frame.width * 0.6, height: frame.height * 0.10)
        addressLocation = UILabel(frame: CGRect(origin: addressLocationOrigin, size: addressLocationSize))
        addressLocation.backgroundColor = UIColor.white
        addressLocation.textColor = UIColor.black
        addressLocation.textAlignment = .center
        
        // add to view
        
        self.addSubview(addressImageView)
        self.addSubview(addressName)
        self.addSubview(addressName)
        self.addSubview(addressLocation)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}


 
