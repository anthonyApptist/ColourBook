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
    
    @IBAction func addBtnPressed(_ sender: AnyObject) {

            performSegue(withIdentifier: "ConnectToNewItem", sender: self)
        
    }
    
    var locations = [Location]()
    
    
    override func backBtnPressed(_ sender: AnyObject) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func scanBtnPressed(_ sender: AnyObject) {
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")

        present(scanView!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        tableView?.dataSource = self

    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        
//        super.viewDidAppear(false)
        
        self.showActivityIndicator()
        
        self.getLocationLists(screenState: self.screenState, user: self.signedInUser)
        
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
        
        print(cell)
        
        print(locations[indexPath.row].locationName)
        
        if locations[indexPath.row].locationName.isEmpty {
            cell.titleLbl?.text = locations[indexPath.row].postalCode
        }
        else {
            cell.titleLbl?.text = locations[indexPath.row].locationName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "ConnectToListItem", sender: self)
    
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
    }
    
    func getLocationLists(screenState: ScreenState, user: User) {
        
        getLocationsRefFor(user: user, screenState: screenState)
        let locationsRef = DataService.instance.generalRef
        
        locationsRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects {
                let addressProfile = child as! FIRDataSnapshot
                let profile = addressProfile.value as? NSDictionary
                
                let postalCode = profile?["postalCode"] as! String
                let locationName = addressProfile.key
                
                let image = profile?["image"] as? String
                let name = profile?["name"] as? String
                
                let location = Location(locationName: locationName, postalCode: postalCode, image: image, name: name)
                
                self.locations.append(location)
            }
            self.tableView?.reloadData()
            self.hideActivityIndicator()
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
            self.hideActivityIndicator()
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
