//
//  SearchAddressViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import FirebaseDatabase

// Sets view
protocol AddressResult {
    func setResultsViewFor(location: Address)
}

// Addressed view for an addressed search through search bar in dashboard
class SearchAddressVC: ColourBookVC, UISearchBarDelegate {
    
    // Properties
    var firstTime: Bool = true // sets whether this was the first time in view
    
    var addressSC: UISearchController?
    
    var locationResultView: UIView!
    var searchButton: UIButton!
    
    var currentLocation: Address?
    
    var viewButton: UIButton?

    var allAddresses = [Address]()
    
    var categories = [String]()
    var categoryItems = [String:[ScannedProduct]]()
    
    var locationItems = [String:[String:[ScannedProduct]]]()
    
    var businessImages = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButtonNeeded = true
        
        // Search Controller
        let resultsUpdater = SearchResultsTableVC()
        resultsUpdater.searchFor = .addresses
        
        resultsUpdater.allAddresses = self.allAddresses
        
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
        
        // results view
        
        let resultViewOrigin = CGPoint(x: 0, y: self.backBtn.frame.maxY)
        let resultViewSize = CGSize(width: view.frame.width, height: view.frame.height - (2 * (view.frame.height * 0.10)) - 60)
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
        searchButton.addTarget(self, action: #selector(searchButtonFunction), for: .touchUpInside)
        
        view.bringSubview(toFront: self.backBtn)
        
        view.addSubview(locationResultView)
        view.addSubview(searchButton)
        
        view.addSubview(viewButton!)
    }
    
    // Mark: - Button Functions
    
    func viewButtonFunction() {
        let categories = storyboard?.instantiateViewController(withIdentifier: "CategoriesListVC") as! CategoriesListVC
        categories.screenState = .searching
        categories.selectedLocation = self.currentLocation
        
        // model to send over
        self.categories = []
        
        for category in (self.currentLocation?.categoryItems?.keys)! {
            self.categories.append(category)
        }
        
        categories.categories = self.categories
        categories.categoriesItems = (self.currentLocation?.categoryItems)!
        categories.businessImages = self.businessImages
        
        self.present(categories, animated: true)
    }
    
    func searchButtonFunction() {
        self.present(self.addressSC!, animated: true)
    }
    
}

extension SearchAddressVC: AddressResult {
    func setResultsViewFor(location: Address) {
        // address result view
        let addressVC = AddressView(frame: self.locationResultView.bounds, location: location)
        
        // check custom image
        if location.image == nil {
            addressVC.addressImageView.image = UIImage(named: "homeIcon")
        }
        else {
            addressVC.addressImageView.image = self.setImageFrom(urlString: location.image!)
        }
        
        addressVC.addressLocation.text = location.address
        
        // check custom name
        if location.name == nil || location.name == "" {
            addressVC.addressName.text = location.postalCode
        }
        else {
            addressVC.addressName.text = location.name!
        }
        
        // add result view
        self.locationResultView.addSubview(addressVC)
        
        // set current location
        self.currentLocation = location

    }
    
}
