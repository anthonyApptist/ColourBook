//
//  GoogleMap.swift
//  ColourBook
//
//  Created by Anthony Ma on 3/2/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

// Google Maps for searching and adding addresses
class GoogleMap: ColourBookVC, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    // Properties
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D? = nil
    var currentLocation: Address?
    
    // Search
    var locationSC: UISearchController?
    var searchButton: UIButton?
    
    // Google Map
    var map: GMSMapView?
    var marker: GMSMarker?
    
    // Save
    var saveButton: UIButton?

    // address list
    var locations = [String]()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButtonNeeded = true
        
        // get public list
        self.getPublicList()
        
        // Search Controller
        let resultsUpdater = SearchResultsTableVC()
        resultsUpdater.searchFor = .mapSearch
        
        locationSC = UISearchController(searchResultsController: resultsUpdater)
        locationSC?.searchResultsUpdater = resultsUpdater
        
        let searchBar = locationSC?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search for colour"
        
        locationSC?.hidesNavigationBarDuringPresentation = true
        locationSC?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        searchBar?.backgroundColor = UIColor.black
        
        // save button
        self.saveButton = UIButton(type: .system)
        self.saveButton?.frame = CGRect(x: view.center.x - ((view.frame.width * 0.60)/2), y: view.frame.maxY + 5, width: view.frame.width * 0.60, height: 40)
        self.saveButton?.layer.cornerRadius = 20
        self.saveButton?.layer.borderWidth = 2.0
        self.saveButton?.addTarget(self, action: #selector(saveButtonFunction), for: .touchUpInside)
        self.saveButton?.isUserInteractionEnabled = false
        self.saveButton?.setTitle("Save address to ColourBook", for: .normal)
        self.saveButton?.setTitleColor(UIColor.black, for: .normal)
        self.saveButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 13.0)
        self.saveButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        self.saveButton?.backgroundColor = UIColor.white
        
        // search button
        searchButton = UIButton(frame: CGRect(x: view.frame.maxX - (view.frame.width * 0.15) - 20, y: view.frame.maxY - (view.frame.width * 0.15) - 20, width: view.frame.width * 0.15, height: view.frame.width * 0.15))
        let image = UIImage(named: "search")
        searchButton?.setImage(image, for: .normal)
        searchButton?.contentMode = .scaleAspectFit
        searchButton?.addTarget(self, action: #selector(searchButtonFunction), for: .touchUpInside)
        searchButton?.isUserInteractionEnabled = false
    
        // check if screen state is business
        
    }
    
    // MARK: - CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = self.locationManager.location?.coordinate
        self.locationManager.stopUpdatingLocation()
        
        let geoCoder = GMSGeocoder()
        let location = CLLocation(latitude: (self.location?.latitude)!, longitude: (self.location?.longitude)!)
        
        geoCoder.reverseGeocodeCoordinate(self.location!) { (response, error) in
            // first result of geocoder
            let gmsAddress = response?.firstResult()
            
            let address = Address()
            
            // street name
            if let locationName = gmsAddress?.thoroughfare {
                address.address = locationName
            }
            // postal code
            if let postalCode = gmsAddress?.postalCode {
                address.postalCode = postalCode
            }
            
            self.currentLocation = address
            
            self.marker = GMSMarker()
            self.marker?.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            self.marker?.title = self.currentLocation?.address
            self.marker?.snippet = self.currentLocation?.postalCode 
            
            self.displayLocationAddAlertController(location: address)
            
            let camera = GMSCameraPosition.camera(withTarget: self.location!, zoom: 17.5)
            let gMapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
            
            self.marker?.map = gMapView
            self.map = gMapView
            
            self.view.addSubview(self.map!)
            self.view.addSubview(self.searchButton!)
            self.view.addSubview(self.saveButton!)
            self.view.bringSubview(toFront: self.backBtn)
            self.view.bringSubview(toFront: self.searchButton!)
            self.view.bringSubview(toFront: self.saveButton!)
        }
    }
    
    // MARK: - Search Button Function
    func searchButtonFunction() {
        let autoComplete = GMSAutocompleteViewController()
        autoComplete.delegate = self
        autoComplete.autocompleteBounds = GMSCoordinateBounds(coordinate: self.location!, coordinate: self.location!)
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autoComplete.autocompleteFilter = filter
        self.present(autoComplete, animated: true, completion: nil)
    }
    
    // MARK: - Display Add Location
    func displayLocationAddAlertController(location: Address) {
        let alertView = UIAlertController(title: "Is this your current location", message: location.address!, preferredStyle: .alert)
        // next ask if address is apartment
        let alertAction = UIAlertAction(title: "Next", style: .destructive, handler: { (action) in
            // ask if apartment
            self.displayAddApartment(location: location)
        })
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(alertAction)
        alertView.addAction(alertCancel)
        
        self.present(alertView, animated: true)
    }
    
    // MARK: - Display Add Apartment
    func displayAddApartment(location: Address) {
        let alertView = UIAlertController(title: "Is this an apartment?", message: location.address!, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.displayAddUnitToApartment(location: location)
        })
        let alertAdd = UIAlertAction(title: "No (Add address)", style: .destructive, handler: { (action) in
            if (self.locations.contains(location.address!)) {
                // add to user list only
                DataService.instance.saveAddressToUserListOnly(location: location, screenState: self.screenState)
                self.dismiss(animated: true, completion: nil)
                return
            }
            DataService.instance.saveNewAddress(location: location, screenState: self.screenState)
            self.dismiss(animated: true, completion: nil)
        })
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.saveButton?.animateViewToCoordinates(newX: self.view.center.x - ((self.view.frame.width*0.6)/2), newY: self.view.frame.height + 5)
        }
        alertView.addAction(alertAction)
        alertView.addAction(alertAdd)
        alertView.addAction(alertCancel)
        
        self.present(alertView, animated: true)
    }
    
    // MARK: - Add Unit Number
    func displayAddUnitToApartment(location: Address) {
        let alertView = UIAlertController(title: "Type in unit number for", message: location.address!, preferredStyle: .alert)
        
        // unit number text field
        alertView.addTextField { (textfield) in
            textfield.keyboardType = .namePhonePad
        }
        let alertAction = UIAlertAction(title: "Add", style: .destructive, handler: { (action) in
            
            let unitTextfield = alertView.textFields?[0]
            
            if let unitNumber = unitTextfield?.text {
                if unitNumber == "" {
                    self.displayNoUnitNumber(location: location)
                }
                else {
                    let streetName = location.address
                    location.address = "\(streetName!) - Unit \(unitNumber)"
                    
                    if (self.locations.contains(location.address!)) {
                        // add to public address list
                        DataService.instance.saveAddressToUserListOnly(location: location, screenState: self.screenState)
                        self.dismiss(animated: true, completion: nil)
                        return
                    }
                    
                    // add to user address list
                    DataService.instance.saveNewAddress(location: location, screenState: self.screenState)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else {
                self.displayNoUnitNumber(location: location)
            }
        })
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(alertAction)
        alertView.addAction(alertCancel)
        
        self.present(alertView, animated: true)
    }
    
    // MARK: - No Unit Number
    func displayNoUnitNumber(location: Address) {
        let alertView = UIAlertController(title: "No unit number added for", message: location.address!, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "No", style: .destructive, handler: { (action) in
            self.displayAddUnitToApartment(location: location)
        })
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertView.addAction(alertAction)
        alertView.addAction(alertCancel)
        
        self.present(alertView, animated: true) {
            
        }
    }
    
    // MARK: - GMSMapView Delegate
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    // MARK: - Save Button Function
    func saveButtonFunction() {
        self.displayAddApartment(location: self.currentLocation!)
    }

}


extension GoogleMap: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true) {
            let coordinates = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
            let cameraUpdate = GMSCameraUpdate.setTarget(coordinates, zoom: 17.5)
            
            self.map?.animate(with: cameraUpdate)
            
            self.marker?.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            
            // address object
            let address = Address()
            
            // gms place attributes
            let name = place.name
//            print(name)
            address.address = name
            
            // get postal code
            GMSGeocoder.init().reverseGeocodeCoordinate(place.coordinate, completionHandler: { (response, error) in
                // check
                if let postalCode = response?.firstResult()?.postalCode {
                    address.postalCode = postalCode
                }
                else {
                    address.postalCode = ""
                }
                self.displayAddApartment(location: address)
            })
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
