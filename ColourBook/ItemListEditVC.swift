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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl?.adjustsFontSizeToFitWidth = true
        
        setTitleLabelTextFor()
        
        // access user database
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            self.getPaintArray(screenState: self.screenState, user: self.signedInUser, location: self.selectedLocation)
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(false)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        DispatchQueue.main.async {
            
            self.products = self.signedInUser.items as! [ScannedProduct]
            
            self.tableView?.reloadData()

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
            
        cell.titleLbl?.text = self.products[indexPath.row].upcCode
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        performSegue(withIdentifier: "ShowListDetail", sender: nil)
        
    }
    
    //DELETE ROWS
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if editingStyle == .delete {
                
                let upcCode = self.products[indexPath.row].upcCode
                
                let locationName = selectedLocation
                
                // remove from database
                DataService.instance.removeScannedProductFor(user: self.signedInUser, screeenState: self.screenState, barcode: upcCode, location: locationName)
                
                //remove from table view list
                self.signedInUser.items.remove(at: (indexPath as NSIndexPath).row)
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
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
    
    // set title label for screen state

    func setTitleLabelTextFor() {
        
        if screenState == .personal {
            
            titleLbl?.text = self.signedInUser.name
            
        } else if screenState == .business || screenState == .homes {
            
            titleLbl?.text = selectedLocation
            
        }
    }

    
    // MARK: - Get Barcodes
    
    func getPaintArray(screenState: ScreenState, user: User, location: String?) {
        
        getBarcodesRefFor(user: user, screenState: screenState, location: location)
        
        let productsRef = DataService.instance.generalRef
        
        productsRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            user.items = []
            
            for child in snapshot.children.allObjects {
                
                let paintProfile = child as! FIRDataSnapshot
                
                let profile = paintProfile.value as? NSDictionary
                
                let productType = profile?["product"] as! String
                
                let manufacturer = profile?["manufacturer"] as! String
                
                let upcCode = paintProfile.key
                
                let image = profile?["image"] as! String
                
                let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image)
                
                user.items.append(product)
                
            }
            
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



