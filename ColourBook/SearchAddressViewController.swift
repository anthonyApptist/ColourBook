//
//  SearchAddressViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class SearchAddressViewController: UIViewController {
    
    var searchTextfield: UITextField!
    
    var searchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchTextFieldOrigin = CGPoint(x: view.center.x - (view.frame.width * 0.6)/2, y: view.frame.height * 0.4)
        
        let searchTextFieldSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.15)
        
        searchTextfield = UITextField.init(frame: CGRect(origin: searchTextFieldOrigin, size: searchTextFieldSize))
        
        searchTextfield.placeholder = "type address and press search"
        
        view.addSubview(searchTextfield)
        
        let searchButtonOrigin = CGPoint(x: view.center.x - (view.frame.width * 0.6)/2, y: view.frame.height * 0.75)
        
        let searchButtonSize = CGSize(width: view.frame.width * 0.6, height: view.frame.height * 0.15)
        
        searchButton = UIButton.init(frame: CGRect(origin: searchButtonOrigin, size: searchButtonSize))
        
        searchButton.setTitle("Search", for: .normal)
        
        searchButton.setTitleColor(UIColor.black, for: .normal)
        
        searchButton.backgroundColor = UIColor.clear
        
        searchButton.layer.borderWidth = 5
        
        searchButton.layer.borderColor = UIColor.black.cgColor
        
        view.addSubview(searchButton)
    }
    
    func searchButtonFunction() {
        
        if (searchTextfield.text?.isEmpty)! {
            
        }
        
        else {
            DataService.instance.addressRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
                let address = self.searchTextfield.text
                
                if (snapshot.hasChild(address!)) {
                    
                    let addressView = AddressViewController()
                    
                    addressView.address = address!
                    
                    
                    
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
