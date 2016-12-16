//
//  ItemListVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-01.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

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
        
    
        
        if self.screenState == .business {
            
            // get businesses from user account
            
            let signedInUser = AuthService.instance.getSignedInUser()
            
            let signedInUserUID = signedInUser.uid
            
            DataService.instance.usersRef.child(signedInUserUID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.childSnapshot(forPath: "businessDashboard").hasChildren() {
                    
                }
                
            })
            
            self.subTitleLbl?.text = "my businesses"
            
        } else if self.screenState == .homes {
            
            // get addresses from user account
            
            self.subTitleLbl?.text = "my addresses"
    
        }
        
        addresses = []
        
        businesses = []
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(false)
        
        if self.screenState == .business {
            
            self.businesses = []
            self.subTitleLbl?.text = "my businesses"
            
        } else if self.screenState == .homes {
            
            self.addresses = []
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
            
            cell.titleLbl?.text = self.businesses[indexPath.row].businessName
            
        } else if self.screenState == .homes {
            
            cell.titleLbl?.text = self.addresses[indexPath.row].addressName
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ConnectToListItem", sender: self)
        
        let row = indexPath.row
        
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
