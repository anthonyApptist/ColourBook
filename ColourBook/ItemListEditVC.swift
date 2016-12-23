//
//  ItemListSettingsVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-08.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ItemListEditVC: CustomVC, UITableViewDelegate, UITableViewDataSource {
    
    var user: User!
    
    var userBusinessBucketList: [Paint] = []
    
    var userAddressBucketList: [Paint] = []
    
    var selectedBusiness: Business?
    
    var selectedAddress: Address?
    
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet var topView: UIView?
    
    @IBOutlet var bottomView: UIView?
    
    @IBOutlet var titleLbl: UILabel?
    
    @IBOutlet var subTitleLbl: UILabel?
    
    @IBAction func settingsBtnPressed(_ sender: AnyObject) {
        
        if screenState == ScreenState.personal {
            performSegue(withIdentifier: "ConnectToImageSettings", sender: self)
        } else if screenState == ScreenState.business || screenState == ScreenState.homes {
            performSegue(withIdentifier: "ConnectToMenuSettings", sender: self)
        }
        
    }
    
    
    @IBAction func scanBtnPressed(_ sender: AnyObject) {
        
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")
        
        present(scanView!, animated: true, completion: nil)
        
    }
    
    override func backBtnPressed(_ sender: AnyObject) {
        
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get user
        
        user = AuthService.instance.getSignedInUser()
        
        self.user.items = []
        
        // access user database
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            if self.screenState == .personal {
                
                // user personal dashboard database ref
                
                let personalItemsRef = DataService.instance.usersRef.child(self.user.uid).child("personalDashboard")
                
                personalItemsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    // check if user has barcodes added
                    
                    if snapshot.hasChild("barcodes") {
                        
                        for child in snapshot.children.allObjects {
                            
                            // snapshot of personal dashboard
                            
                            let product = child as? FIRDataSnapshot
                            
                            // product profile
                            
                            let productProfile = product?.value as? NSDictionary
                            
                            let category = productProfile?["category"] as? String ?? ""
                            
                            let productName = productProfile?["productName"] as? String ?? ""
                            
                            let code = productProfile?["code"] as? String ?? ""
                            
                            let image = productProfile?["image"] as? String ?? ""
                            
                            let upcCode = productProfile?["upcCode"] as? String ?? ""
                            
                            let manufacturer = productProfile?["manufacturer"] as? String ?? ""
                            
                            let colour = productProfile?["colour"] as? String ?? ""
                            
                            let paint = Paint(manufacturer: manufacturer, productName: productName, category: category, code: code, upcCode: upcCode, image: image, colour: colour)
                            
                            self.user.items.append(paint)
                            
                        }
                        
                        self.tableView?.reloadData()
                        
                    }
                    
                })
                
            }
            
            if self.screenState == .business {
                
                // user business dashboard database ref
                
                let businessItemsRef = DataService.instance.usersRef.child(self.user.uid).child("businessDashboard").child((self.selectedBusiness?.businessLocation)!)
                
                businessItemsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    // check if this business has barcodes
                    
                    if snapshot.hasChild("barcodes") {
                        
                        for barcodes in snapshot.childSnapshot(forPath: "barcodes").children.allObjects {
                            
                            let products = barcodes as? FIRDataSnapshot
                            
                            // product profile
                            
                            let barcodeData = products?.value as? NSDictionary
                            
                            let productProfile = barcodeData?["productProfile"] as? NSDictionary
                            
                            let category = productProfile?["category"] as? String ?? ""
                            
                            let productName = productProfile?["productName"] as? String ?? ""
                            
                            let code = productProfile?["code"] as? String ?? ""
                            
                            let image = productProfile?["image"] as? String ?? ""
                            
                            let upcCode = productProfile?["upcCode"] as? String ?? ""
                            
                            let manufacturer = productProfile?["manufacturer"] as? String ?? ""
                            
                            let colour = productProfile?["colour"] as? String ?? ""
                            
                            let paint = Paint(manufacturer: manufacturer, productName: productName, category: category, code: code, upcCode: upcCode, image: image, colour: colour)
                            
                            self.userBusinessBucketList.append(paint)
                            
                        }
                        
                        self.tableView?.reloadData()
                        
                    }
                    
                })
            }
            
            if self.screenState == .homes {
                
                // user address dashboard database ref
                
                let addressItemsRef = DataService.instance.usersRef.child(self.user.uid).child("addressDashboard").child((self.selectedAddress?.addressLocation)!)
                
                addressItemsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    // check if this address has barcodes
                    
                    if snapshot.hasChild("barcodes") {
                        
                        for barcodes in snapshot.childSnapshot(forPath: "barcodes").children.allObjects {
                            
                            let products = barcodes as? FIRDataSnapshot
                            
                            // product profile
                            
                            let barcodeData = products?.value as? NSDictionary
                            
                            let productProfile = barcodeData?["productProfile"] as? NSDictionary
                            
                            let category = productProfile?["category"] as? String ?? ""
                            
                            let productName = productProfile?["productName"] as? String ?? ""
                            
                            let code = productProfile?["code"] as? String ?? ""
                            
                            let image = productProfile?["image"] as? String ?? ""
                            
                            let upcCode = productProfile?["upcCode"] as? String ?? ""
                            
                            let manufacturer = productProfile?["manufacturer"] as? String ?? ""
                            
                            let colour = productProfile?["colour"] as? String ?? ""
                            
                            let paint = Paint(manufacturer: manufacturer, productName: productName, category: category, code: code, upcCode: upcCode, image: image, colour: colour)
                            
                            self.userAddressBucketList.append(paint)
                        }
                        
                        self.tableView?.reloadData()
                        
                    }
                    
                })
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(false)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        if self.titleString == "personal" {
            screenState = ScreenState.personal
        } else if self.titleString == "business" {
            screenState = ScreenState.business
        } else if self.titleString == "my homes" {
            screenState = ScreenState.homes
        }
        
        if screenState == .personal {
            
//            if user.items.count == 0 {
//                user.addItem(item: paintCan)
//                user.addItem(item: paintCan2)
//                user.addItem(item: paintCan3)
//            }
            
            titleLbl?.text = user.name
            
        } else if screenState == .business {
            
            
            
            /*
            if businessItem.items.count == 0 {
                businessItem.addItem(item: paintCan)
                businessItem.addItem(item: paintCan2)
                businessItem?.addItem(item: paintCan3)
            }
            
            */
            titleLbl?.text = selectedBusiness?.businessLocation
            
        } else if screenState == .homes {
            /*
            if addressItem?.items.count == 0 {
                addressItem?.addItem(item: paintCan)
                addressItem?.addItem(item: paintCan2)
                addressItem?.addItem(item: paintCan3)
            }
             */
            titleLbl?.text = selectedAddress?.addressLocation
            
        }
        
        DispatchQueue.main.async {
            // main queue
            self.tableView?.reloadData()

        }
        
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screenState == .personal {
            
            return (user.items.count)
            
        } else if screenState == .business {
            
            // get number of businesses
            
            return userBusinessBucketList.count
            
//            return (businessItem.items.count)!
            
        } else if screenState == .homes {
            
            // get number of addresses
            
            return userAddressBucketList.count
            
//            return (addressItem?.items.count)!
        }
            
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        
        if screenState == .personal {
            
            cell.titleLbl?.text = self.user.items[indexPath.row].productName
            
        } else if screenState == .business {
            
            cell.titleLbl?.text = self.userBusinessBucketList[indexPath.row].productName
            
        } else if screenState == .homes {
            
            cell.titleLbl?.text = self.userAddressBucketList[indexPath.row].productName
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        
        performSegue(withIdentifier: "ShowListDetail", sender: nil)
        
        
        
    }
    
    //DELETE ROWS
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if screenState == .personal {
                
                if user.items.count > 0 {
                    
                    let paint = self.user.items[indexPath.row]
                    
                    let upcCode = paint.upcCode
                    
                    user.items.remove(at: (indexPath as NSIndexPath).row)
                    
                    let userPersonalBarcodeRef = DataService.instance.usersRef.child(self.user.uid).child("personalDashboard").child("barcodes")
                    
                   userPersonalBarcodeRef.child(upcCode).removeValue(completionBlock: { (error, ref) in
                        if error != nil {
                        print(error?.localizedDescription ?? "")
                        }
                   })
                    
                }
                
            } else if screenState == .business {
                
                if (userBusinessBucketList.count) > 0 {
                    
                    let paint = userBusinessBucketList[indexPath.row]
                    
                    let upcCode = paint.upcCode
                    
                    userBusinessBucketList.remove(at: (indexPath as NSIndexPath).row)
                    
                    let userBusinessBarcodeRef = DataService.instance.usersRef.child(self.user.uid).child("businessDashboard").child((selectedBusiness?.businessLocation)!).child("barcodes")
                    
                    userBusinessBarcodeRef.child(upcCode).removeValue(completionBlock: { (error, ref) in
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                        }
                    })

                }

            } else if screenState == .homes {
            
            if (userAddressBucketList.count) > 0 {
                
                let paint = userAddressBucketList[indexPath.row]
                
                let upcCode = paint.upcCode
                
                userAddressBucketList.remove(at: (indexPath as NSIndexPath).row)
                
                let userAddressBarcodeRef = DataService.instance.usersRef.child(self.user.uid).child("addressDashboard").child((selectedAddress?.addressLocation)!).child("barcodes")
                
                userAddressBarcodeRef.child(upcCode).removeValue(completionBlock: { (error, ref) in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                    }
                })
                
            }
            
         
        }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
 
    //DELETE ROWS

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if screenState == .personal {
            
            if user.items.count > 0 {
                if(indexPath as NSIndexPath).row >= user.items.count {
                    return .insert
                } else {
                    return .delete
                }
            }
            
        } else if screenState == .business {
            
            if (userBusinessBucketList.count) > 0 {
                if(indexPath as NSIndexPath).row >= (userBusinessBucketList.count) {
                    return .insert
                } else {
                    return .delete
                }
            }
            
        } else if screenState == .homes {
            
            if (userAddressBucketList.count) > 0 {
                if(indexPath as NSIndexPath).row >= (userAddressBucketList.count) {
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
        
        if segue.identifier == "ShowListDetail" {
            
            var item: Any?
            
            let row = tableView?.indexPathForSelectedRow?.row
            
            if screenState == .personal {
                
                item = user.items[row!]
                
            } else if screenState == .business {
                
                item = userBusinessBucketList[row!]
                
            } else if screenState == .homes {
                
                item = userAddressBucketList[row!]
                
            }
            
            if let detail = segue.destination as? ItemListDetailVC {
                detail.detailItem = item as! Paint?
                detail.screenState = screenState
            }
        }
        
        if segue.identifier == "ConnectToMenuSettings" {
            
            
            if self.screenState == .business {
                
                
                if let detail = segue.destination as? SettingsVC {
                    
                    detail.selectedBusinessInfo = selectedBusiness
                    detail.screenState = screenState
                }
            } else if self.screenState == .homes {
                
                
                if let detail = segue.destination as? SettingsVC {
                    
                    detail.selectedAddressInfo = selectedAddress
                    detail.screenState = screenState
                }
            }
        }
        
        if segue.identifier == "ConnectToImageSettings" {
            
            
            
            if let detail = segue.destination as? AddEditImageVC {
                
                detail.userItem = user
                detail.screenState = screenState
                
            }
            
        }
        
    }
    
    
    
}

