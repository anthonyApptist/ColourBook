//
//  ItemListSettingsVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-08.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class ItemListEditVC: CustomVC, UITableViewDelegate, UITableViewDataSource {

    var currentIndex: Int = 0
    
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet var topView: UIView?
    
    @IBOutlet var bottomView: UIView?
    
    @IBOutlet weak var titleLbl: UILabel?
        
    @IBOutlet var subTitleLbl: UILabel?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dashboardVC = segue.destination as? MyDashboardVC {
            
            dashboardVC.currentPage = currentIndex
            
        }
    }
    
    @IBAction func settingsBtnPressed(_ sender: AnyObject) {
        
        if titleString == "personal" {
            performSegue(withIdentifier: "ConnectToImageSettings", sender: self)
        } else if titleString == "business" {
            performSegue(withIdentifier: "ConnectToMenuSettings", sender: self)
        } 
        
    }
    
    
    @IBAction func backBtnPressed(_ sender: AnyObject) {
        
        if titleString == "business" {
            currentIndex = 0
            performSegue(withIdentifier: "BackToItemAdd", sender: self)
        } else if titleString == "personal" {
            currentIndex = 1
            performSegue(withIdentifier: "BackToDashboard", sender: self)
        }
        
    }
    
    @IBAction func scanBtnPressed(_ sender: AnyObject) {
        
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")
        
        present(scanView!, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
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
        
        return cell
    }
    
    


}
