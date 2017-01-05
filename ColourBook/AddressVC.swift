//
//  AddressViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class AddressVC: UIView {
    
    /*
    var address: Address?
    
    var addressImageView: UIImageView!
    
    var addressName: UILabel!
    
    var addressLocation: UILabel!
    
    var latitude: UILabel!
    
    var longitude: UILabel!

    override init(frame: CGRect) {
        
        super.init(frame: frame)

        self.backgroundColor = UIColor.white

        // MARK: View
        
        // image view
        
        let addressImageOrigin = CGPoint(x: 0, y: 0)
    
        let addressImageSize = CGSize(width: self.frame.width / 2, height: self.frame.height / 2)
        
        addressImageView = UIImageView(frame: CGRect(origin: addressImageOrigin, size: addressImageSize))
        
        print(addressImageView.frame.size)
        
        addressImageView.contentMode = .scaleAspectFit
        

        
        if address?.image == nil {
            
            let image = UIImage(named: "darkred")
            
            addressImageView.image = image
            
        }
        
        else {
            
            let imageURL = NSURL(string: (address?.image)!)
            
            let imageData = NSData(contentsOf: imageURL as! URL)
            
            let image = UIImage(data: imageData as! Data)
            
            addressImageView.image = image
            
        }
     
        // address name label
        
        let addressNameOrigin = CGPoint(x: self.center.x - ((self.frame.width * 0.6)/2), y: addressImageView.frame.maxY + 10)
        
        let addressNameSize = CGSize(width: self.frame.width * 0.6, height: self.frame.height * 0.10)
        
        addressName = UILabel(frame: CGRect(origin: addressNameOrigin, size: addressNameSize))
        
        addressName.textColor = UIColor.black
        
        addressName.textAlignment = .center 
        
        addressName.backgroundColor = UIColor.white
        
        
        // address location label
 
        let addressLocationOrigin = CGPoint(x: self.center.x - ((self.frame.width * 0.6)/2), y: addressName.frame.maxY + 10)
        
        let addressLocationSize = CGSize(width: self.frame.width * 0.6, height: self.frame.height * 0.10)

        
        addressLocation = UILabel(frame: CGRect(origin: addressLocationOrigin, size: addressLocationSize))
        
        addressLocation.textColor = UIColor.black
        
        addressLocation.textAlignment = .center
        
        addressLocation.backgroundColor = UIColor.white
        

        // latitude label
        
        let latitudeOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: addressLocation.frame.maxY)
        
        let latitudeSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.10)
        
        latitude = UILabel(frame: CGRect(origin: latitudeOrigin, size: latitudeSize))
        
        latitude.backgroundColor = UIColor.clear
        
        latitude.textColor = UIColor.black
        
        latitude.text = String(describing: address?.latitude)
        
        // longitude label
        
        let longitudeOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: latitude.frame.maxY)
        
        let longitudeSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.10)
        
        longitude = UILabel(frame: CGRect(origin: longitudeOrigin, size: longitudeSize))
        
        longitude.backgroundColor = UIColor.clear
        
        longitude.text = String(describing: address?.longitude)
        
        // add to view
        
        self.addSubview(addressImageView)
        

        self.addSubview(addressName)
        

        addressImageView.pinToTop(view: self, margin: 40).isActive = true
        addressImageView.pinToLeft(view: self, margin: 40).isActive = true
        addressImageView.pinToRight(view: self, margin: 40).isActive = true
        addressImageView.pinToBottom(view: self, margin: 40).isActive = true
        
        self.addSubview(addressName)
 
        self.addSubview(addressLocation)
        
        /*
        view.addSubview(latitude)
        
        view.addSubview(longitude)
        */
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}
*/

}
 
