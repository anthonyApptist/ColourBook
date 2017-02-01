//
//  CategoriesListVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2017-01-31.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit

class CategoriesListVC: CustomVC, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellItem", for: indexPath)
        
        return cell
    }
    
    
}
