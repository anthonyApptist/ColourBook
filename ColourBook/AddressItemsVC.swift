//
//  AddressItemsVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/1/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class AddressItemVC: CustomVC, UITableViewDataSource {
    
    var titleLabel: UILabel!
    var tableView: UITableView!
    
    var products: [ScannedProduct] = []
    
    var selectedLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButtonNeeded = true
        
        // title label
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 65, width: view.frame.width, height: view.frame.height * 0.08))
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: titleLabel.frame.height * 0.40)
        titleLabel.text = selectedLocation
        
        // table view
        tableView = UITableView(frame: CGRect(x: 0, y: titleLabel.frame.maxY, width: view.frame.width, height: view.frame.height - titleLabel.frame.height - 65))
        tableView.register(ProductCell.self, forCellReuseIdentifier: "item")
        tableView.alwaysBounceVertical = false
        tableView.dataSource = self
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        let clear = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - tableView.frame.height - titleLabel.frame.height))
        clear.backgroundColor = UIColor.white
        view.addSubview(clear)
        
        self.getPaintArray(screenState: self.screenState, location: self.selectedLocation)
    }
    
    // MARK: - Table View Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "item") as! ProductCell
        
        let product = products[indexPath.row]
        
        cell.barcode.text = product.upcCode
        
        if product.colour == "" {
            cell.colour.backgroundColor = UIColor.white
        }
        else {
            cell.colour.backgroundColor = UIColor(hexString: product.colour!)
        }
        
        cell.isUserInteractionEnabled = false
        
        return cell
        
    }
    
    // MARK: - Get Barcodes
    
    func getPaintArray(screenState: ScreenState, location: String?) {
        
        getBarcodesRefFor(screenState: screenState, location: location)
        
        let productsRef = DataService.instance.generalRef
        
        productsRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children.allObjects {
                
                let paintProfile = child as! FIRDataSnapshot
                let profile = paintProfile.value as? NSDictionary
                let productType = profile?["product"] as! String
                let manufacturer = profile?["manufacturer"] as! String
                let upcCode = paintProfile.key
                let image = profile?["image"] as! String
                let colourForPaint = profile?["colour"] as! String
                
                let product = ScannedProduct(productType: productType, manufacturer: manufacturer, upcCode: upcCode, image: image, colour: colourForPaint)
                
                self.products.append(product)
                
            }
            
            self.tableView?.reloadData()
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
            self.products = []
        })
        
    }
    
    func getBarcodesRefFor(screenState: ScreenState, location: String?) {
        
        if screenState == .business {
            DataService.instance.generalRef = DataService.instance.businessRef.child(location!).child(Barcodes)
        }
        else if screenState == .homes {
            DataService.instance.generalRef = DataService.instance.addressRef.child(location!).child(Barcodes)
        }
        
    }

}
