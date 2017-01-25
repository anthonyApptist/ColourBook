//
//  SearchAddressViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol AddressResult {
    func setResultsViewFor(location: Location)
}

class SearchAddressVC: CustomVC {
    
    var addressSC: UISearchController?

    var resultTitleLabel: UILabel!
    var locationResultView: UIView!
    var searchButton: UIButton!

    var currentLocation: Location?
    
    var viewButton: UIButton?

    var addressDictionary: Dictionary<Location, String> = [:]
    var allAddresses = [Location]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDatabase()
        
        // Search Controller
        let resultsUpdater = SearchResultsTableVC()
        resultsUpdater.searchFor = .addresses
        
        addressSC = UISearchController(searchResultsController: resultsUpdater)
        addressSC?.searchResultsUpdater = resultsUpdater
        
        // set results updater delegate link
        resultsUpdater.addressResultDelegate = self
        
        let searchBar = addressSC?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Find any address"
        
        addressSC?.hidesNavigationBarDuringPresentation = true
        addressSC?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        searchBar?.backgroundColor = UIColor.black
        
        // MARK: - View
        
        // results title label
        
        let resultTitleOrigin = CGPoint(x: 0, y: self.backBtn.frame.maxY)
        let resultTitleSize = CGSize(width: view.frame.width, height: view.frame.height * 0.10)
        resultTitleLabel = UILabel(frame: CGRect(origin: resultTitleOrigin, size: resultTitleSize))
        resultTitleLabel.backgroundColor = UIColor.black
        resultTitleLabel.textColor = UIColor.white
        resultTitleLabel.textAlignment = .center
        resultTitleLabel.numberOfLines = 0
        resultTitleLabel.adjustsFontSizeToFitWidth = true
        resultTitleLabel.text = "Press Search"
        resultTitleLabel.textColor = UIColor.clear
        
        // results view
        
        let resultViewOrigin = CGPoint(x: 0, y: resultTitleLabel.frame.maxY)
        let resultViewSize = CGSize(width: view.frame.width, height: view.frame.height - (3 * (view.frame.height * 0.10)) - 40)
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
        searchButton.isUserInteractionEnabled = false
        searchButton.addTarget(self, action: #selector(searchButtonFunction), for: .touchUpInside)
        
        view.addSubview(resultTitleLabel)
        view.addSubview(locationResultView)
        view.addSubview(searchButton)
        
        view.addSubview(viewButton!)
    }
    
    // Mark: - Button Functions
    
    func viewButtonFunction() {
        
        let barcodes = AddressItemVC()
        
        barcodes.products = self.currentLocation?.items as! [ScannedProduct]
            
        barcodes.titleText = self.currentLocation?.locationName
        
        self.present(barcodes, animated: true, completion: {
            
        })
    }
    
    func searchButtonFunction() {
        
        let resultsUpdater = self.addressSC?.searchResultsUpdater as! SearchResultsTableVC
        
        resultsUpdater.allAddresses = self.allAddresses
        
        present(self.addressSC!, animated: true) {
            
        }
        
    }
    
    func getDatabase() {
            
        // Get address database (both business and address)
        
        DataService.instance.mainRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // businesses database check
            
            for child in snapshot.childSnapshot(forPath: "businesses").children.allObjects {
                
                let locationProfile = child as! FIRDataSnapshot
                let locationData = locationProfile.value as? NSDictionary
                let image = locationData?["image"] as? String
                let name = locationData?["name"] as? String
                let postalCode = locationData?["postalCode"] as! String
                let locationName = locationProfile.key
                
                let location = Location(locationName: locationName, postalCode: postalCode, image: image, name: name)
                
                // if address has barcodes
                if locationProfile.hasChild(Barcodes) {
                    
                    for barcode in snapshot.childSnapshot(forPath: "businesses").childSnapshot(forPath: location.locationName).childSnapshot(forPath: Barcodes).children.allObjects {
                        let paintProfile = barcode as! FIRDataSnapshot
                        
                        let profile = paintProfile.value as? NSDictionary
                        let productType = profile?["productName"] as! String
                        let manufacturer = profile?["manufacturer"] as! String
                        let upcCode = paintProfile.key
                        let image = profile?["image"] as! String
                        let timestamp = profile?["timestamp"] as! String
                        
                        // check for colour
                        if paintProfile.hasChild("colour") {
                            let colourProfile = profile?["colour"] as? NSDictionary
                            let colourName = colourProfile?["colourName"] as! String
                            let hexcode = colourProfile?["hexcode"] as! String
                            let manufacturerID = colourProfile?["manufacturerID"] as! String
                            let manufacturer = colourProfile?["manufacturer"] as! String
                            let productCode = colourProfile?["productCode"] as! String
                            
                            let colour = Colour(manufacturerID: manufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: manufacturer)
                            
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colour, timestamp: timestamp)
                            
                            location.items = []
                            location.items?.append(product)
                            self.allAddresses.append(location)
                            self.addressDictionary.updateValue("Business", forKey: location)
                        }
                        else {
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                            
                            location.items = []
                            location.items?.append(product)
                            self.allAddresses.append(location)
                            self.addressDictionary.updateValue("Business", forKey: location)
                        }
                    }
                }
                    // if no items attached to address
                else {
                    location.items = []
                    self.allAddresses.append(location)
                    self.addressDictionary.updateValue("Business", forKey: location)
                }
            }
            
