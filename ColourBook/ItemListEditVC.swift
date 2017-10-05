//
//  ItemListSettingsVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-08.
//  Copyright © 2016 Apptist. All rights reserved.
//
import UIKit

// Lists items such as paint cans for a particular category
class ItemListEditVC: ColourBookVC, UITableViewDelegate, UITableViewDataSource {
    
    // Properties
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
    
    // MARK: - Transfer Items Btn Function
    @IBAction func transferItemsBtnPressed(_ sender: AnyObject) {
        if selectedProducts.isEmpty {
            self.createAlertController(title: "No items selected", message: "select at least one item")
        }
        else {
            // select address to transfer products to
            let selector = AddressSelector(screenState: .homes)
            let selectAddress = SelectAddressVC(selector: selector)
            selectAddress.selector?.delegate = selectAddress
            selectAddress.screenState = .homes
            selectAddress.transferProducts = self.selectedProducts
            selectAddress.screenState = .transfer
            selectAddress.selectedCategory = self.selectedCategory!
            
            self.present(selectAddress, animated: true, completion: nil)
        }
 
    }
    
    // MARK: - Select Item Btn Pressed
    @IBAction func selectItemBtnPressed(_ sender: AnyObject) {
        if(!selectionOn) {
        selectionOn = true
        self.transferItemBtn.isHidden = false
        self.selectItemBtn.isSelected = true
        
        } else if(selectionOn) {
            selectionOn = false
            self.transferItemBtn.isHidden = true
            self.selectItemBtn.isSelected = false
            /*
            for item in self.selectedProducts {
                let index = self.products.index(of: item)!
                let indexPath = IndexPath(row: index, section: 1)
                let cell = self.tableView?.cellForRow(at: indexPath)
                cell?.layer.borderWidth = 0.0
            }
             */
        }
        
    }
    
    // MARK: - Settings Btn Pressed
    @IBAction func settingsBtnPressed(_ sender: AnyObject) {
        
        if screenState == ScreenState.personal {
            performSegue(withIdentifier: "ConnectToImageSettings", sender: self)
        } else if screenState == ScreenState.business {
            performSegue(withIdentifier: "ConnectToImageSettingsBusiness", sender: self)
        } else if screenState == ScreenState.homes {
            performSegue(withIdentifier: "ConnectToImageSettings", sender: self)
        }
        
    }
    
    // MARK: - Scan Btn Pressed
    @IBAction func scanBtnPressed(_ sender: AnyObject) {
        
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")
        
        present(scanView!, animated: true, completion: nil)
        
    }
    
    /*    override func backBtnPressed(_ sender: AnyObject) {
     
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
 */
    
    // selected location
    var selectedLocation: Address? = nil
    var selectedCategory: String? = nil
    
    // products
    var products = [PaintCan]()
    var selectedProducts = [PaintCan]()
    
    // business images
    var businessImages = [String:String]()
    
    // MARK: - View Controller Lifecycle
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
//            self.titleLbl?.text = self.selectedLocation?.locationName
            self.subTitleLbl?.text = self.selectedCategory
        }
        if self.screenState == .personal {
            
        }
        
        titleLbl?.leadingAnchor.constraint(equalTo: self.backBtn.trailingAnchor, constant: 15).isActive = true
    }

    // MARK: - TableView DataSource
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
    
    // MARK: - TableView Delegate
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

    
    // delete action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = self.products[indexPath.row]
            
            let location = self.selectedLocation
            
            if self.screenState == .business {
                DataService.instance.removeScannedProductFor(screenState: self.screenState, uniqueID: product.uniqueID!, location: location?.address, category: self.selectedCategory!)
            }
            
            if self.screenState == .homes {
                DataService.instance.removeScannedProductFor(screenState: self.screenState, uniqueID: product.uniqueID!, location: location?.address, category: self.selectedCategory!)
            }
            
            self.deleteItem = true
            
            //remove from table view list
            self.products.remove(at: (indexPath as NSIndexPath).row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Back Btn Pressed
    override func backBtnPressed(_ sender: AnyObject) {
        if(self.deleteItem) {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: false, completion: nil)
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
            var item: PaintCan
            let row = tableView?.indexPathForSelectedRow?.row
            item = self.products[row!]
            
            if let detail = segue.destination as? ItemListDetailVC {
                detail.detailItem = item
                detail.screenState = screenState
                detail.currentCategory = self.selectedCategory
                detail.currentLocation = self.selectedLocation?.address
            }
        }
        /*
        if segue.identifier == "ConnectToMenuSettings" {
            if let detail = segue.destination as? SettingsVC {
                detail.selectedLocation = self.selectedLocation
                detail.screenState = screenState
            }
        }
         */
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
}



