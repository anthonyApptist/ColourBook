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
    
    // model
    var locations = [Location]()
    var selectedLocation: String = ""
    var selectedCategory: String = ""
    
    // view
    var tableView: UITableView!
    var name: UILabel!
    var addButton: UIButton?
    
    // products to be transferred
    var transferProducts = [Paint:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showActivityIndicator()
        
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
            name.text = "Transfer To..."
        }
        
        // table view
        tableView = UITableView(frame: CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.maxY - (view.frame.height * 0.1) - 70))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "address")
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
            addButton?.setTitle("Transfer to Category", for: .normal)
            addButton?.addTarget(self, action: #selector(transferTo), for: .touchUpInside)

        }
        else {
            addButton?.setTitle("Add", for: .normal)
            addButton?.addTarget(self, action: #selector(addToSelectedRow), for: .touchUpInside)
        }
        
        // add to view
        view.addSubview(name)
        view.addSubview(tableView)
        view.addSubview(addButton!)
        
        self.getLocationLists(screenState: self.screenState, user: self.signedInUser)
        self.showActivityIndicator()
    
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: "address")
        let location = self.locations[indexPath.row]
        cell.textLabel?.text = location.locationName
        return cell
    }

    //MARK: Tableview Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let locationName = self.locations[indexPath.row].locationName
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        self.selectedLocation = locationName
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.none
        self.selectedLocation = ""
    }
    
    // MARK: - Transfer function
    
    func transferTo() {
        
        if self.selectedLocation == "" {
            self.displayNoAddressSelected()
        }
        else {
            let selectCategory = SelectCategoryVC()
            selectCategory.screenState = self.screenState
            selectCategory.locationName = self.selectedLocation
            selectCategory.selectedCategory = self.selectedCategory
            
            selectCategory.transferProducts = self.transferProducts
            
            self.present(selectCategory, animated: true, completion: { 
                
            })
        }
    }

    // MARK: - Add button function

    func addToSelectedRow() {
        
        if self.selectedLocation == "" {
            self.displayNoAddressSelected()
        }
        else {
            let selectCategory = SelectCategoryVC()
            selectCategory.screenState = self.screenState
            selectCategory.locationName = self.selectedLocation
            self.present(selectedCategory, animated: true, completion: { 
                
            })
        }
    }
    
    // MARK: - Alerts
    
    func displayNoAddressSelected() {
        let alert = UIAlertController(title: "No address selected", message: "select an address", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayNoBusinessPage() {
        let alert = UIAlertController(title: "No business added", message: "Please complete the business profile page", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayNoAddresses() {
        let alert = UIAlertController(title: "No addresses added", message: "Please add an address in business list", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }


    
    // MARK: - Data
    
    func getLocationLists(screenState: ScreenState, user: User) {
        
        getLocationsRefFor(user: user, screenState: screenState)
        
        let locationsRef = DataService.instance.generalRef
        
        locationsRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if screenState == .business {
                if snapshot.hasChild("BusinessProfile") {
                    
                    // add the business
                
                    if snapshot.hasChild("addresses") {
                        
                        for child in snapshot.childSnapshot(forPath: "addresses").children.allObjects {
                            let addressProfile = child as! FIRDataSnapshot
                            let profile = addressProfile.value as? NSDictionary
                            let postalCode = profile?["postalCode"] as! String
                            let image = profile?["image"] as? String
                            let name = profile?["name"] as? String
                            let locationName = addressProfile.key
                            let location = Location(locationName: locationName, postalCode: postalCode)
                            location.image = image
                            location.name = name
                            
                            self.locations.append(location)
                        }
                        self.tableView.reloadData()
                        self.hideActivityIndicator()
                        
                    }
                    else {
                        self.displayNoAddresses()
                    }
                }
                else {
                    self.displayNoBusinessPage()
                }
            }
            if screenState == .homes || screenState == .transfer {
                
                if snapshot.hasChildren() {
                    
                    for child in snapshot.children.allObjects {
                        let addressProfile = child as! FIRDataSnapshot
                        let profile = addressProfile.value as? NSDictionary
                        let locationName = addressProfile.key
                        let postalCode = profile?["postalCode"] as! String
                        let image = profile?["image"] as? String
                        let name = profile?["name"] as? String
                        let location = Location(locationName: locationName, postalCode: postalCode)
                        
                        location.image = image
                        location.name = name
                        
                        self.locations.append(location)
                    }
                    self.tableView.reloadData()
                    self.hideActivityIndicator()
                    
                }
                else {
                    self.displayNoAddresses()
                }
            }
            
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
            self.hideActivityIndicator()
            self.displayNoAddresses()
        })
    }
    
    func getLocationsRefFor(user: User, screenState: ScreenState) {
        
        if screenState == .business {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard)
        }
        else if screenState == .homes || screenState == .transfer {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(AddressDashboard)
        }
    }
}
