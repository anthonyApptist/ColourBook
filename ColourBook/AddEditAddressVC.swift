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
    
    var businessItem: Business?
    
    var addressItem: Address?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)

        locationAuthStatus()
        
        titleLbl?.text = titleString

        textField?.delegate = self
        
        map.delegate = self
        
        self.saveBtn.addTarget(self, action: #selector(self.saveBtnPressed(_:)), for: .touchUpInside)

        if screenState == .business {
            
            titleLbl?.text = businessItem?.businessName
            
        } else if screenState == .homes {
            
            // set title
            
            /*
            titleLbl?.text = addressItem?.name
            */
        }


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
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowInfo" {
            
            
            if self.screenState == .business {
                
                if let detail = segue.destination as? AddEditImageVC {
                    
                    detail.businessItem = businessItem
                    detail.screenState = screenState
                }
            } else if self.screenState == .homes {
                
                if let detail = segue.destination as? AddEditImageVC {
                    
                    detail.addressItem = addressItem
                    detail.screenState = screenState
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

    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
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
        
        let user = AuthService.instance.getSignedInUser()
        
        let currentLocation = self.locationManager.location?.coordinate
        
        let geoCoder = CLGeocoder()
        
        let location = CLLocation(latitude: (currentLocation?.latitude)!, longitude: (currentLocation?.longitude)!)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            var placeMark: CLPlacemark!
            
            placeMark = placemarks?[0]
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? String {
                print(locationName)
                
                let address = Address(addressName: "Address", addressLocation: locationName, latitude: (currentLocation?.latitude)!, longitude: (currentLocation?.longitude)!, currentContracting: "", image: "")
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? String {
                print(street)
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                print(zip)
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                print(country)
            }
        
            
            
        })
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
        
        
    }

 
}
