//
//  SelectAddressVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 16/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import FirebaseDatabase

// Select Addresses and add products to
class SelectAddressVC: ColourBookVC, UITableViewDelegate, UITableViewDataSource {
    
    // product profiles
    var productProfile: PaintCan?
    
    // model
    var addresses: [Address]?
    var selectedLocation: Address?
    var selectedCategory: String = ""
    
    // view
    var tableView: UITableView!
    var name: UILabel!
    var addButton: UIButton?
    
    // business items add variables
    var business: String?
    
    // products to be transferred
    var transferProducts = [PaintCan]()
    
    // selector
    var selector: AddressSelector?
    
    // MARK: - Init
    init(selector: AddressSelector) {
        super.init(nibName: nil, bundle: nil)
        
        self.selector = selector
        self.selector?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButtonNeeded = true
        self.view.backgroundColor = UIColor.white
        
        // title label
        name = UILabel(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 50))
        name.textColor = UIColor.black
        name.textAlignment = .center
        name.backgroundColor = UIColor.white
        
        if screenState == .business {
            name.text = "My businesses"
        }
        if screenState == .homes {
            name.text = "My addresses"
        }
        if screenState == .transfer {
            name.text = "Transfer To..."
        }
        
        // table view
        tableView = UITableView(frame: CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.maxY - (view.frame.height * 0.1) - 70))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "address")
        tableView.alwaysBounceVertical = false
        tableView.allowsMultipleSelection = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // add button
        addButton = UIButton(frame: CGRect(x: view.center.x - ((view.frame.width)/2), y: view.frame.maxY - (view.frame.height * 0.1), width: view.frame.width, height: view.frame.height * 0.10))
        addButton?.setTitleColor(UIColor.white, for: .normal)
        addButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: (addButton?.frame.height)! * 0.4)
        addButton?.backgroundColor = UIColor.black
        
        if screenState == .transfer {
            addButton?.setTitle("Transfer to Category", for: .normal)
            addButton?.addTarget(self, action: #selector(transferTo), for: .touchUpInside)

        }
        else {
            addButton?.setTitle("Add", for: .normal)
            addButton?.addTarget(self, action: #selector(addToSelectedRow), for: .touchUpInside)
        }
        
        // add to view
        view.addSubview(name)
        view.addSubview(tableView)
        view.addSubview(addButton!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.selector?.retreive()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        // remove observers
        self.selector?.removeDatabaseObservers()
    }

    //MARK: tableview datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.addresses == nil {
            return 0
        }
        else {
            return (self.addresses?.count)!
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "address")
        let location = self.addresses?[indexPath.row]
        cell.textLabel?.text = location?.address
        return cell
    }

    //MARK: Tableview Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        self.selectedLocation = self.addresses?[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.none
        self.selectedLocation = nil
    }
    
    // MARK: - Transfer function
    func transferTo() {
        if self.selectedLocation == nil {
            self.createAlertController(title: "No address selected", message: nil)
        }
        else {
            let selectCategory = SelectCategoryVC()
            selectCategory.screenState = self.screenState
            selectCategory.locationName = self.selectedLocation?.address
            selectCategory.selectedCategory = self.selectedCategory
            selectCategory.transferProducts = self.transferProducts
            
            self.present(selectCategory, animated: true)
        }
    }

    // MARK: - Add button function
    func addToSelectedRow() {
        if self.selectedLocation == nil {
            self.createAlertController(title: "No address selected", message: "select an address")
        }
        else {
            // business state
            if self.screenState == .business {                
                self.productProfile?.businessAdded = self.business
                
                let selectCategory = SelectCategoryVC()
                selectCategory.screenState = self.screenState
                selectCategory.locationName = self.selectedLocation?.address
                selectCategory.productProfile = self.productProfile
                
                self.present(selectCategory, animated: true, completion: nil)
            }
            // homes state
            else {
                let selectCategory = SelectCategoryVC()
                selectCategory.screenState = self.screenState
                selectCategory.locationName = self.selectedLocation?.address
                selectCategory.productProfile = self.productProfile
            
                self.present(selectCategory, animated: true, completion: nil)
            }
        }

    }
}

extension SelectAddressVC: AddressSelect, ErrorLoading {
    // MARK: - Error Loading
    func loadError(_ error: Error) {
        self.createAlertController(title: "Error", message: error.localizedDescription)
    }
    
    // MARK: - Address Select
    func noBusinessProfile() {
        self.createAlertWithDismiss(title: "No business profile", message: "please complete one in business list")
    }
    
    func noAddresses() {
        self.createAlertWithDismiss(title: "No addresses added", message: "please add one in homes list")
    }
    
    func updateAddresses(_ addresses: [Address]) {
        self.addresses = addresses
        self.tableView.reloadData()
    }
    
    func updateBusiness(_ business: String) {
        self.business = business
    }
}
