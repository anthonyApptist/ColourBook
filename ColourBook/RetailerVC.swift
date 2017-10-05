//
//  RetailerVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 7/3/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit

// Unused
// A view that shows a searched business
class RetailerVC: ColourBookVC {
    
    // Properties
    var businessImageView: UIImageView!
    var nameLabel: UILabel!
    var locationLabel: UILabel!
    var phoneNumberLabel: UILabel!
    var websiteLabel: UILabel!
    var postalCodeLabel: UILabel!
    
    // Model
    var business: Business?

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessImageView = UIImageView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height/2))
        
        let remainingHeightFrame = UIView(frame: CGRect(x: 0, y: businessImageView.frame.maxY, width: view.frame.width, height: view.frame.height/2))
    
        nameLabel = UILabel(frame: CGRect(x: 0, y: remainingHeightFrame.frame.minY, width: view.frame.width, height: remainingHeightFrame.frame.height/5))
        locationLabel = UILabel(frame: CGRect(x: 0, y: nameLabel.frame.maxY, width: view.frame.width, height: remainingHeightFrame.frame.height/5))
        phoneNumberLabel = UILabel(frame: CGRect(x: 0, y: locationLabel.frame.maxY, width: view.frame.width, height: remainingHeightFrame.frame.height/5))
        websiteLabel = UILabel(frame: CGRect(x: 0, y: phoneNumberLabel.frame.maxY, width: view.frame.width, height: remainingHeightFrame.frame.height/5))
        postalCodeLabel = UILabel(frame: CGRect(x: 0, y: websiteLabel.frame.maxY, width: view.frame.width, height: remainingHeightFrame.frame.height/5))
        
        view.addSubview(businessImageView)
        view.addSubview(nameLabel)
        view.addSubview(phoneNumberLabel)
        view.addSubview(websiteLabel)
        view.addSubview(postalCodeLabel)
        
        self.setBusinessInfo()
    }
    
    // MARK: - Set Business Info
    func setBusinessInfo() {
        /*
        if let image = business?.image {
            if image == "" {
                self.businessImageView.image = UIImage(named: "darkgreen")
            }
            else {
                self.businessImageView.image = self.stringToImage(imageName: image)
            }
        }
        
        self.nameLabel.text = self.business?.name
        self.nameLabel.textAlignment = .center
        
        self.locationLabel.text = self.business?.location
        self.locationLabel.textAlignment = .center
        
        self.phoneNumberLabel.text = self.business?.phoneNumber
        self.phoneNumberLabel.textAlignment = .center

        self.websiteLabel.text = self.business?.website
        self.websiteLabel.textAlignment = .center

        self.postalCodeLabel.text = self.business?.postalCode
        self.postalCodeLabel.textAlignment = .center
         */
    }
    
}
