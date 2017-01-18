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
    
    // selected location 
    
    var selectedLocation: String?
    
    // products
    
    var products = [ScannedProduct]()
    
    var colour: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl?.adjustsFontSizeToFitWidth = true
    
        tableView?.delegate = self
        tableView?.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(false)
        
        products = []
        
        // access user database
        self.getPaint(screenState: self.screenState, user: self.signedInUser, location: self.selectedLocation)
        
        
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            
        cell.titleLbl?.text = self.products[indexPath.row].productType
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        performSegue(withIdentifier: "ShowListDetail", sender: nil)
        
    }
    
    //DELETE ROWS
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let upcCode = self.products[indexPath.row].upcCode
            
            let locationName = selectedLocation
            
            // remove from database
            DataService.instance.removeScannedProductFor(user: self.signedInUser, screeenState: self.screenState, barcode: upcCode, location: locationName)
            
            //remove from table view list
            self.products.remove(at: (indexPath as NSIndexPath).row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
 
    //DELETE ROWS

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if (self.products.count) > 0 {
            if(indexPath as NSIndexPath).row >= (self.products.count) {
                return .insert
            } else {
                return .delete
            }
        }
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        
        if segue.identifier == "ShowListDetail" {
            
            var item: ScannedProduct
            
            let row = tableView?.indexPathForSelectedRow?.row
                
            item = self.products[row!]
            
            if let detail = segue.destination as? ItemListDetailVC {
                detail.detailItem = item
                detail.colour = item.colour
                detail.screenState = screenState
            }
        }
        if segue.identifier == "ConnectToMenuSettings" {
            
            if let detail = segue.destination as? SettingsVC {
                
                detail.selectedLocation = self.selectedLocation
                detail.screenState = screenState
            }
        }
        
        if segue.identifier == "ConnectToImageSettings" {
            
            if let detail = segue.destination as? AddEditImageVC {
            
                detail.screenState = screenState
                
            }
            
        }
        
    }
    
    // MARK: - Get Barcodes
    
    func getPaint(screenState: ScreenState, user: User, location: String?) {
        
        let productsRef = DataService.instance.usersRef.child(user.uid)
        
        productsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            user.items = []
            
            if screenState == .personal {
                if snapshot.hasChild("name") {
                    let name = snapshot.childSnapshot(forPath: "name").value as! String
                    self.titleLbl?.text = name
                    
                    if snapshot.hasChild(PersonalDashboard) {
                        for child in snapshot.childSnapshot(forPath: PersonalDashboard).childSnapshot(forPath: Barcodes).children.allObjects {
                            let paintProfile = child as! FIRDataSnapshot
                            
                            let profile = paintProfile.value as? NSDictionary
                            let productType = profile?["productName"] as! String
                            let manufacturer = profile?["manufacturer"] as! String
                            let upcCode = paintProfile.key
                            let image = profile?["image"] as! String
                            let colourForPaint = profile?["colour"] as! String
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colourForPaint)
                            
                            user.items.append(product)
                            
                        }
                        
                        let items = user.items as! [ScannedProduct]
                        self.products.append(contentsOf: items)
                        
                        self.tableView?.reloadData()
                    }
                    else {
                        user.items = []
                    }

                }
                
                else {
                    
                    self.titleLbl?.text = ""
                    
                    if snapshot.hasChild(PersonalDashboard) {
                        for child in snapshot.childSnapshot(forPath: PersonalDashboard).childSnapshot(forPath: Barcodes).children.allObjects {
                            let paintProfile = child as! FIRDataSnapshot
                            
                            let profile = paintProfile.value as? NSDictionary
                            let productType = profile?["productName"] as! String
                            let manufacturer = profile?["manufacturer"] as! String
                            let upcCode = paintProfile.key
                            let image = profile?["image"] as! String
                            let colourForPaint = profile?["colour"] as! String
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colourForPaint)
                            
                            user.items.append(product)
                            
                        }
                        
                        let items = user.items as! [ScannedProduct]
                        self.products.append(contentsOf: items)
                        
                        self.tableView?.reloadData()

                    }
                    else {
                        user.items = []
                    }
                }
            }
            else {
                
                if screenState == .business {
                    // get items
                    for child in snapshot.childSnapshot(forPath: BusinessDashboard).childSnapshot(forPath: self.selectedLocation!).childSnapshot(forPath: Barcodes).children.allObjects {
                        let paintProfile = child as! FIRDataSnapshot
                        
                        let profile = paintProfile.value as? NSDictionary
                        let productType = profile?["productName"] as! String
                        let manufacturer = profile?["manufacturer"] as! String
                        let upcCode = paintProfile.key
                        let image = profile?["image"] as! String
                        let colourForPaint = profile?["colour"] as! String
                        let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colourForPaint)
                        
                        user.items.append(product)
                    }
                    
                    let items = user.items as! [ScannedProduct]
                    self.products.append(contentsOf: items)
                    
                    self.tableView?.reloadData()

                }
                else if screenState == .homes {
                    
                    if snapshot.childSnapshot(forPath: AddressDashboard).childSnapshot(forPath: self.selectedLocation!).hasChild("name") {
                        
                    }
                    else {
                        
                    }
                    
                    // get items
                    for child in snapshot.childSnapshot(forPath: AddressDashboard).childSnapshot(forPath: self.selectedLocation!).childSnapshot(forPath: Barcodes).children.allObjects {
                        let paintProfile = child as! FIRDataSnapshot
                        
                        let profile = paintProfile.value as? NSDictionary
                        let productType = profile?["productName"] as! String
                        let manufacturer = profile?["manufacturer"] as! String
                        let upcCode = paintProfile.key
                        let image = profile?["image"] as! String
                        let colourForPaint = profile?["colour"] as! String
                        let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colourForPaint)
                        
                        user.items.append(product)
                    }
                    
                    let items = user.items as! [ScannedProduct]
                    self.products.append(contentsOf: items)
                    
                    self.tableView?.reloadData()
                }
            
            }
            
            // Error
        }, withCancel: { (error) in
            print(error.localizedDescription)
            user.items = []
        })
        
    }
    
    func getBarcodesRefFor(user: User, screenState: ScreenState, location: String?) {
    
        if screenState == .personal {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(PersonalDashboard).child(Barcodes)
        }
        else if screenState == .business {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(BusinessDashboard).child(location!).child(Barcodes)
        }
        else if screenState == .homes {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user.uid).child(AddressDashboard).child(location!).child(Barcodes)
        }
    }
}



