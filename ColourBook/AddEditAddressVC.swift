//
//  AddEditAddressVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-06.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import MapKit

class AddEditAddressVC: CustomVC, MKMapViewDelegate, UISearchBarDelegate {
    
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
    
    @IBOutlet weak var textField: UITextField?
    
    @IBOutlet weak var map: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    let locationManager = CLLocationManager()
    
    var searchedCoordinates: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveBtn.alpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        titleLbl?.text = setAddEditAddressTitle(screenState: screenState)
        
        self.saveBtn.addTarget(self, action: #selector(self.saveBtnPressed(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)

        textField?.delegate = self
        
        map.delegate = self
    
        displayCurrentLocation()

    }
    
    @IBAction func showSearchBar(_ sender: AnyObject) {
        map.showsUserLocation = false
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
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
            
            
            if self.screenState == .business {
                
                if let detail = segue.destination as? AddEditImageVC {
                    /*
                    detail.businessItem = businessItem
                    detail.screenState = screenState
                    */
                }
            } else if self.screenState == .homes {
                
                if let detail = segue.destination as? AddEditImageVC {
                    /*
                    detail.addressItem = addressItem
                    detail.screenState = screenState
                    */
                }
            }
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField?.resignFirstResponder()
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
            
            self.setNewLocation(locationName: locationName!, postalCode: postalCode!, image: image, name: "")
            
            // add to business database
            DataService.instance.saveLocation(screenState: self.screenState, location: self.location!)
            
            // add to user business bucket list
            DataService.instance.saveLocationTo(user: self.signedInUser, location: self.location!, screenState: self.screenState)
        
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
            let image = ""
            self.setNewLocation(locationName: locationName!, postalCode: postalCode!, image: image, name: "")
            self.displayLocationAddAlertController(location: self.location!)
        })
    }
    
    func displayLocationAddAlertController(location: Location) {
        let alertView = UIAlertController(title: "Is this your current location", message: location.locationName, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .destructive, handler: { (action) in
            
            // add to business database
            DataService.instance.saveLocation(screenState: self.screenState, location: location)
            
            // add to user business bucket list
            DataService.instance.saveLocationTo(user: self.signedInUser, location: location, screenState: self.screenState)
            
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
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
}
