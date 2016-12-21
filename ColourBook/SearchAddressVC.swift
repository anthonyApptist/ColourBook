//
//  SearchAddressViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class SearchAddressVC: UIViewController {
    
    var searchTextfield: UITextField!
    
    var searchButton: UIButton!
    
    var addressResultView: UIView!
    
    var defaultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search text field

        let searchTextFieldOrigin = CGPoint(x: 0, y: 20)
        
        let searchTextFieldSize = CGSize(width: view.frame.width, height: view.frame.height * 0.15)
        
        searchTextfield = UITextField(frame: CGRect(origin: searchTextFieldOrigin, size: searchTextFieldSize))
        
        searchTextfield.placeholder = "type address and press search"
        
        searchTextfield.textAlignment = .center
        
        view.addSubview(searchTextfield)
        
        // results view
        
        let resultViewOrigin = CGPoint(x: 0, y: searchTextfield.frame.maxY)
        
        let resultViewSize = CGSize(width: view.frame.width, height: view.frame.height - searchTextfield.frame.height)
        
        addressResultView = UIView(frame: CGRect(origin: resultViewOrigin, size: resultViewSize))
        
        view.addSubview(addressResultView)
        
        // default label 
        
        let defaultLabelOrigin = CGPoint(x: addressResultView.center.x - ((view.frame.width * 0.6)/2), y: addressResultView.center.y - ((addressResultView.frame.height * 0.15)/2))
        
        let defaultLabelSize = CGSize(width: view.frame.width * 0.6, height: addressResultView.frame.height * 0.15)
        
        defaultLabel = UILabel(frame: CGRect(origin: defaultLabelOrigin, size: defaultLabelSize))
        
        defaultLabel.text = "Search from our database"
        
        view.addSubview(defaultLabel)
        
        // search button
        
        let searchButtonOrigin = CGPoint(x: view.center.x - (view.frame.width * 0.6)/2, y: addressResultView.frame.maxY)
        
        let searchButtonSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.15)
        
        searchButton = UIButton(frame: CGRect(origin: searchButtonOrigin, size: searchButtonSize))
        
        searchButton.setTitle("Search", for: .normal)
        
        searchButton.setTitleColor(UIColor.black, for: .normal)
        
        searchButton.backgroundColor = UIColor.clear
        
        searchButton.layer.borderWidth = 5
        
        searchButton.layer.borderColor = UIColor.black.cgColor
        
        view.addSubview(searchButton)
    }
    
    func searchButtonFunction() {
        
        if (searchTextfield.text?.isEmpty)! {
            
            let alertView = UIAlertController.init(title: "No address typed in", message: "", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertView.addAction(alertAction)
            
            self.present(alertView, animated: true, completion: nil)
            
        }
        
        else {
            DataService.instance.addressRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
                let address = self.searchTextfield.text
                
                if (snapshot.hasChild(address!)) {
                    
                    

                }
            
                else {
                    
                    let alertView = UIAlertController.init(title: "Address not in database", message: "", preferredStyle: .alert)
                    
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertView.addAction(alertAction)
                    
                    self.present(alertView, animated: true, completion: nil)
                    
                }
            })
        }
        
    }

}
