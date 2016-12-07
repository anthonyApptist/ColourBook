//
//  ItemListVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-01.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class ItemListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var colour = UIColor()
    
    var currentIndex: Int = 0
    
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet var topView: UIView?
    
    @IBOutlet var bottomView: UIView?
    
    @IBOutlet weak var titleLbl: UILabel?
    
    var titleString: String = ""
    
    @IBOutlet var subTitleLbl: UILabel?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dashboardVC = segue.destination as? MyDashboardVC {
            
           dashboardVC.currentPage = currentIndex
            
        }
    }
    

    @IBAction func backBtnPressed(_ sender: AnyObject) {
        
        if titleString == "personal" {
            currentIndex = 0
        } else if titleString == "business" {
            currentIndex = 1
        } else if titleString == "my homes" {
            currentIndex = 2
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
        
        self.topView?.backgroundColor = colour
        self.bottomView?.backgroundColor = colour
        
        
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
