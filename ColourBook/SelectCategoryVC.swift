//
//  SelectCategoryVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 31/1/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class SelectCategoryVC: CustomVC, UITableViewDelegate, UITableViewDataSource {
    
    // product profiles
    var barcode: String?
    var productProfile: [String:Any] = [:]
    
    // model
    var categories = [String]()
    var selectedCategory: String = ""
    var saveCategory: String = ""

    // view
    var tableView: UITableView!
    var name: UILabel!
    var addButton: UIButton?
    
    // business location name
    var business: Business?
    
    // address name
    var locationName: String?
    
    var transferProducts = [Paint:String]()
    
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
        
        if screenState == .transfer {
            addButton?.setTitle("Transfer", for: .normal)
            addButton?.addTarget(self, action: #selector(transferFunction), for: .touchUpInside)
        }
        else {
            addButton?.setTitle("Add", for: .normal)
            addButton?.addTarget(self, action: #selector(addToSelectedRow), for: .touchUpInside)
        }
        
        // add to view
        view.addSubview(name)
        view.addSubview(tableView)
        view.addSubview(addButton!)

        self.getCategoriesFor(screenState: self.screenState, user: self.signedInUser, location: self.locationName)
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    //MARK: tableview datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "item")
        cell.textLabel?.text = self.categories[indexPath.row]
        return cell
    }
    
    //MARK: tableview delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let category = cell?.textLabel?.text!
        
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        self.saveCategory = category!
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        self.saveCategory = ""
    }
    
    func transferFunction() {
        if self.saveCategory == "" {
            self.displayNoneSelected()
        }
        else {
            if self.screenState == .transfer {
                // selected category
                let personalCategory = self.selectedCategory
                let transferCategory = self.saveCategory
                
                // save to selected address category
                DataService.instance.transfer(products: self.transferProducts, user: self.signedInUser, location: self.locationName, category: personalCategory, destination: transferCategory)
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Add button function
    
    func addToSelectedRow() {
        
        if self.saveCategory == "" {
            self.displayNoneSelected()
        }
        else {
            if self.screenState == .personal {
                // selected category
                let category = self.saveCategory
                
                // save to selected personal category
                DataService.instance.saveProductIn(user: self.signedInUser.uid, screenState: self.screenState, location: self.locationName, barcode: self.barcode!, value: self.productProfile, category: category)
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            if self.screenState == .homes {
                // selected category
                let category = self.saveCategory
                
                // save to selected address category
                DataService.instance.saveProductIn(user: self.signedInUser.uid, screenState: self.screenState, location: self.locationName, barcode: self.barcode!, value: self.productProfile, category: category)
                
                // save to public address category
                DataService.instance.saveProductFor(location: self.locationName, screenState: self.screenState, barcode: self.barcode!, value: self.productProfile, category: category)
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

            }
            if self.screenState == .business {
                let category = self.saveCategory
                
                self.productProfile.updateValue(business?.location ?? "", forKey: "addedBy")
                
                DataService.instance.saveProductIn(user: self.signedInUser.uid, screenState: self.screenState, location: self.locationName, barcode: self.barcode!, value: self.productProfile, category: category)
                
                DataService.instance.saveProductFor(location: self.locationName, screenState: self.screenState, barcode: self.barcode!, value: self.productProfile, category: category)
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func displayNoneSelected() {
        let alert = UIAlertController(title: "No category selected", message: "select a category", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCategoriesFor(screenState: ScreenState, user: User, location: String?) {
        
        getCategoriesFrom(user: user, screenState: screenState, location: location)
        
        let categoriesRef = DataService.instance.generalRef
        
        categoriesRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects {
                let categoryName = child as! FIRDataSnapshot
                let category = categoryName.key
                
                self.categories.append(category)
            }
            self.tableView.reloadData()
        }, withCancel: { (error) in
            print(error.localizedDescription)
            
        })
    }
    
    func getCategoriesFrom(user: User, screenState: ScreenState, location: String?) {
        if screenState == .personal {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(PersonalDashboard)
        }
        if screenState == .business {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard).child("addresses").child(locationName!).child("categories")
        }
        else if screenState == .homes || screenState == .transfer {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(AddressDashboard).child(locationName!).child("categories")
        }
        
    }
    
}
