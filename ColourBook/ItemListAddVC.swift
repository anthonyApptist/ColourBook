//
//  ItemListVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-01.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class ItemListAddVC: CustomVC, UITableViewDelegate, UITableViewDataSource {
    
    let homeAddress = Address(name: "My House", address: "2 Shaver Court", lat: 43.131635, long: -79.265314)
    
    var addresses: [Address] = []
    
    let apptist = Business(name: "Apptist Inc", address: "46 Spadina Ave", lat: 41.714157, long: -71.365397)
    
    var businesses: [Business] = []
    
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet var topView: UIView?
    
    @IBOutlet var bottomView: UIView?
    
    @IBOutlet weak var titleLbl: UILabel?
    
    @IBOutlet var subTitleLbl: UILabel?
    
    @IBAction func addBtnPressed(_ sender: AnyObject) {

            performSegue(withIdentifier: "ConnectToNewItem", sender: self)
        
    }
    
    override func backBtnPressed(_ sender: AnyObject) {
        
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func scanBtnPressed(_ sender: AnyObject) {
        
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")
        
        present(scanView!, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addresses = [homeAddress]
        
        businesses = [apptist]
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(false)
        
        if self.screenState == .business {
            
            self.businesses = [apptist]
            self.subTitleLbl?.text = "my businesses"
            
        } else if self.screenState == .homes {
            self.addresses = [homeAddress]
            self.subTitleLbl?.text = "my addresses"
            
        }
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.reloadData()
        
        titleLbl?.text = titleString

        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        if self.screenState == .business {
            
            cell.titleLbl?.text = self.businesses[indexPath.row].name
            
        } else if self.screenState == .homes {
            
            cell.titleLbl?.text = self.addresses[indexPath.row].name
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ConnectToListItem", sender: self)
        
        let row = indexPath.row
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        
        
        if segue.identifier == "ConnectToListItem" {

        
            if self.screenState == .business {
                
                let row = tableView?.indexPathForSelectedRow?.row

                let item = businesses[row!]
                
                
                    if let detail = segue.destination as? ItemListEditVC {

                    detail.businessItem = item
                    detail.screenState = screenState
                    detail.titleLbl?.text = item.name
                }
                } else if self.screenState == .homes {
                
                let row = tableView?.indexPathForSelectedRow?.row
                
                let item = addresses[row!]
            
                        if let detail = segue.destination as? ItemListEditVC {
                            
                            detail.addressItem = item
                            detail.screenState = screenState
                            detail.titleLbl?.text = item.name

                        }
                    }
        }
            
        
        

    }
    
    
    
}
