//
//  ItemListVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-01.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ItemListAddVC: CustomVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet var topView: UIView?
    
    @IBOutlet var bottomView: UIView?
    
    @IBOutlet weak var titleLbl: UILabel?
    
    @IBOutlet var subTitleLbl: UILabel?
    
    var selectedLocation: Location? = nil

    @IBOutlet var settingsBtn: UIButton!
    
    @IBAction func addAddressBtnPressed(_ sender: AnyObject) {
        
        let map = GoogleMap()
        map.screenState = self.screenState
        
        self.present(map, animated: true, completion: nil)
        
    }
    
    @IBAction func settingsBtnPressed(_ sender: AnyObject) {

        performSegue(withIdentifier: "ConnectToBusinessSettings", sender: self)
        
    }
    
    // model
    var locations = [Location]()
    
    // business data
    var businessImages = [String:String]()
    
    // address data
    var userLocationItems = [Location:[[String:[[ScannedProduct:String]]]]]()
    var databaseLocations = [Location:[[String:[[ScannedProduct:String]]]]]()
    
    // list for category lists
    var categoryItems = [String:[ScannedProduct]]()
    
    /*
    override func backBtnPressed(_ sender: AnyObject) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    */
    
    @IBAction func scanBtnPressed(_ sender: AnyObject) {
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")

        present(scanView!, animated: true, completion: nil)
    }
    
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
        
        locations = []
        self.getLocationLists(screenState: self.screenState, user: self.signedInUser)
        self.showActivityIndicator()
        
        if self.screenState == .business {
            self.subTitleLbl?.text = "my businesses"
        } else if self.screenState == .homes {
            self.subTitleLbl?.text = "my addresses"
        }
        titleLbl?.text = titleString
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.locations.count)
        return self.locations.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        cell.titleLbl?.text = locations[indexPath.row].locationName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "ConnectToCategories", sender: self)
    
    }

    //DELETE ROWS
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let locationName = locations[indexPath.row].locationName
            
            DataService.instance.removeLocationFor(user: self.signedInUser, screenState: self.screenState, locationName: locationName)
            
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
        }
    }
        if segue.identifier == "ConnectToImageSettingsBusiness" {
            
            if let detail = segue.destination as? AddEditImageVCBusiness {
                
                detail.selectedLocation = self.selectedLocation
                detail.screenState = screenState
                
            }
        }

        
    }

}

