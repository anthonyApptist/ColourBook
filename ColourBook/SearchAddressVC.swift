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
    var resultTitleLabel: UILabel!
    var locationResultView: UIView!
    var searchButton: UIButton!

    var searchImage: UIImage?
    var resultLocation: String!
    
    var viewButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search text field

        let searchTextFieldOrigin = CGPoint(x: self.backBtn.frame.maxX, y: 25)
        let searchTextFieldSize = CGSize(width: view.frame.width - self.backBtn.frame.maxX, height: view.frame.height * 0.05)
        searchTextfield = UITextField(frame: CGRect(origin: searchTextFieldOrigin, size: searchTextFieldSize))
        searchTextfield.placeholder = "Type in address"
        searchTextfield.adjustsFontSizeToFitWidth = true
        searchTextfield.textAlignment = .center
        
        // results title label
        
        let resultTitleOrigin = CGPoint(x: 0, y: searchTextfield.frame.maxY + 20)
        let resultTitleSize = CGSize(width: view.frame.width, height: view.frame.height * 0.10)
        resultTitleLabel = UILabel(frame: CGRect(origin: resultTitleOrigin, size: resultTitleSize))
        resultTitleLabel.backgroundColor = UIColor.black
        resultTitleLabel.textColor = UIColor.white
        self.resultTitleLabel.numberOfLines = 0
        
        // results view
        
        let resultViewOrigin = CGPoint(x: 0, y: searchTextfield.frame.height + resultTitleLabel.frame.height + 25)
        let resultViewSize = CGSize(width: view.frame.width, height: view.frame.height - searchTextfield.frame.height - (3 * (view.frame.height * 0.10)) - 25)
        locationResultView = UIView(frame: CGRect(origin: resultViewOrigin, size: resultViewSize))
        
        // view button
        viewButton = UIButton(type: .system)
        let viewButtonOrigin = CGPoint(x: 0, y: view.frame.maxY - (view.frame.height * 0.10) - (view.frame.height * 0.10))
        let viewButtonSize = CGSize(width: view.frame.width, height: view.frame.height * 0.10)
        viewButton?.frame = CGRect(origin: viewButtonOrigin, size: viewButtonSize)
        viewButton?.backgroundColor = UIColor.black
        viewButton?.setTitle("View", for: .normal)
        viewButton?.setTitleColor(UIColor.white, for: .normal)
        viewButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: viewButton!.frame.height * 0.5)
        viewButton?.titleLabel?.numberOfLines = 0
        viewButton?.titleLabel?.alpha = 0.0
        
        // search button
        searchButton = UIButton(type: .system)
        let searchButtonOrigin = CGPoint(x: 0, y: view.frame.maxY - view.frame.height * 0.10)
        let searchButtonSize = CGSize(width: view.frame.width, height: view.frame.height * 0.10)
        searchButton.frame = CGRect(origin: searchButtonOrigin, size: searchButtonSize)
        searchButton.backgroundColor = UIColor.black
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(UIColor.white, for: .normal)
        searchButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: searchButton.frame.height * 0.5)
        searchButton.titleLabel?.numberOfLines = 0
        searchButton.addTarget(self, action: #selector(searchButtonFunction), for: .touchUpInside)
        
        view.addSubview(searchTextfield)
        view.addSubview(resultTitleLabel)
        view.addSubview(locationResultView)
        view.addSubview(searchButton)
        
        view.addSubview(viewButton!)
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
                
                var businessLocations: [String] = []
                var homeLocations: [String] = []
                
                for child in snapshot.childSnapshot(forPath: "businesses").children.allObjects {
                    
                    let childSnapShot = child as! FIRDataSnapshot
                    let location = childSnapShot.key
                    businessLocations.append(location)
                }
                
                for child in snapshot.childSnapshot(forPath: "addresses").children.allObjects {
                    
                    let childSnapShot = child as! FIRDataSnapshot
                    let location = childSnapShot.key
                    homeLocations.append(location)
                }
                
                var childString: String = ""
                
                if businessLocations.contains(addressQuery!) {
                    
                    self.resultTitleLabel.text = "Business"
                    self.resultTitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: self.resultTitleLabel.frame.height * 0.50)
                    childString = "businesses"
                    
                    let locationData = snapshot.childSnapshot(forPath: childString).childSnapshot(forPath: addressQuery!)
                    
                    let profile = locationData.value as? NSDictionary
                    
                    let locationName = addressQuery
                    
                    let postalCode = profile?["postalCode"] as! String
                    let image = profile?["image"] as? String
                    
                    if image == "" {
                        // add default image
                        self.searchImage = UIImage(named: "homeIcon")
                    }
                    else {
                        self.searchImage = self.stringToImage(imageName: image!)
                    }
                    
                    let location = Location(locationName: locationName!, postalCode: postalCode, image: image!)
                    
                    // result VC
                    
                    let addressVC = AddressVC(frame: self.locationResultView.bounds, location: location)
                    
                    addressVC.addressImageView.image = self.searchImage!
                    addressVC.addressLocation.text = location.locationName
                    
                    self.resultLocation = location.locationName
                    
                    let name = profile?["name"] as? String
                    
                    if name == nil || name == "" {
                        addressVC.addressName.text = location.postalCode
                    }
                    else {
                        addressVC.addressName.text = name
                    }
                    
                    self.locationResultView.addSubview(addressVC)
                    
                    if snapshot.childSnapshot(forPath: childString).childSnapshot(forPath: location.locationName).hasChild(Barcodes) {
                        UIView.animate(withDuration: 1.0, animations: {
                            self.viewButton?.titleLabel?.alpha = 1.0
                            self.viewButton?.addTarget(self, action: #selector(self.viewButtonFunction), for: .touchUpInside)
                        })
                    }
                    
                    self.searchTextfield.text = ""
                }
                
                else if homeLocations.contains(addressQuery!) {
                    
                    self.resultTitleLabel.text = "Address"
                    self.resultTitleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: self.resultTitleLabel.frame.height * 0.50)
                    self.resultTitleLabel.adjustsFontForContentSizeCategory = true
                    childString = "addresses"
                    
                    let locationData = snapshot.childSnapshot(forPath: childString).childSnapshot(forPath: addressQuery!)
                    
                    let profile = locationData.value as? NSDictionary
                    
                    let locationName = addressQuery
                    
                    let postalCode = profile?["postalCode"] as! String
                    let image = profile?["image"] as? String
                    
                    if image == "" {
                        // add default image
                        self.searchImage = UIImage(named: "homeIcon")
                    }
                    else {
                        self.searchImage = self.stringToImage(imageName: image!)
                    }
                    
                    let location = Location(locationName: locationName!, postalCode: postalCode, image: image!)
                    
                    // result VC
                    
                    let addressVC = AddressVC(frame: self.locationResultView.bounds, location: location)
                    
                    addressVC.addressImageView.image = self.searchImage!
                    addressVC.addressLocation.text = location.locationName
                    
                    self.resultLocation = location.locationName
                    
                    let name = profile?["name"] as? String
                    
                    if name == nil || name == "" {
                        addressVC.addressName.text = location.postalCode
                    }
                    else {
                        addressVC.addressName.text = name
                    }
                    
                    self.locationResultView.addSubview(addressVC)
                    
                    if snapshot.childSnapshot(forPath: childString).childSnapshot(forPath: location.locationName).hasChild(Barcodes) {
                        UIView.animate(withDuration: 1.0, animations: {
                            self.viewButton?.titleLabel?.alpha = 1.0
                            self.viewButton?.addTarget(self, action: #selector(self.viewButtonFunction), for: .touchUpInside)
                        })
                    }
                    
                    self.searchTextfield.text = ""
                }
                else {
                    
                    let alertView = UIAlertController.init(title: "Not in database", message: "", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertView.addAction(alertAction)
                    self.present(alertView, animated: true, completion: nil)
                }
            })
        }
    
    }

    // add view button if location has barcodes
    
    func viewButtonFunction() {
        
        /*
        if self.resultTitleLabel.text == "Business" {
            let barcodes = ItemListEditVC()
            barcodes.screenState = .business
            barcodes.selectedLocation = self.resultLocation
        }
        if self.resultTitleLabel.text == "Address" {
            let barcodes = ItemListEditVC()
            barcodes.screenState = .homes
            barcodes.selectedLocation = self.resultLocation
        }
         */
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
