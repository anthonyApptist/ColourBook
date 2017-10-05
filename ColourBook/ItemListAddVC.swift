//
//  ItemListVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-01.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import FirebaseDatabase

// List of addresses for business or homes page
class ItemListAddVC: ColourBookVC, UITableViewDelegate, UITableViewDataSource {
    
    // Properties
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet var topView: UIView?
    @IBOutlet var bottomView: UIView?
    @IBOutlet weak var titleLbl: UILabel?
    @IBOutlet var subTitleLbl: UILabel?
    @IBOutlet var settingsBtn: UIButton!
    @IBOutlet var addressBtn: UIButton!
    
    var selectedLocation: Address? = nil

    // MARK: - Add Address Button
    @IBAction func addAddressBtnPressed(_ sender: AnyObject) {
        // google map
        let map = GoogleMap()
        map.screenState = self.screenState
        
        // present google map
        self.present(map, animated: true, completion: nil)
    }
    
    // MARK: - Business Settings (Business Profile)
    @IBAction func settingsBtnPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "ConnectToBusinessSettings", sender: self)
    }
    
    var ref: DatabaseReference?
    
    // business data
    var businessImages = [String:String]()
    
    // model
    var locations = [Address]()
    var allDatabaseLocation = [String]()
    
    // location data
    var locationItems = [String:[ScannedProduct]]()
//    var databaseLocationItems = [String:[ScannedProduct]]()
    
    // address data (location name key)
    var userLocations = [String:[String:[ScannedProduct]]]()
//    var databaseLocations = [String:[String:[ScannedProduct]]]()
    
    // list for category lists
    var categories = [String]()
    var categoryItems = [String:[ScannedProduct]]()
    
    // MARK: - Scan btn Pressed
    @IBAction func scanBtnPressed(_ sender: AnyObject) {
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")

        present(scanView!, animated: true, completion: nil)
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        if self.screenState == .homes {
            self.settingsBtn.isHidden = true
            
        } else {
            self.settingsBtn.isHidden = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        // set database reference
//        self.getLocationLists(screenState: self.screenState, user: self.signedInUser)
        
        if self.screenState == .business {
            self.subTitleLbl?.text = "my businesses"
            if (standardUserDefaults.bool(forKey: "businessCreated")) {
                if let businessID = standardUserDefaults.value(forKey: "business") as? String {
                    self.ref = DataService.instance.businessDashboardRef.child(businessID)
                    self.getLocationLists(screenState: self.screenState)
                }
            }
            // no business profile
            else {
                self.createAlertController(title: "No profile", message: "create a business profile to get started")
                self.addressBtn.isUserInteractionEnabled = false
            }
        } else if self.screenState == .homes {
            self.subTitleLbl?.text = "my addresses"
            if let homeID = standardUserDefaults.value(forKey: "home") as? String {
                self.ref = DataService.instance.homeDashboardRef.child(homeID)
                self.getLocationLists(screenState: self.screenState)
            }
            // no addresses added
            else {
                self.createAlertController(title: "Click the add address button to start adding", message: nil)
            }
        }
        titleLbl?.text = titleString
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.ref?.removeAllObservers()
    }
    
    // MARK: - UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.locations.count)
        return self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.titleLbl?.text = self.locations[indexPath.row].address
        let location = self.locations[indexPath.row]
        if let name = location.name {
            cell.titleLbl?.text = name
        }
        return cell
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ConnectToCategories", sender: self)
    }

    //DELETE ROWS
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // delete
        if editingStyle == .delete {
            let locationName = locations[indexPath.row].address
            
            // remove from user list
            DataService.instance.removeLocationFor(screenState: self.screenState, locationName: locationName!)
            
            //remove from stored list
            locations.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //DELETE ROWS
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if (locations.count) > 0 {
            if(indexPath as NSIndexPath).row >= (locations.count) {
                return .insert
            } else {
                return .delete
            }
        }
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        
        if segue.identifier == "ConnectToListItem" {
            let row = tableView?.indexPathForSelectedRow?.row
            let selectedLocation = locations[row!]
            if let detail = segue.destination as? ItemListEditVC {
                detail.selectedLocation = selectedLocation
            }
        }
        
        if segue.identifier == "ConnectToCategories" {
            let row = tableView?.indexPathForSelectedRow?.row
            let selectedLocation = locations[row!]
            
            if let detail = segue.destination as? CategoriesListVC {
                detail.selectedLocation = selectedLocation
                detail.screenState = self.screenState
                detail.businessImages = self.businessImages
                
                // model to send over
                self.categories = []
                self.categoryItems = [:]
                
                for categories in (selectedLocation.categoryItems?.keys)! {
                    self.categories.append(categories)
                }
                detail.categories = self.categories
                detail.categoriesItems = selectedLocation.categoryItems!
                
//                let userDictionaryOfItems = self.userLocations[selectedLocation.locationName]
                
                /*
                for category in (userDictionaryOfItems?.keys)! {
                    self.categories.append(category)
                }
                
                self.categoryItems = userDictionaryOfItems!
                detail.categories = self.categories
                detail.categoriesItems = self.categoryItems
                 */
                
            }
        }

}
}
