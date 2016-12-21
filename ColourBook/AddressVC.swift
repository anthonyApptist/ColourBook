//
//  AddressViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class AddressVC: UIViewController {
    
    var address: Address?
    
    var addressName: UILabel!
    
    var addressLocation: UILabel!
    
    var latitude: UILabel!
    
    var longitude: UILabel!
    
    var addressImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        // MARK: View
        
        // address name label
        
        let addressNameOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.03)
        
        let addressNameSize = CGSize(width: view.frame.width * 0.6, height: 50)
        
        addressName = UILabel(frame: CGRect(origin: addressNameOrigin, size: addressNameSize))
        
        addressName.backgroundColor = UIColor.clear
        
        addressName.textColor = UIColor.black
        
        addressName.text = address?.addressName
        
        
        // address location label
        
        let addressLocationOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.50)
        
        let addressLocationSize = CGSize(width: view.frame.width * 0.6, height: 50)
        
        addressLocation = UILabel(frame: CGRect(origin: addressLocationOrigin, size: addressLocationSize))
        
        addressLocation.backgroundColor = UIColor.clear
        
        addressLocation.text = address?.addressLocation
        
        // latitude label
        
        let latitudeOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.55)
        
        let latitudeSize = CGSize(width: view.frame.width * 0.6, height: 50)
        
        latitude = UILabel(frame: CGRect(origin: latitudeOrigin, size: latitudeSize))
        
        latitude.backgroundColor = UIColor.clear
        
        latitude.textColor = UIColor.black
        
        latitude.text = String(describing: address?.latitude)
        
        // longitude label
        
        let longitudeOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.height * 0.60)
        
        let longitudeSize = CGSize(width: view.frame.width * 0.6, height: 50)
        
        longitude = UILabel(frame: CGRect(origin: longitudeOrigin, size: longitudeSize))
        
        longitude.backgroundColor = UIColor.clear
        
        longitude.text = String(describing: address?.longitude)
        
        // image view
        
        let addressImageOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.4)/2), y: view.frame.height * 0.08)
        
        let addressImageSize = CGSize(width: view.frame.width * 0.4, height: view.frame.height * 0.4)
        
        addressImageView = UIImageView(frame: CGRect(origin: addressImageOrigin, size: addressImageSize))
        
        
        
        // add to view 
        
        view.addSubview(addressName)
        
        view.addSubview(addressLocation)
        
        view.addSubview(latitude)
        
        view.addSubview(longitude)
        
        view.addSubview(addressImageView)
        
    }
    
}
