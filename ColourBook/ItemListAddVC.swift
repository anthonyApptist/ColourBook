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
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            if self.screenState == .business {
                
                // get businesses from user account
                
                let signedInUser = AuthService.instance.getSignedInUser()
                
                let signedInUserUID = signedInUser.uid
                
                let businessRef = DataService.instance.usersRef.child(signedInUserUID).child("businessDashboard")
                
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
                            
                            self.tableView?.reloadData()
                        }
                    }
                    
                })
                
                self.subTitleLbl?.text = "my businesses"
                
                
            } else if self.screenState == .homes {
                
                // get addresses from user account
                
                let signedInUser = AuthService.instance.getSignedInUser()
                
                let signedInUserUID = signedInUser.uid
                
                let addressRef = DataService.instance.usersRef.child(signedInUserUID).child("addressDashboard")
                
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
                            
                            self.tableView?.reloadData()
                        }
                    }
                    
                })
                
                self.subTitleLbl?.text = "my addresses"
            
                
            }
            
        }
        
        DispatchQueue.main.async {
            print("This is run on the main queue, after the previous code in outer block")
            
            self.tableView?.reloadData()
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
        
     //   tableView?.reloadData()
        
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
                    businesses.remove(at: (indexPath as NSIndexPath).row)
                }
                
            } else if screenState == .homes {
                
                if (addresses.count) > 0 {
                    addresses.remove(at: (indexPath as NSIndexPath).row)
                }
                
                
            }
            
            //enter firebase logic here to delete data from list
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
