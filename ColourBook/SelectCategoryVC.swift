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

// Select Category to add product to
class SelectCategoryVC: ColourBookVC, UITableViewDelegate, UITableViewDataSource {
    
    // product profiles
    var barcode: String?
    var productProfile: PaintCan?
    
    // model
    var categories: [String] = []
    var selectedCategory: String = ""
    var saveCategory: String = ""

    // view
    var tableView: UITableView!
    var name: UILabel!
    var addButton: UIButton?
    
    // address name
    var locationName: String?
    
    var transferProducts = [PaintCan]()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButtonNeeded = true
        
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

        self.getCategoriesFor(screenState: self.screenState, location: self.locationName)
    }
    
    //MARK: Tableview DataSource
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
    
    // MARK: Tableview Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let category = cell?.textLabel?.text!
        
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        self.saveCategory = category!
    }
    
    // Deselect
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
        self.saveCategory = ""
    }
    
    // MARK: - Transfer Function
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
                DataService.instance.transfer(products: self.transferProducts, location: self.locationName, category: personalCategory, destination: transferCategory)
                
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
//                let category = self.saveCategory
                
                // unique id for new item
                let uniqueID = DataService.instance.createUniqueID()
                self.productProfile?.uniqueID = uniqueID
                
                // save to selected personal category
                DataService.instance.savePaintCanToDashboard(screenState: self.screenState, location: self.locationName, product: self.productProfile!, category: self.saveCategory)
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            if self.screenState == .homes {
                // selected category
//                let category = self.saveCategory
                
                // create unique ID
                let uniqueID = "\(NSUUID().uuidString)"
                self.productProfile?.uniqueID = uniqueID
                
                // save to selected address category
                DataService.instance.savePaintCanToDashboard(screenState: self.screenState, location: self.locationName, product: self.productProfile!, category: self.saveCategory)
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

            }
            if self.screenState == .business {
//                let category = self.saveCategory
                
                // create unique ID
                let uniqueID = "\(NSUUID().uuidString)"
                self.productProfile?.uniqueID = uniqueID
                
                DataService.instance.savePaintCanToDashboard(screenState: self.screenState, location: self.locationName, product: self.productProfile!, category: self.saveCategory)
                
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Display None Selected
    func displayNoneSelected() {
        let alert = UIAlertController(title: "No category selected", message: "select a category", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCategoriesFor(screenState: ScreenState, location: String?) {
        let ref = getCategoriesFrom(screenState: screenState, location: location)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects {
                let categoryName = child as! DataSnapshot
                let category = categoryName.key
                
                self.categories.append(category)
            }
            // reload
            self.tableView.reloadData()
        }, withCancel: { (error) in
            print(error.localizedDescription)
            
        })
    }
    
    func getCategoriesFrom(screenState: ScreenState, location: String?) -> DatabaseReference {
        if screenState == .personal {
            let personalID = standardUserDefaults.value(forKey: "personal") as! String
            return DataService.instance.publicRef.child(kPersonalDashboard).child(personalID)
        }
        if screenState == .business {
            let businessID = standardUserDefaults.value(forKey: "business") as! String
            return DataService.instance.publicRef.child(kBusinessDashboard).child(businessID).child(location!).child("categories")
        }
        else if screenState == .homes || screenState == .transfer {
            let homeID = standardUserDefaults.value(forKey: "home") as! String
            return DataService.instance.publicRef.child(kHomeDashboard).child(homeID).child(location!).child("categories")
        }
        else {
            return DataService.instance.publicRef
        }
    }
    
}
