//
//  ItemListSettingsVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-08.
//  Copyright © 2016 Apptist. All rights reserved.
//
import UIKit

class ItemListEditVC: CustomVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet var topView: UIView?
    
    @IBOutlet var bottomView: UIView?
    
    @IBOutlet var titleLbl: UILabel?
    
    @IBOutlet var subTitleLbl: UILabel?
    
    @IBOutlet var transferItemBtn: UIButton!
    
    @IBOutlet var selectItemBtn: UIButton!
    
    @IBOutlet var settingsBtn: UIButton!
    
    var selectionOn: Bool = false
    
    var deleteItem: Bool = false
    
    @IBAction func transferItemsBtnPressed(_ sender: AnyObject) {
        
        if selectedProducts.isEmpty {
            displayNoItemSelected()
        }
        else {
            let selectAddress = SelectAddressVC()
            selectAddress.screenState = .homes
            selectAddress.transferProducts = self.selectedProducts
            selectAddress.screenState = .transfer
            selectAddress.selectedCategory = self.selectedCategory!
            
            self.present(selectAddress, animated: true, completion: { 
                
            })
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
    /*    override func backBtnPressed(_ sender: AnyObject) {
        
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
 */
    
    // selected location
    var selectedLocation: Location? = nil
    var selectedCategory: String? = nil
    
    // products
    var products = [ScannedProduct]()
    var selectedProducts = [ScannedProduct]()
    
    var businessImages = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl?.adjustsFontSizeToFitWidth = true
    
        tableView?.delegate = self
        tableView?.dataSource = self
        
        if screenState == .searching {
            
        }
        
        if screenState == .personal {
            selectItemBtn.isHidden = false
        }
        else {
            selectItemBtn.isHidden = true
            selectItemBtn.isUserInteractionEnabled = false
        }
        
        if self.screenState == .searching {
            self.settingsBtn.isHidden = true
        } else {
            self.settingsBtn.isHidden = false
        }
        
        self.transferItemBtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(false)
        
        titleLbl?.adjustsFontSizeToFitWidth = true
        
        if self.screenState == .searching {
            self.titleLbl?.text = self.selectedLocation?.locationName
            self.subTitleLbl?.text = self.selectedCategory
        }
        if self.screenState == .personal {
            
        }
        
        titleLbl?.leadingAnchor.constraint(equalTo: self.backBtn.trailingAnchor, constant: 15).isActive = true

    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = self.products[indexPath.row]
        if self.screenState == .business || self.screenState == .homes || self.screenState == .searching {
            // check if business
            if let business = product.businessAdded {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContractorItemCell", for: indexPath) as! ContractorItemCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                cell.businessImage = businessImages[business]
                cell.setViewFor(product: product)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.setViewFor(product: product)
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.setViewFor(product: product)
            return cell
        }
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
                self.selectedProducts.append(product)
            }
            else {
                cell?.contentView.layer.borderWidth = 0.0
                
            }
        }
    }
    
    override func backBtnPressed(_ sender: AnyObject) {
        if(self.deleteItem) {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: false, completion: nil)
        }
    }

    // delete action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let product = self.products[indexPath.row]
            
            let location = self.selectedLocation
            
            if self.screenState == .business {
                DataService.instance.removeScannedProductForAddress(barcode: product.uniqueID!, location: location?.locationName, category: self.selectedCategory!)
            }
            
            if self.screenState == .homes {
                DataService.instance.removeProduct(barcode: product.uniqueID!, location: location?.locationName, category: self.selectedCategory!)

            }
            
            self.deleteItem = true
            
            // remove from database
            DataService.instance.removeScannedProductFor(user: self.signedInUser, screenState: self.screenState, barcode: product.uniqueID!, location: location?.locationName, category: self.selectedCategory!)
            
            //remove from table view list
            self.products.remove(at: (indexPath as NSIndexPath).row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
      
        }
    }
 
    // cell editing style

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if self.screenState == .homes {
            let product = self.products[indexPath.row]
            if product.businessAdded == nil {
                return .delete
            }
            else {
                return .none
            }
        }
        if self.screenState == .searching {
            return .none
        }
        else {
            return .delete
        }
    }
    
    // MARK: - Segue to Detail and Settings
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        
        /*
        if segue.identifier == "ConnectToTransferPage" {
            if let detail = segue.destination as? TransferToTableViewController {
                
            }
        }
 */
        if segue.identifier == "ShowListDetail" {
            var item: ScannedProduct
            let row = tableView?.indexPathForSelectedRow?.row
            item = self.products[row!]
            
            if let detail = segue.destination as? ItemListDetailVC {
                detail.detailItem = item
                detail.screenState = screenState
                detail.currentCategory = self.selectedCategory
                detail.currentLocation = self.selectedLocation?.locationName
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
                detail.signedInUser = self.signedInUser
            }
        }
        if segue.identifier == "ConnectToImageSettingsBusiness" {
            
            if let detail = segue.destination as? AddEditImageVCBusiness {
                
                detail.selectedLocation = self.selectedLocation
                detail.screenState = screenState
                
            }
        }
    }
    
    func displayNoItemSelected() {
        let alert = UIAlertController(title: "No item selected", message: "select at least one item", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}



