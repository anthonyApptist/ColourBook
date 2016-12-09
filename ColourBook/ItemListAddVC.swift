//
//  ItemListVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-01.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class ItemListAddVC: CustomVC, UITableViewDelegate, UITableViewDataSource {
    
    var currentIndex: Int = 0
    
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet var topView: UIView?
    
    @IBOutlet var bottomView: UIView?
    
    @IBOutlet weak var titleLbl: UILabel?
    
    @IBOutlet var subTitleLbl: UILabel?
    
    @IBAction func addBtnPressed(_ sender: AnyObject) {

            performSegue(withIdentifier: "ConnectToNewItem", sender: self)
        
    }
    

    @IBAction func backBtnPressed(_ sender: AnyObject) {
        
        if screenState == ScreenState.business {
            currentIndex = 0
            performSegue(withIdentifier: "BackToDashboard", sender: self)
        } else if screenState == ScreenState.homes {
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
