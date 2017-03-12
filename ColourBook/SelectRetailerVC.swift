//
//  SelectRetailerVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 6/3/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class SelectRetailerVC: CustomVC, UITableViewDataSource, UITableViewDelegate {
        
    // product profiles
    var barcode: String?
    var productProfile: [String:Any] = [:]
    
    // model
    var locations = [String]()
    var retailer: String = ""
    
    var selectedCategory: String!
    
    // view
    var tableView: UITableView!
    var name: UILabel!
    var addButton: UIButton?
    
    // business location name
    var business: Business?
    
    // address name
    var locationName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButtonNeeded = true
        
        //MARK: View
        
        self.view.backgroundColor = UIColor.white
        
        // title label
        
        name = UILabel(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 50))
        name.textColor = UIColor.black
        name.textAlignment = .center
        name.backgroundColor = UIColor.white
        
        
        if screenState == .business {
            name.text = "My businesses"
        }
        
        if screenState == .homes {
            name.text = "My addresses"
        }
        if screenState == .transfer {
            name.text = "Transfer to Category"
        }
        
        // table view
        tableView = UITableView(frame: CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.maxY - (view.frame.height * 0.1) - 70))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "item")
        tableView.alwaysBounceVertical = false
        tableView.allowsMultipleSelection = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // add button
        addButton = UIButton(frame: CGRect(x: view.center.x - ((view.frame.width)/2), y: view.frame.maxY - (view.frame.height * 0.1), width: view.frame.width, height: view.frame.height * 0.10))
        addButton?.setTitleColor(UIColor.white, for: .normal)
        addButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: (addButton?.frame.height)! * 0.4)
        addButton?.backgroundColor = UIColor.black
        
        addButton?.setTitle("Add", for: .normal)
        addButton?.addTarget(self, action: #selector(addToSelectedRow), for: .touchUpInside)
    
        
        // add to view
        view.addSubview(name)
        view.addSubview(tableView)
        view.addSubview(addButton!)
        
        self.getBusinesses(screenState: self.screenState, user: self.signedInUser, location: self.locationName)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    //MARK: tableview datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "item")
        cell.textLabel?.text = self.locations[indexPath.row]
        return cell
    }
    
    //MARK: tableview delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let retailerName = cell?.textLabel?.text!
        
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        self.retailer = retailerName!
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        self.retailer = ""
    }
    
    // MARK: - Add button function
    
    func addToSelectedRow() {
        
        if self.retailer == "" {
            
        }
        else {
            if self.screenState == .personal {
                // selected category
                let retailer = self.retailer
                
                // save to selected personal category
                DataService.instance.saveProductIn(user: self.signedInUser.uid, screenState: self.screenState, location: self.locationName, barcode: self.barcode!, value: self.productProfile, category: self.selectedCategory)
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            if self.screenState == .homes {
                // selected category
                let retailer = self.retailer
                
                // save to selected address category
                DataService.instance.saveProductIn(user: self.signedInUser.uid, screenState: self.screenState, location: self.locationName, barcode: self.barcode!, value: self.productProfile, category: self.selectedCategory)
                
                // save to public address category
                DataService.instance.saveProductFor(location: self.locationName, screenState: self.screenState, barcode: self.barcode!, value: self.productProfile, category: self.selectedCategory)
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                
            }
            if self.screenState == .business {
                let retailer = self.retailer
                
                self.productProfile.updateValue(business?.location ?? "", forKey: "addedBy")
                
                DataService.instance.saveProductIn(user: self.signedInUser.uid, screenState: self.screenState, location: self.locationName, barcode: self.barcode!, value: self.productProfile, category: self.selectedCategory)
                
                DataService.instance.saveProductFor(location: self.locationName, screenState: self.screenState, barcode: self.barcode!, value: self.productProfile, category: self.selectedCategory)
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func getBusinesses(screenState: ScreenState, user: User, location: String?) {
        
        let businessRef = DataService.instance.businessRef
        
        businessRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects {
                let business = child as! FIRDataSnapshot
                let businessName = business.key
                
                self.locations.append(businessName)
            }
            self.tableView.reloadData()
        }, withCancel: { (error) in
            print(error.localizedDescription)
            
        })
    }
    
}
