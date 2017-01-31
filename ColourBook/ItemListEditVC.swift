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
    
    var selectedLocation: Location?
    
    // products
    
    var products = [ScannedProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl?.adjustsFontSizeToFitWidth = true
    
        tableView?.delegate = self
        tableView?.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(false)
        
        products = []
        
        if screenState == .personal {
            // access user database
            self.getPaint(screenState: self.screenState, user: self.signedInUser)
        }
        if screenState == .business || screenState == .homes {
            self.getPaintFor(location: self.selectedLocation!, screenState: self.screenState)
        }
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
            
            let location = self.selectedLocation
            
            // remove from database
            DataService.instance.removeScannedProductFor(user: self.signedInUser, screeenState: self.screenState, barcode: upcCode, location: location?.locationName)
            
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
    
    // MARK: - Segue to Detail and Settings
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        
        if segue.identifier == "ShowListDetail" {
            
            var item: ScannedProduct
            
            let row = tableView?.indexPathForSelectedRow?.row
                
            item = self.products[row!]
            
            if let detail = segue.destination as? ItemListDetailVC {
                detail.detailItem = item
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
            
                detail.selectedLocation = self.selectedLocation
                detail.screenState = screenState
                
            }
            
        }
        
    }
    
    // MARK: - Get Barcodes
    
    func getPaint(screenState: ScreenState, user: User) {
        
        let productsRef = DataService.instance.usersRef.child(user.uid)
        
        productsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
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
                        let timestamp = profile?["timestamp"] as! String
                        
                        // check for colour
                        if paintProfile.hasChild("colour") {
                            let colourProfile = profile?["colour"] as? NSDictionary
                            let colourName = colourProfile?["colourName"] as! String
                            let hexcode = colourProfile?["hexcode"] as! String
                            let manufacturerID = colourProfile?["manufacturerID"] as! String
                            let manufacturer = colourProfile?["manufacturer"] as! String
                            let productCode = colourProfile?["productCode"] as! String
                            
                            let colour = Colour(manufacturerID: manufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: manufacturer)
                            
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colour, timestamp: timestamp)
                            
                            self.products.append(product)
                        }
                        else {
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                            
                            self.products.append(product)
                        }
                    }
                    
                    self.tableView?.reloadData()
                }
                    
                    // no products
                else {
                    
                    
                }
                
            }
                // no display name
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
                        let timestamp = profile?["timestamp"] as! String
                        
                        // check for colour
                        if paintProfile.hasChild("colour") {
                            let colourProfile = profile?["colour"] as? NSDictionary
                            let colourName = colourProfile?["colourName"] as! String
                            let hexcode = colourProfile?["hexcode"] as! String
                            let manufacturerID = colourProfile?["manufacturerID"] as! String
                            let manufacturer = colourProfile?["manufacturer"] as! String
                            let productCode = colourProfile?["productCode"] as! String
                            
                            let colour = Colour(manufacturerID: manufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: manufacturer)
                            
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colour, timestamp: timestamp)
                            
                            self.products.append(product)
                        }
                        else {
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                            
                            self.products.append(product)
                        }
                    }
                    
                    self.tableView?.reloadData()
                    
                }
                    // no products
                else {
                    
                }
            }
            // Error
        }, withCancel: { (error) in
            print(error.localizedDescription)
            
        })
    }

    func getPaintFor(location: Location, screenState: ScreenState) {
        
        if screenState == .business {
            
            let productsRef = DataService.instance.usersRef.child(self.signedInUser.uid)
            
            productsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.childSnapshot(forPath: BusinessDashboard).childSnapshot(forPath: location.locationName).hasChild("name") {
                    let name = snapshot.childSnapshot(forPath: "name").value as! String
                    self.titleLbl?.text = name
                }
                else {
                    self.titleLbl?.text = location.locationName
                }
                
                if snapshot.childSnapshot(forPath: BusinessDashboard).childSnapshot(forPath: location.locationName).hasChild(Barcodes) {
                    
                    // get items
                    for child in snapshot.childSnapshot(forPath: BusinessDashboard).childSnapshot(forPath: location.locationName).childSnapshot(forPath: Barcodes).children.allObjects {
                        let paintProfile = child as! FIRDataSnapshot
                        
                        let profile = paintProfile.value as? NSDictionary
                        let productType = profile?["productName"] as! String
                        let manufacturer = profile?["manufacturer"] as! String
                        let upcCode = paintProfile.key
                        let image = profile?["image"] as! String
                        let timestamp = profile?["timestamp"] as! String

                        // check for colour
                        if paintProfile.hasChild("colour") {
                            let colourProfile = profile?["colour"] as? NSDictionary
                            let colourName = colourProfile?["colourName"] as! String
                            let hexcode = colourProfile?["hexcode"] as! String
                            let manufacturerID = colourProfile?["manufacturerID"] as! String
                            let manufacturer = colourProfile?["manufacturer"] as! String
                            let productCode = colourProfile?["productCode"] as! String
                            
                            let colour = Colour(manufacturerID: manufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: manufacturer)
                            
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colour, timestamp: timestamp)
                            
                            self.products.append(product)
                        }
                        else {
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                            
                            self.products.append(product)
                        }
                    }
                }
                
                self.tableView?.reloadData()
                
            })
            
        }
        else if screenState == .homes {
            
            let productsRef = DataService.instance.usersRef.child(self.signedInUser.uid)
            
            productsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.childSnapshot(forPath: AddressDashboard).childSnapshot(forPath: location.locationName).hasChild("name") {
                    let name = snapshot.childSnapshot(forPath: "name").value as! String
                    self.titleLbl?.text = name
                }
                else {
                    self.titleLbl?.text = location.locationName
                }
                
                if snapshot.childSnapshot(forPath: AddressDashboard).childSnapshot(forPath: location.locationName).hasChild(Barcodes) {
                    
                    // get items
                    for child in snapshot.childSnapshot(forPath: BusinessDashboard).childSnapshot(forPath: location.locationName).childSnapshot(forPath: Barcodes).children.allObjects {
                        let paintProfile = child as! FIRDataSnapshot
                        
                        let profile = paintProfile.value as? NSDictionary
                        let productType = profile?["productName"] as! String
                        let manufacturer = profile?["manufacturer"] as! String
                        let upcCode = paintProfile.key
                        let image = profile?["image"] as! String
                        let timestamp = profile?["timestamp"] as! String
                        
                        // check for colour
                        if paintProfile.hasChild("colour") {
                            let colourProfile = profile?["colour"] as? NSDictionary
                            let colourName = colourProfile?["colourName"] as! String
                            let hexcode = colourProfile?["hexcode"] as! String
                            let manufacturerID = colourProfile?["manufacturerID"] as! String
                            let manufacturer = colourProfile?["manufacturer"] as! String
                            let productCode = colourProfile?["productCode"] as! String
                            
                            let colour = Colour(manufacturerID: manufacturerID, productCode: productCode, colourName: colourName, colourHexCode: hexcode, manufacturer: manufacturer)
                            
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colour, timestamp: timestamp)
                            
                            self.products.append(product)
                        }
                        else {
                            let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: nil, timestamp: timestamp)
                            
                            self.products.append(product)
                        }
                    }
                }
                
                self.tableView?.reloadData()
                
                // Error
            }, withCancel: { (error) in
                print(error.localizedDescription)
            })
            
        }
    }

}



