//
//  SelectAddressVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 16/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SelectAddressVC: CustomVC, UITableViewDelegate, UITableViewDataSource {
    
    // product profiles
    
    var barcode: String?
    
    var productProfile: [String:Any] = [:]
    
    var locations = [Location]()
    
    var tableView: UITableView!
    
    var name: UILabel!
    
    var addButton: UIButton?
    
    var selectedItems: [Int:String] = [:]
    
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
        
        DispatchQueue.global(qos: .background).async {
            
            self.getLocationLists(screenState: self.screenState, user: self.signedInUser)
            
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            print("This is run on the main queue, after the previous code in outer block")
            
            self.locations = self.signedInUser.items as! [Location]
            
            self.tableView?.reloadData()
            
            print(self.locations)
        }
        
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
        cell.textLabel?.text = self.locations[indexPath.row].locationName
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
            let selectedItems = self.locations[indexPath.row]
            cell?.accessoryType = .checkmark
            self.selectedItems.updateValue(selectedItems.locationName, forKey: indexPath.row)
            print(self.selectedItems)
        }
    }

    // MARK: - Add button function

    func addToSelectedRow() {
        
        // add to each business
        
        for value in self.selectedItems.values {
            // business location
            let location = value
            
            // save to the address in selected list
            DataService.instance.saveProductFor(user: self.signedInUser.uid, screenState: self.screenState, location: location, barcode: self.barcode!, value: self.productProfile)
            
            // save barcodes to public business entry
            DataService.instance.saveProductFor(location: location, screenState: self.screenState, barcode: self.barcode!, value: self.productProfile)
            
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func getLocationLists(screenState: ScreenState, user: User) {
        
        getLocationsRefFor(user: user, screenState: screenState)
        
        let locationsRef = DataService.instance.generalRef
        
        locationsRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            user.items = []
            for child in snapshot.children.allObjects {
                let addressProfile = child as! FIRDataSnapshot
                let profile = addressProfile.value as? NSDictionary
                let postalCode = profile?["postalCode"] as! String
                let image = profile?["image"] as! String
                let name = addressProfile.key
                let location = Location(locationName: name, postalCode: postalCode, image: image, name: "")
                
                user.items.append(location)
            }
        }, withCancel: { (error) in
            print(error.localizedDescription)
            user.items = []
        })
    }
    
    func getLocationsRefFor(user: User, screenState: ScreenState) {
        
        if screenState == .business {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard)
        }
        else if screenState == .homes {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(AddressDashboard)
        }
        
    }
}
