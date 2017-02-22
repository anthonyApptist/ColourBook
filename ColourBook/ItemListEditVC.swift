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
    
    var selectionOn: Bool = false
    
    @IBAction func transferItemsBtnPressed(_ sender: AnyObject) {
        
        if selectedProducts.isEmpty {
            displayNoItemSelected()
        }
        else {
            
            let selectAddress = SelectAddressVC()
            selectAddress.screenState = .homes
            
            for index in self.selectedProducts.keys {
                let timestamp = self.selectedProducts[index]?.timestamp
                let paint = self.paintProducts[index]
                self.selectedPaint.updateValue(timestamp!, forKey: paint)
            }
            
            selectAddress.transferProducts = self.selectedPaint
            selectAddress.screenState = .transfer
            selectAddress.selectedCategory = self.selectedCategory!
            
            self.present(selectAddress, animated: true, completion: { 
                
            })
            /*
            performSegue(withIdentifier: "ConnectToTransferPage", sender: nil)
            */
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
    
    // paint products
    
    var paintProducts = [Paint]()
    var selectedPaint = [Paint:String]()
    
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
        
        if self.screenState == .searching {
            self.titleLbl?.text = self.selectedLocation?.locationName
            self.subTitleLbl?.text = self.selectedCategory
        }
        else {
            self.getInfo(user: self.signedInUser, screenState: self.screenState, location: self.selectedLocation?.locationName)
            self.showActivityIndicator()
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
   //     let cell = tableView.dequeueReusableCell(withIdentifier: "ContactorItemCell", for: indexPath) as! ContractorItemCell
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
            DataService.instance.removeScannedProductFor(user: self.signedInUser, screenState: self.screenState, barcode: upcCode, location: location?.locationName, category: self.selectedCategory!)
            
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