            // addresses database check
            
            for child in snapshot.childSnapshot(forPath: "addresses").children.allObjects {
                
                let locationProfile = child as! FIRDataSnapshot
                let locationData = locationProfile.value as? NSDictionary
                let postalCode = locationData?["postalCode"] as! String
                let name = locationData?["name"] as? String
                let image = locationData?["image"] as? String
                let locationName = locationProfile.key
                
                let location = Location(locationName: locationName, postalCode: postalCode, image: image, name: name)
                
                // if address has barcodes
                if locationProfile.hasChild(Barcodes) {
                    
                    for barcode in snapshot.childSnapshot(forPath: "addresses").childSnapshot(forPath: location.locationName).childSnapshot(forPath: Barcodes).children.allObjects {
                        let paintProfile = barcode as! FIRDataSnapshot
                        
                        let profile = paintProfile.value as? NSDictionary
                        let productType = profile?["productName"] as! String
                        let manufacturer = profile?["manufacturer"] as! String
                        let upcCode = paintProfile.key
                        let image = profile?["image"] as! String
                        let timestamp = profile?["timeStamp"] as! String
                        
                        // check for colour
                        if paintProfile.hasChild("colour") {
                            let colourProfile = profile?["colour"] as? NSDictionary
                            let colourName = colourProfile?["colourName"] as! String
                            let hexcode = colourProfile?["hexcode"] as! String
                            let manufacturerID = colourProfile?["manufacturerID"] as! String
                            let manufacturer = colourProfile?["manufacturer"] as! String
                            let productCode = colourProfile?["productCode"] as! String
                            
                            let colour = Colour(manufacturerID: manufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: manufacturer)
                            
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colour, timestamp: timestamp)
                            
                            location.items = []
                            location.items?.append(product)
                            self.allAddresses.append(location)
                            self.addressDictionary.updateValue("Address", forKey: location)
                        }
                        else {
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                            
                            location.items = []
                            location.items?.append(product)
                            self.allAddresses.append(location)
                            self.addressDictionary.updateValue("Address", forKey: location)
                        }
                    }
                }
                // if no items attached to address
                else {
                    location.items = []
                    self.allAddresses.append(location)
                    self.addressDictionary.updateValue("Address", forKey: location)
                }
            }
            UIView.animate(withDuration: 1.0, animations: { 
                self.resultTitleLabel.textColor = UIColor.white
            })
            self.searchButton.isUserInteractionEnabled = true
        })
    }
}

extension SearchAddressVC: AddressResult {
    func setResultsViewFor(location: Location) {
        
        // check location
        let index = self.addressDictionary.index(forKey: location)
        let resultTitle = self.addressDictionary[index!].value
        
        // set address or business result
        self.resultTitleLabel.text = resultTitle
        
        // address result view
        let addressVC = AddressView(frame: self.locationResultView.bounds, location: location)
        
        // check custom image
        if location.image == nil || location.image == "" {
            addressVC.addressImageView.image = UIImage(named: "homeIcon")
        }
        else {
            addressVC.addressImageView.image = self.stringToImage(imageName: location.image!)
        }
        
        addressVC.addressLocation.text = location.locationName
        
        // check custom name
        if location.name == nil || location.name == "" {
            addressVC.addressName.text = location.postalCode
        }
        else {
            addressVC.addressName.text = location.name!
        }
        
        // add result view
        self.locationResultView.addSubview(addressVC)
        
        // view button if items attached
        if (location.items?.count)! > 0 {
            UIView.animate(withDuration: 1.0, animations: {
                self.viewButton?.titleLabel?.alpha = 1.0
                self.viewButton?.addTarget(self, action: #selector(self.viewButtonFunction), for: .touchUpInside)
            })
        }
        
        // set current location
        self.currentLocation = location
    }
}
