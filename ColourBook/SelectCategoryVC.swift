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
    
    var categories = [String]()

    var tableView: UITableView!
    
    var name: UILabel!
    
    var addButton: UIButton?
    
    var selectedItems: [Int:String] = [:]
    
    var location: Location?
    
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
        
        
        // table view
        tableView = UITableView(frame: CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.maxY - (view.frame.height * 0.1) - 70))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "item")
        tableView.alwaysBounceVertical = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // add button
        addButton = UIButton(frame: CGRect(x: view.center.x - ((view.frame.width)/2), y: view.frame.maxY - (view.frame.height * 0.1), width: view.frame.width, height: view.frame.height * 0.10))
        addButton?.setTitle("Add", for: .normal)
        addButton?.setTitleColor(UIColor.white, for: .normal)
        addButton?.backgroundColor = UIColor.black
        addButton?.addTarget(self, action: #selector(addToSelectedRow), for: .touchUpInside)
        
        // add to view
        view.addSubview(name)
        view.addSubview(tableView)
        view.addSubview(addButton!)

        self.getCategoriesFor(screenState: self.screenState, user: self.signedInUser, location: self.location)
            
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
        if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.deselectRow(at: indexPath, animated: true)
            cell?.accessoryType = .none
            self.selectedItems.removeValue(forKey: indexPath.row)
            print(self.selectedItems)
        }
        else {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            let selectedItems = self.categories[indexPath.row]
            cell?.accessoryType = .checkmark
            self.selectedItems.updateValue(selectedItems, forKey: indexPath.row)
            print(self.selectedItems)
        }
    }
    
    // MARK: - Add button function
    
    func addToSelectedRow() {
        
        // add to each business
        
        for value in self.selectedItems.values {
            // business location
            let category = value
            
            // save to the address in selected list
            DataService.instance.saveProductIn(user: self.signedInUser.uid, screenState: self.screenState, location: self.location?.locationName, barcode: self.barcode!, value: self.productProfile, category: category)
            
            // save barcodes to public business entry
            DataService.instance.saveProductIn(location: self.location?.locationName, screenState: self.screenState, barcode: self.barcode!, value: self.productProfile, category: category)
            
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func getCategoriesFor(screenState: ScreenState, user: User, location: Location?) {
        
        getCategoriesFrom(user: user, screenState: screenState, location: location)
        
        let categoriesRef = DataService.instance.generalRef
        
        categoriesRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects {
                let categoryName = child as! FIRDataSnapshot
                let category = categoryName.key
                
                self.categories.append(category)
            }
        }, withCancel: { (error) in
            print(error.localizedDescription)
            
        })
    }
    
    func getCategoriesFrom(user: User, screenState: ScreenState, location: Location?) {
        if screenState == .personal {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(PersonalDashboard)
        }
        if screenState == .business {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard).child((location?.locationName)!).child("categories")
        }
        else if screenState == .homes {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(AddressDashboard).child((location?.locationName)!).child("categories")
        }
        
    }
    
}
