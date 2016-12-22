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
    
    var user: User!
    
    var addresses: [Address] = []
    
    var businesses: [Business] = []
    
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet var topView: UIView?
    
    @IBOutlet var bottomView: UIView?
    
    @IBOutlet weak var titleLbl: UILabel?
    
    @IBOutlet var subTitleLbl: UILabel?
    
    @IBAction func addBtnPressed(_ sender: AnyObject) {

            performSegue(withIdentifier: "ConnectToNewItem", sender: self)
        
    }
    
    override func backBtnPressed(_ sender: AnyObject) {
        
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func scanBtnPressed(_ sender: AnyObject) {
        
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")
        
        present(scanView!, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = AuthService.instance.getSignedInUser()
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            if self.screenState == .business {
                
                // get businesses from user account
                
                let businessRef = DataService.instance.usersRef.child(self.user.uid).child("businessDashboard")
                
                businessRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    // check if user has a business list
                    if snapshot.hasChildren() {
                        for child in snapshot.children.allObjects {
                            
                            let businessDatabase = child as? FIRDataSnapshot
                            
                            let profile = businessDatabase?.value as? NSDictionary
                            
                            let businessProfile = profile?["businessProfile"] as? NSDictionary
                            
                            let businessName = businessProfile?["businessName"]
                            
                            let businessLocation = businessProfile?["businessLocation"]
                            
                            let latitude = businessProfile?["latitude"]
                            
                            let longitude = businessProfile?["longitude"]
                            
                            let image = businessProfile?["image"]
                            
                            let business = Business(businessName: businessName as! String, businessLocation: businessLocation as! String, latitude: latitude as! Double, longitude: longitude as! Double, image: image as! String)
                            
                            self.businesses.append(business)
                            
                        }
                        
                        // reload table view
                        
                        self.tableView?.reloadData()
                    }
                    
                })
                
                self.subTitleLbl?.text = "my businesses"
                
                
            } else if self.screenState == .homes {
                
                // get addresses from user account
                
                let addressRef = DataService.instance.usersRef.child(self.user.uid).child("addressDashboard")
                
                addressRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    // check if user has a business list
                    if snapshot.hasChildren() {
                        for child in snapshot.children.allObjects {
                            
                            let addressDatabase = child as? FIRDataSnapshot
                            
                            let profile = addressDatabase?.value as? NSDictionary
                            
                            let addressProfile = profile?["locationProfile"] as? NSDictionary
                            
                            let addressName = addressProfile?["addressName"]
                            
                            let addressLocation = addressProfile?["addressLocation"]
                            
                            let latitude = addressProfile?["latitude"]
                            
                            let longitude = addressProfile?["longitude"]
                            
                            let image = addressProfile?["image"]
                            
                            let address = Address(addressName: addressName as! String, addressLocation: addressLocation as! String, latitude: latitude as! Double, longitude: longitude as! Double, image: image as! String)
                            
                            self.addresses.append(address)
                        }
                        
                        // reload table view
                        
                        self.tableView?.reloadData()

                    }
                    
                })
                
                self.subTitleLbl?.text = "my addresses"
            
                
            }
            
        }
        
        DispatchQueue.main.async {
            print("This is run on the main queue, after the previous code in outer block")
        }
        
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(false)
        
        if self.screenState == .business {
            
            self.subTitleLbl?.text = "my businesses"
            
        } else if self.screenState == .homes {
            
            self.subTitleLbl?.text = "my addresses"
            
        }
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.reloadData()
        
        titleLbl?.text = titleString

        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if screenState == .business {
            
            return (businesses.count)
            
        } else if screenState == .homes {
            
            return (addresses.count)
        }
            
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        if self.screenState == .business {
            
            if self.businesses[indexPath.row].businessName.isEmpty {
                
                cell.titleLbl?.text = self.businesses[indexPath.row].businessLocation
                
            }
                
            else {
                
                cell.titleLbl?.text = self.businesses[indexPath.row].businessName
                
            }
            
        } else if self.screenState == .homes {
            
            if self.addresses[indexPath.row].addressName.isEmpty {
                
                cell.titleLbl?.text = self.addresses[indexPath.row].addressLocation
                
            }
                
            else {
                
                cell.titleLbl?.text = self.addresses[indexPath.row].addressName
                
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        performSegue(withIdentifier: "ConnectToListItem", sender: self)
    
        
    }

    //DELETE ROWS
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
           if screenState == .business {
                
                if (businesses.count) > 0 {
                    
                    // expected business to be deleted
                    
                    let businessToBeRemoved = businesses[indexPath.row]
                
                    // pending delete business location
                    
                    let businessToBeRemovedLocation = businessToBeRemoved.businessLocation
                    
                    // get user
                    
                    let signedInUser = AuthService.instance.getSignedInUser()
                    
                    // user uid
                    
                    let signedInUserUID = signedInUser.uid
                    
                    // user business database reference
                    
                    let userBusinessRef = DataService.instance.usersRef.child(signedInUserUID).child("businessDashboard")
                    
                    // remove business location
                    
                    userBusinessRef.child(businessToBeRemovedLocation).removeValue(completionBlock: { (error, ref) in
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                        }
                    })
                    
                    // remove from stored list
                    
                    self.businesses.remove(at: (indexPath as NSIndexPath).row)
                    
                }
                
            } else if screenState == .homes {
                
                if (addresses.count) > 0 {
                    
                    // address to be removed
                    
                    let addressToBeRemoved = addresses[indexPath.row]
                    
                    let addressToBeRemovedLocation = addressToBeRemoved.addressLocation
                    
                    let signedInUser = AuthService.instance.getSignedInUser()
                    
                    let signedInUserUID = signedInUser.uid
                    
                    // user
                    
                    let userAddressRef = DataService.instance.usersRef.child(signedInUserUID).child("addressDashboard")
                    
                    // remove address location
                    
                    userAddressRef.child(addressToBeRemovedLocation).removeValue(completionBlock: { (error, ref) in
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                        }
                    })
                    
                    //remove from stored list
                    self.addresses.remove(at: (indexPath as NSIndexPath).row)
                    
                }
                
                
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //DELETE ROWS
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    if screenState == .business {
            
            if (businesses.count) > 0 {
                if(indexPath as NSIndexPath).row >= (businesses.count) {
                    return .insert
                } else {
                    return .delete
                }
            }
            
        } else if screenState == .homes {
            
            if (addresses.count) > 0 {
                if(indexPath as NSIndexPath).row >= (addresses.count) {
                    return .insert
                } else {
                    return .delete
                    
                }
                
            }
        }
        return .none
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        
        
        if segue.identifier == "ConnectToListItem" {

            
            if self.screenState == .business {
                
                let row = tableView?.indexPathForSelectedRow?.row
                
                let selectedBusiness = businesses[row!]
                
                
                if let detail = segue.destination as? ItemListEditVC {
                    
                    // get paint items in selected business
                    
                    
                    // set the current business selected for next page
                    detail.selectedBusiness = selectedBusiness
                    
                    // send user info through
//                    detail.user = self.user
                    
                    /*
                     detail.userBusinessBucketList = item as? Paint
                     detail.screenState = screenState
                     detail.titleLbl?.text = item
                     */
                }
            } else if self.screenState == .homes {
                
                let row = tableView?.indexPathForSelectedRow?.row
                
                let selectedAddress = addresses[row!]
                
                if let detail = segue.destination as? ItemListEditVC {
                    
                    // get paint items in selected address
                    
                    
                    // set the current address selected for next page
                    detail.selectedAddress = selectedAddress
                    
                    // send user info through
//                    detail.user = self.user
                    
                    /*
                     detail.addressItem = item as! Address
                     detail.screenState = screenState
                     detail.titleLbl?.text = item.addressName
                     */
                }
            }
        }
        
        
        

    }
    
    
    
}
