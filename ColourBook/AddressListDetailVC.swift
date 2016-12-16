//
//  MyAddressVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-06.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import MapKit

class AddressListDetailVC: CustomVC, MKMapViewDelegate {
    
    @IBOutlet weak var titleLbl: UILabel?
    
    @IBOutlet weak var addressLbl: UILabel?
    
    @IBOutlet weak var map: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    let locationManager = CLLocationManager()
    
    var location: CLLocation?
    
    var businessItem: Business?
    
    var addressItem: Address?
    
    var coordinate: CLLocationCoordinate2D?

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(false)
        
        
        map.delegate = self
        
        if screenState == .business {
            titleLbl?.text = businessItem?.businessName
            addressLbl?.text = businessItem?.businessLocation
            
            location = CLLocation(latitude: (businessItem?.latitude)!, longitude: (businessItem?.latitude)!)
            
            /*
            coordinate = businessItem?.coordinate
            location = CLLocation(latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!)
            */

        } else if screenState == .homes {
            
            titleLbl?.text = addressItem?.addressName
            addressLbl?.text = addressItem?.addressLocation
            
            location = CLLocation(latitude: (addressItem?.latitude)!, longitude: (addressItem?.longitude)!)
            
            /*
            coordinate = addressItem?.coordinate
            location = CLLocation(latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!)
            */
        }
        
        locationAuthStatus()


        // Do any additional setup after loading the view.
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        
        if segue.identifier == "ShowEditAddress" {
            
            
            if self.screenState == .business {
                
                if let detail = segue.destination as? AddEditAddressVC {
                    
                    detail.businessItem = businessItem
                    detail.screenState = screenState
                }
            } else if self.screenState == .homes {
                
                if let detail = segue.destination as? AddEditAddressVC {
                    
                    detail.addressItem = addressItem
                    detail.screenState = screenState
                }
            }
        }

    }

    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if self.coordinate != nil {
                self.createAnnotationForLocation(location!)
                self.centerMapOnLocation(location!)
            } else {
                let alert =  UIAlertController(title: "Error", message: "Could not find this address", preferredStyle: .alert)
                let closeAlert = UIAlertAction(title: "Continue", style: .cancel, handler: nil)
                alert.addAction(closeAlert)
                show(alert, sender: nil)
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annoView = MKPinAnnotationView()
        
        if annotation.isKind(of: AnnotationPin.self) {
            annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            if screenState == .business{
            annoView.pinTintColor = UIColor.red
            } else if screenState == .homes {
                annoView.pinTintColor = UIColor.green
            }
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

}
