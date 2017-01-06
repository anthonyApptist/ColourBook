//
//  SearchAddressViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchAddressVC: CustomVC {
  /*
    var searchTextfield: UITextField!
    
    var searchButton: UIButton!
    
    var addressResultView: UIView!
    
    var defaultLabel: UILabel!
    
    var searchImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search text field

        let searchTextFieldOrigin = CGPoint(x: 0, y: self.backBtn.frame.maxY - (view.frame.height * 0.1))
        
        let searchTextFieldSize = CGSize(width: view.frame.width, height: view.frame.height * 0.1)
        
        searchTextfield = UITextField(frame: CGRect(origin: searchTextFieldOrigin, size: searchTextFieldSize))
        
        searchTextfield.placeholder = "type address and press search"
        
        searchTextfield.textAlignment = .center
        
        view.addSubview(searchTextfield)
        
        // results view
        
        let resultViewOrigin = CGPoint(x: 0, y: searchTextfield.frame.maxY)
        
        let resultViewSize = CGSize(width: view.frame.width, height: view.frame.height - searchTextfield.frame.height - (view.frame.height * 0.15))
        
        addressResultView = UIView(frame: CGRect(origin: resultViewOrigin, size: resultViewSize))
        
        view.addSubview(addressResultView)
        
        print(addressResultView.frame.height)
        
        print(view.frame.height)
        
        // default label 
        
        let defaultLabelOrigin = CGPoint(x: addressResultView.center.x - ((addressResultView.frame.width * 0.6)/2), y: addressResultView.center.y - ((addressResultView.frame.height * 0.15)/2))
        
        let defaultLabelSize = CGSize(width: addressResultView.frame.width * 0.6, height: addressResultView.frame.height * 0.15)
        
        defaultLabel = UILabel(frame: CGRect(origin: defaultLabelOrigin, size: defaultLabelSize))
        
        defaultLabel.text = "Search from our database"
        
        view.addSubview(defaultLabel)
        
        // search button
        
        let searchButtonOrigin = CGPoint(x: view.center.x - (view.frame.width * 0.6)/2, y: addressResultView.frame.maxY)
        
        let searchButtonSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.1)
        
        searchButton = UIButton(frame: CGRect(origin: searchButtonOrigin, size: searchButtonSize))
        
        searchButton.setTitle("Search", for: .normal)
        
        searchButton.setTitleColor(UIColor.black, for: .normal)
        
        searchButton.backgroundColor = UIColor.clear
        
        searchButton.layer.borderWidth = 5
        
        searchButton.layer.borderColor = UIColor.black.cgColor
        
        searchButton.addTarget(self, action: #selector(searchButtonFunction), for: .touchUpInside)
        
        view.addSubview(searchButton)
    }
    
    func searchButtonFunction() {
        
        if (searchTextfield.text?.isEmpty)! {
            
            let alertView = UIAlertController.init(title: "No address typed in", message: "", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertView.addAction(alertAction)
            
            self.present(alertView, animated: true, completion: nil)
            
        }
        
        else {
            DataService.instance.mainRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let addressQuery = self.searchTextfield.text?.capitalized
                
                if (snapshot.childSnapshot(forPath: "businesses").hasChild(addressQuery!)) {
                    
                    self.defaultLabel.removeFromSuperview()
                    
                    let businessData = snapshot.childSnapshot(forPath: "businesses").childSnapshot(forPath: addressQuery!)
                    
                    let profile = businessData.value as? NSDictionary
                    
                    let businessProfile = profile?["businessProfile"] as? NSDictionary
                    
                    let businessName = businessProfile?["businessName"]
                    
                    let businessLocation = businessProfile?["businessLocation"]
                    
                    let latitude = businessProfile?["latitude"]
                    
                    let longitude = businessProfile?["longitude"]
                    
                    let image = businessProfile?["image"]
                    
                    let business = Business(businessName: businessName as! String, businessLocation: businessLocation as! String, latitude: latitude as! Double, longitude: longitude as! Double, image: image as! String)
                    
                    if business.image == "" {
                        
                        // add default image
                        self.searchImage = UIImage(named: "homeIcon")
                    }
                    
                    else {
                        
                        // convert image data string
                        
                    }
                    
                    let addressVC = AddressVC(frame: self.addressResultView.frame)
                    
                    addressVC.addressImageView.image = self.searchImage!
                    
                    addressVC.addressName.text = business.businessName
                    
                    addressVC.addressLocation.text = business.businessLocation
                    
                    self.addressResultView.addSubview(addressVC)
                    
                }
                
                else if (snapshot.childSnapshot(forPath: "addresses").hasChild(addressQuery!)) {
                    
                    self.defaultLabel.removeFromSuperview()
                    
                    let addressData = snapshot.childSnapshot(forPath: "businesses").childSnapshot(forPath: addressQuery!)
                    
                    let profile = addressData.value as? NSDictionary
                    
                    let addressProfile = profile?["locationProfile"] as? NSDictionary
                    
                    let addressName = addressProfile?["addressName"]
                    
                    let addressLocation = addressProfile?["addressLocation"]
                    
                    let latitude = addressProfile?["latitude"]
                    
                    let longitude = addressProfile?["longitude"]
                    
                    let image = addressProfile?["image"]
                    
                    let address = Address(addressName: addressName as! String, addressLocation: addressLocation as! String, latitude: latitude as! Double, longitude: longitude as! Double, image: image as! String)
                    
                    if address.image == "" {
                        
                        // add default image
                        self.searchImage = UIImage(named: "homeIcon")
                        
                    }
                        
                    else {
                        
                        // convert image data string
                        
                    }
                    
                    let addressVC = AddressVC(frame: self.addressResultView.frame)
                    
                    addressVC.addressImageView.image = self.searchImage!
     
                    addressVC.addressName.text = address.addressName
                    
                    addressVC.addressLocation.text = address.addressLocation

                    self.addressResultView.addSubview(addressVC)

                }
            
                else {
                    
                    let alertView = UIAlertController.init(title: "Address not in database", message: "", preferredStyle: .alert)
                    
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertView.addAction(alertAction)
                    
                    self.present(alertView, animated: true, completion: nil)
                    
                }
            })
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextfield.resignFirstResponder()
    }
    
    */

}
