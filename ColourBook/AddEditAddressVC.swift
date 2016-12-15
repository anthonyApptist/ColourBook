//
//  AddEditAddressVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-06.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import MapKit

class AddEditAddressVC: CustomVC, MKMapViewDelegate {
    
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
            
            titleLbl?.text = businessItem?.name
            
        } else if screenState == .homes {
            
            titleLbl?.text = addressItem?.name
            
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
        
        
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
        
        
    }

 
}
