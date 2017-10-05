//
//  AddEditAddressVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-06.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import MapKit

/*
class AddEditAddressVC: ColourBookVC, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    var mapSC: UISearchController?
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBOutlet weak var titleLbl: UILabel?
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var map: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    let locationManager = CLLocationManager()
    
    var searchedCoordinates: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.saveBtn.alpha = 0.0
        
        // Search Controller
        let resultsUpdater = SearchResultsTableVC()
        
        mapSC = UISearchController(searchResultsController: resultsUpdater)
        mapSC?.searchResultsUpdater = resultsUpdater
        
        let searchBar = mapSC?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Type address name"
        
        mapSC?.hidesNavigationBarDuringPresentation = true
        mapSC?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        searchBar?.backgroundColor = UIColor.black
        
        map.delegate = self
        locationManager.delegate = self
        
        locationManager.requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    
        titleLbl?.text = setAddEditAddressTitle(screenState: screenState)
        
        self.saveBtn.addTarget(self, action: #selector(self.saveBtnPressed(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    
        displayCurrentLocation()

    }
    
    @IBAction func showSearchBar(_ sender: AnyObject) {
        
        let results = self.mapSC?.searchResultsUpdater as! SearchResultsTableVC
        
        present(self.mapSC!, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.map.annotations.count != 0{
            annotation = self.map.annotations[0]
            self.map.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.map.centerCoordinate = self.pointAnnotation.coordinate
            self.map.addAnnotation(self.pinAnnotationView.annotation!)
            
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (localSearchResponse?.boundingRegion.center.latitude)!, longitude: (localSearchResponse?.boundingRegion.center.longitude)!)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, self.regionRadius * 2, self.regionRadius * 2)
            self.map.setRegion(coordinateRegion, animated: true)
            
            self.searchedCoordinates = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowInfo" {
            
             if self.screenState == .homes {
                
                if let detail = segue.destination as? AddEditImageVC {
                    /*
                    detail.addressItem = addressItem
                    detail.screenState = screenState
                    */
                }
            }
        }
        
        if segue.identifier == "ShowInfoBusiness" {
            
            if self.screenState == .business {
                
                if let detail = segue.destination as? AddEditImageVCBusiness {
                    /*
                     detail.addressItem = addressItem
                     detail.screenState = screenState
                     */
                }
            }
            
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationCoordinates = manager.location?.coordinate
        let pin = AnnotationPin(coordinate: locationCoordinates!)
        map.addAnnotation(pin)
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let coordinateRegion = MKCoordinateRegionMake(locationCoordinates!, span)
        
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

 
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            centerMapOnLocation(loc)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annoView = MKPinAnnotationView()
        
        if annotation.isKind(of: AnnotationPin.self) {
            annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annoView.pinTintColor = UIColor.blue
            annoView.animatesDrop = true
            
        } else if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        return annoView
    }
    
    func createAnnotationForLocation(_ location: CLLocation) {
        let pin = AnnotationPin(coordinate: location.coordinate)
        map.addAnnotation(pin)
    }
    
    func saveBtnPressed(_ sender: Any?) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(self.searchedCoordinates!, completionHandler: { (placemarks, error) in
            
            var placeMark: CLPlacemark!
            
            placeMark = placemarks?[0]
            
            let locationName = placeMark.name
            
            let postalCode = placeMark.postalCode
            
            let image = ""
            
//            self.setNewLocation(locationName: locationName!, postalCode: postalCode!, image: image, name: "")
            
            // add to business database
//            DataService.instance.saveLocation(screenState: self.screenState, location: self.location!)
             
            // add to user business bucket list
//            DataService.instance.saveLocationTo(user: self.signedInUser, location: self.location!, screenState: self.screenState)
        
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        })
        
    
    }
    
    func displayCurrentLocation() {
        
        let currentLocation = self.locationManager.location?.coordinate
        
        let geoCoder = CLGeocoder()
        
        let location = CLLocation(latitude: (currentLocation?.latitude)!, longitude: (currentLocation?.longitude)!)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
    
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            let locationName = placeMark.name
            let postalCode = placeMark.postalCode
            let location = Location(locationName: locationName!, postalCode: postalCode!)
            self.displayLocationAddAlertController(location: location)
        })
    }
    
    func displayLocationAddAlertController(location: Location) {
        let alertView = UIAlertController(title: "Is this your current location", message: location.locationName, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Next", style: .destructive, handler: { (action) in

            // ask if apartment
            self.displayAddApartment(location: location)
        })
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(alertAction)
        alertView.addAction(alertCancel)
        
        self.present(alertView, animated: true) { 
            UIView.animate(withDuration: 1.0, animations: { 
                self.saveBtn.alpha = 1.0
            })
        }
    }
    
    func displayAddApartment(location: Location) {
        let alertView = UIAlertController(title: "Is this an apartment?", message: location.locationName, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            
            self.displayAddUnitToApartment(location: location)
        })
        let alertCancel = UIAlertAction(title: "Add", style: .cancel, handler: { (action) in
            
            // add to business database
            DataService.instance.saveAddress(screenState: self.screenState, location: location)
            
            // add to user business bucket list
            DataService.instance.saveAddressTo(user: self.signedInUser, location: location, screenState: self.screenState)
        })
        alertView.addAction(alertAction)
        alertView.addAction(alertCancel)
        
        self.present(alertView, animated: true) { 
            
        }
    }
    
    func displayAddUnitToApartment(location: Location) {
        let alertView = UIAlertController(title: "Type in unit number for", message: location.locationName, preferredStyle: .alert)
        
        // unit number text field
        alertView.addTextField { (textfield) in
            textfield.keyboardType = .numberPad
        }
        
        let alertAction = UIAlertAction(title: "Add", style: .destructive, handler: { (action) in
            
            let unitTextfield = alertView.textFields?[0]
            
            if let unitNumber = unitTextfield?.text {
                
                if unitNumber == "" {
                    self.displayNoUnitNumber(location: location)
                }
                else {
                    let streetName = location.locationName
                    location.locationName = "\(streetName) - Unit \(unitNumber)"
                    
                    // add to business database
                    DataService.instance.saveAddress(screenState: self.screenState, location: location)
                    
                    // add to user business bucket list
                    DataService.instance.saveAddressTo(user: self.signedInUser, location: location, screenState: self.screenState)
                    
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            }
            else {
                self.displayNoUnitNumber(location: location)
            }
            
        })
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(alertAction)
        alertView.addAction(alertCancel)
        
        self.present(alertView, animated: true) { 
            
        }

    }
    
    func displayNoUnitNumber(location: Location) {
        let alertView = UIAlertController(title: "No unit number added for", message: location.locationName, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .destructive, handler: { (action) in
            self.displayAddUnitToApartment(location: location)
        })
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertView.addAction(alertAction)
        alertView.addAction(alertCancel)
        
        self.present(alertView, animated: true) {
            
        }
    }
}
*/
