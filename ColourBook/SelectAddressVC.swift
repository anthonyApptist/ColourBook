//
//  SelectAddressVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 16/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SelectAddressVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // barcode from product and profile
    
    var barcode: String?
    
    var productProfile: Paint?
    
    var user: User!
    
    var titleLabel: UILabel!
    
    var tableView: UITableView!
    
    var addButton: UIButton?
    
    var addresses: [String] = []
    
    var businesses: [String] = []
    
    var state: String?
    
    var selectedItems: [Int:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: View
        
        self.view.backgroundColor = UIColor.white
        
        user = AuthService.instance.getSignedInUser()
        
        // title label
        
        titleLabel = UILabel.init(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 50))
        
        titleLabel.textColor = UIColor.black
        
        titleLabel.textAlignment = .center  
        
        titleLabel.backgroundColor = UIColor.white
        
        if state == "business" {
            titleLabel.text = "Businesses"
        }
        
        if state == "homes" {
            titleLabel.text = "Addresses"
        }
        
        
        // table view
        tableView = UITableView.init(frame: CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.maxY - (view.frame.height * 0.1) - 70))
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "item")
        
        tableView.alwaysBounceVertical = false
        
        
        // add button
        
        addButton = UIButton.init(frame: CGRect(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.maxY - (view.frame.height * 0.1), width: view.frame.width * 0.6, height: view.frame.height * 0.10))
    
        addButton?.setTitle("Add", for: .normal)
        
        addButton?.setTitleColor(UIColor.black, for: .normal)
        
        addButton?.backgroundColor = UIColor.white
        
        addButton?.addTarget(self, action: #selector(addToSelectedRow), for: .touchUpInside)
        
        
        // add to view
        
        view.addSubview(titleLabel!)
        
        view.addSubview(tableView)
        
        view.addSubview(addButton!)
        
        // grab arrays
    
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            if self.state == "business" {
                
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
                            
                            self.businesses.append(business.businessLocation)
                            
                            self.tableView?.reloadData()
                        }
                    }
                    
                })
    
                
            } else if self.state == "homes" {
                
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
                            
                            self.addresses.append(address.addressLocation)
                            
                            self.tableView?.reloadData()
                        }
                    }
                    
                })
                
                
            }
            
        }
        
        DispatchQueue.main.async {
            print("This is run on the main queue, after the previous code in outer block")
            
            self.tableView?.reloadData()
        }
        
        
    }

    //MARK: tableview datasource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int = 0
        
        if state == "business" {
            
            count = self.businesses.count
            
        }
        
        if state == "homes" {
            
            count = self.addresses.count
            
        }

        
        return count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "item")
        
        if state == "business" {
            
            cell.textLabel?.text = self.businesses[indexPath.row]
            
        }
        
        if state == "homes" {
            
            cell.textLabel?.text = self.addresses[indexPath.row]
            
        }
        
        return cell
        
    }

    //MARK: tableview delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if state == "business" {
            
            let selectedItems = self.businesses[indexPath.row]
            
            self.selectedItems.updateValue(selectedItems, forKey: indexPath.row)
        }
        
        if state == "homes" {
            
            if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
                
                tableView.deselectRow(at: indexPath, animated: true)
                
                cell?.accessoryType = .none
                
                self.selectedItems.removeValue(forKey: indexPath.row)
            }
            
            else {
                
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                
                let selectedItems = self.addresses[indexPath.row]
                
                cell?.accessoryType = .checkmark
                
                self.selectedItems.updateValue(selectedItems, forKey: indexPath.row)
                
            }
        }
        
    }
    /*
     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
     
     let cell = tableView.cellForRow(at: indexPath)
     
     if state == "business" {
     
     if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
     
     cell?.accessoryType = UITableViewCellAccessoryType.none
     
     self.selectedItems.remove(at: indexPath.row)
     }
     
     if state == "homes" {
     
     if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
     
     cell?.accessoryType = UITableViewCellAccessoryType.none
     
     self.selectedItems.remove(at: indexPath.row)
     }
     
     }
     }
     }
     */

    // add to selected row

    func addToSelectedRow() {
 
        if state == "business" {
 
            // add to each business
            
            let paint = self.productProfile
            
            let paintProfile: Dictionary<String, AnyObject> = ["manufacturer": paint!.manufacturer as AnyObject, "productName": paint!.productName as AnyObject, "category": paint!.category as AnyObject, "code": paint!.code as AnyObject, "image": paint!.image as AnyObject, "product": "Paint" as AnyObject, "colour": paint!.colour as AnyObject]
            
            // selected business
            
            for key in self.selectedItems.keys {
                
                // business location
                
                let business = self.selectedItems[key]
                
                // save to the address in selected list
                DataService.instance.usersRef.child(self.user.uid).child("businessDashboard").child(business!).child("barcodes").child(self.barcode!).child("productProfile").setValue(paintProfile)
                
            }
            
            
        }
        
        if state == "homes" {
            
            let paint = self.productProfile
            
            let paintProfile: Dictionary<String, AnyObject> = ["manufacturer": paint!.manufacturer as AnyObject, "productName": paint!.productName as AnyObject, "category": paint!.category as AnyObject, "code": paint!.code as AnyObject, "image": paint!.image as AnyObject, "product": "Paint" as AnyObject, "colour": paint!.colour as AnyObject]
            
            // selected addresses
            
            for key in self.selectedItems.keys {
                
                // address name
                
                let address = self.selectedItems[key]
                
                // save to the address in selected list
                DataService.instance.usersRef.child(self.user.uid).child("addressDashboard").child(address!).child("barcodes").child(self.barcode!).child("productProfile").setValue(paintProfile)
                
            }
            
            
        }
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    
    }

}
