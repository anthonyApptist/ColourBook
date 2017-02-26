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

class SearchAddressVC: CustomVC, UISearchBarDelegate {
    
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
        
        self.showActivityIndicator()
        
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
        viewButton?.setTitle("View Categories", for: .normal)
        viewButton?.setTitleColor(UIColor.white, for: .normal)
        viewButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: viewButton!.frame.height * 0.4)
        viewButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        viewButton?.titleLabel?.numberOfLines = 0
        viewButton?.titleLabel?.alpha = 1.0
        self.viewButton?.addTarget(self, action: #selector(self.viewButtonFunction), for: .touchUpInside)
        self.viewButton?.isUserInteractionEnabled = false
        
        // search button
        searchButton = UIButton(type: .system)
        let searchButtonOrigin = CGPoint(x: 0, y: view.frame.maxY - view.frame.height * 0.10)
        let searchButtonSize = CGSize(width: view.frame.width, height: view.frame.height * 0.10)
        searchButton.frame = CGRect(origin: searchButtonOrigin, size: searchButtonSize)
        searchButton.backgroundColor = UIColor.black
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(UIColor.white, for: .normal)
        searchButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: searchButton.frame.height * 0.4)
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
        
        let categories = storyboard?.instantiateViewController(withIdentifier: "CategoriesListVC") as! CategoriesListVC
        
        categories.screenState = .searching
        
        categories.selectedLocation = self.currentLocation
        
        self.present(categories, animated: true, completion: {
            
        })
    }
    
    func searchButtonFunction() {
        
        self.present(self.addressSC!, animated: true) {
            
        }
        
    }
    
}

extension SearchAddressVC: AddressResult {
    func setResultsViewFor(location: Location) {
        
        // check location
        let resultTitle = self.addressDictionary[location]
        
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
        
        // view button is active
        self.viewButton?.isUserInteractionEnabled = true
        
        // set current location
        self.currentLocation = location
    }
}
