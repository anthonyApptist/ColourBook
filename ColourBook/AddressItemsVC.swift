//
//  AddressItemsVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 9/1/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit

class AddressItemVC: ColourBookVC, UITableViewDataSource {
    
    var titleLabel: UILabel!
    var tableView: UITableView!
    
    var titleText: String?
    
    var products: [ScannedProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backButtonNeeded = true
        
        self.view.backgroundColor = UIColor.white
        
        // title label
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: self.backBtn.frame.maxY, width: view.frame.width, height: view.frame.height * 0.08))
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: titleLabel.frame.height * 0.40)
        titleLabel.text = self.titleText
        
        // table view
        tableView = UITableView(frame: CGRect(x: 0, y: titleLabel.frame.maxY, width: view.frame.width, height: view.frame.height - titleLabel.frame.height - self.backBtn.frame.height - 25))
        tableView.register(ProductCell.self, forCellReuseIdentifier: "item")
        tableView.alwaysBounceVertical = false
        tableView.dataSource = self
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
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
        /*
        let product = self.products[indexPath.row]
        
        cell.box1?.text = product.timestamp
        
        cell.box2?.text = "Paint"
        
        if let colour = product.colour {
            cell.box3?.backgroundColor = UIColor(hexString: colour.colourHexCode)
        }
        else {
            cell.box3?.backgroundColor = UIColor.white
        }
        
        cell.isUserInteractionEnabled = false
        */
        return cell
    }

}
