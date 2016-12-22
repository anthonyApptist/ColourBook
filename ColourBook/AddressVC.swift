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
    
    var addressImageView: UIImageView!
    
    var addressName: UILabel!
    
    var addressLocation: UILabel!
    
    var latitude: UILabel!
    
    var longitude: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        // MARK: View
        
        // image view
        
        let addressImageOrigin = CGPoint(x: 0, y: 0)
        
        let addressImageSize = CGSize(width: view.frame.width, height: super.view.frame.height * 0.35)
        
        addressImageView = UIImageView(frame: CGRect(origin: addressImageOrigin, size: addressImageSize))
        
        print(addressImageView.frame.size)
        
        addressImageView.contentMode = .scaleAspectFill
        
        if address?.image == "" {
            
            let image = UIImage(named: "homeIcon")
            
            addressImageView.image = image
            
        }
        
        else {
            
            let imageURL = NSURL(string: (address?.image)!)
            
            let imageData = NSData(contentsOf: imageURL as! URL)
            
            let image = UIImage(data: imageData as! Data)
            
            addressImageView.image = image
            
        }
        
        // address name label
        
        let addressNameOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: addressImageView.frame.maxY + 10)
        
        let addressNameSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.10)
        
        addressName = UILabel(frame: CGRect(origin: addressNameOrigin, size: addressNameSize))
        
        addressName.backgroundColor = UIColor.clear
        
        addressName.textColor = UIColor.black
        
        addressName.text = address?.addressName
        
        
        // address location label
        
        let addressLocationOrigin = CGPoint(x: view.center.x - ((view.frame.width * 0.6)/2), y: addressName.frame.maxY + 10)
        
        let addressLocationSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.10)
        
        addressLocation = UILabel(frame: CGRect(origin: addressLocationOrigin, size: addressLocationSize))
        
        addressLocation.backgroundColor = UIColor.clear
        
        addressLocation.text = address?.addressLocation
        
        /*
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
        */
        
        // add to view
        
        view.addSubview(addressImageView)
        
        view.addSubview(addressName)
        
        view.addSubview(addressLocation)
        
        /*
        view.addSubview(latitude)
        
        view.addSubview(longitude)
        */
        
        
    }
    
}
