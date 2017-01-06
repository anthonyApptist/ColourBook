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
  
    var searchTextfield: UITextField!
    
    var searchButton: UIButton!
    
    var addressResultView: UIView!
    
    var searchImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search text field

        let searchTextFieldOrigin = CGPoint(x: 0, y: self.backBtn.frame.maxY - self.backBtn.frame.height)
        
        let searchTextFieldSize = CGSize(width: view.frame.width, height: view.frame.height * 0.1)
        
        searchTextfield = UITextField(frame: CGRect(origin: searchTextFieldOrigin, size: searchTextFieldSize))
        
        searchTextfield.placeholder = "type address and press search"
        
        searchTextfield.textAlignment = .center
        
        view.addSubview(searchTextfield)
        
        // results view
        
        let resultViewOrigin = CGPoint(x: 0, y: searchTextfield.frame.maxY + 20)
        
        let resultViewSize = CGSize(width: view.frame.width, height: view.frame.height - searchTextfield.frame.height - (view.frame.height * 0.1) - 50)
        
        addressResultView = UIView(frame: CGRect(origin: resultViewOrigin, size: resultViewSize))
        
        view.addSubview(addressResultView)
        
        print(addressResultView.frame.height)
        
        print(view.frame.height)
        
        
        // search button
        
        let searchButtonOrigin = CGPoint(x: view.center.x - (view.frame.width/2), y: view.frame.maxY - view.frame.height * 0.1)
        
        let searchButtonSize = CGSize(width: view.frame.width, height: view.frame.height * 0.1)
        
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
                    
                    let locationData = snapshot.childSnapshot(forPath: "businesses").childSnapshot(forPath: addressQuery!)
                    
                    let profile = locationData.value as? NSDictionary
                    
                    let locationName = addressQuery
                    
                    let postalCode = profile?["postalCode"] as! String
                    
                    let image = profile?["image"] as! String
                    
                    if image == "" {
                        
                        // add default image
                        self.searchImage = UIImage(named: "homeIcon")
                        
                    }
                        
                    else {
                        
                        self.searchImage = self.stringToImage(imageName: image)
                        
                    }
                    
                    let business = Location(locationName: locationName!, postalCode: postalCode, image: image)
                    
                    let addressVC = AddressVC(frame: self.addressResultView.frame, location: business)
                    
                    addressVC.addressImageView.image = self.searchImage!
                    
                    addressVC.addressLocation.text = business.locationName
                    
                    let name = profile?["name"] as? String
                    
                    if name == nil || name == "" {
                        addressVC.addressName.text = business.postalCode
                    }
                    else {
                        addressVC.addressName.text = name
                    }
                    
                    self.addressResultView.addSubview(addressVC)
                    
                }
                
                else if (snapshot.childSnapshot(forPath: "addresses").hasChild(addressQuery!)) {
                    
                    let addressQuery = self.searchTextfield.text?.capitalized
                    
                    let locationData = snapshot.childSnapshot(forPath: "addresses").childSnapshot(forPath: addressQuery!)
                    
                    let profile = locationData.value as? NSDictionary
                    
                    let locationName = addressQuery
                    
                    let postalCode = profile?["postalCode"] as! String
                    
                    let image = profile?["image"] as! String
                    
                    if image == "" {
                        
                        // add default image
                        self.searchImage = UIImage(named: "homeIcon")
                        
                    }
                        
                    else {
                        
                        self.searchImage = self.stringToImage(imageName: image)
                        
                    }
                    
                    let business = Location(locationName: locationName!, postalCode: postalCode, image: image)
                    
                    let addressVC = AddressVC(frame: self.addressResultView.frame, location: business)
                    
                    addressVC.addressImageView.image = self.searchImage!
                    
                    addressVC.addressLocation.text = business.locationName
                    
                    let name = profile?["name"] as? String
                    
                    if name == nil || name == "" {
                        addressVC.addressName.text = business.postalCode
                    }
                    else {
                        addressVC.addressName.text = name
                    }
                    
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
    
    // add to extensions
    
    func stringToImage(imageName: String) -> UIImage {
        
        let imageDataString = imageName
        
        let imageData = Data(base64Encoded: imageDataString)
        
        let image = UIImage(data: imageData!)
        
        return image!
        
    }

    
}
