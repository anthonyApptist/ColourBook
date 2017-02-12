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
    
    @IBOutlet var transferItemBtn: UIButton!
    
    @IBOutlet var selectItemBtn: UIButton!
    
    var selectionOn: Bool = false
    
    var cellSelectedCount: Int = 0
    
    @IBAction func transferItemsBtnPressed(_ sender: AnyObject) {
        
        print(self.cellSelectedCount)
        
        if(self.cellSelectedCount > 0) {
            performSegue(withIdentifier: "ConnectToTransferPage", sender: nil)
        } else if(self.cellSelectedCount == 0) {
            
        }
    }
    
    @IBAction func selectItemBtnPressed(_ sender: AnyObject) {
        
        if(!selectionOn) {
        selectionOn = true
        self.transferItemBtn.isHidden = false
        self.selectItemBtn.isSelected = true
        
        } else if(selectionOn) {
            selectionOn = false
            self.transferItemBtn.isHidden = true
            self.selectItemBtn.isSelected = false
        }
        
    }
    
    @IBAction func settingsBtnPressed(_ sender: AnyObject) {
        
        if screenState == ScreenState.personal {
            performSegue(withIdentifier: "ConnectToImageSettings", sender: self)
        } else if screenState == ScreenState.business {
            performSegue(withIdentifier: "ConnectToImageSettingsBusiness", sender: self)
        } else if screenState == ScreenState.homes {
            performSegue(withIdentifier: "ConnectToImageSettings", sender: self)
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
    
    var selectedProducts = [Int:ScannedProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl?.adjustsFontSizeToFitWidth = true
    
        tableView?.delegate = self
        tableView?.dataSource = self
        
        if screenState == .personal {
            selectItemBtn.isHidden = false
        }
        else {
            selectItemBtn.isHidden = true
            selectItemBtn.isUserInteractionEnabled = false
        }
        
        self.transferItemBtn.isHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(false)
        
        self.showActivityIndicator()
        
        products = []
        
        if screenState == .personal {
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
        cell.selectionStyle = UITableViewCellSelectionStyle.none    
        let product = self.products[indexPath.row]
        cell.setViewFor(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if(!selectionOn) {
            performSegue(withIdentifier: "ShowListDetail", sender: nil)
        } else {
            let cell = tableView.cellForRow(at: indexPath)
            let product = self.products[indexPath.row]
            
            if cell?.contentView.layer.borderWidth == 0 {
                cell?.contentView.layer.borderWidth = 2.0
                cell?.contentView.layer.borderColor = UIColor.blue.cgColor
                self.selectedProducts.updateValue(product, forKey: indexPath.row)
            }
            else {
                cell?.contentView.layer.borderWidth = 0.0
                self.selectedProducts.removeValue(forKey: indexPath.row)
                
            }
        }
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
        
        if segue.identifier == "ConnectToImageSettingsBusiness" {
            
            if let detail = segue.destination as? AddEditImageVCBusiness {
                
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
                self.signedInUser.name = name
                
                
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
                    
                    self.hideActivityIndicator()
                }
                    
                    // no products
                else {
                    self.hideActivityIndicator()
                    
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
                    self.hideActivityIndicator()
                }
                // no products
                else {
                    self.hideActivityIndicator()
                }

            }
            // Error
        }, withCancel: { (error) in
            print(error.localizedDescription)
            self.hideActivityIndicator()
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
                self.hideActivityIndicator()
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
                
                self.hideActivityIndicator()
                
                // Error
            }, withCancel: { (error) in
                print(error.localizedDescription)
                self.hideActivityIndicator()
            })
            
        }
    }

}



