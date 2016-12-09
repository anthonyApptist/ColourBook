//
//  ItemListDetailVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-06.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class ItemListDetailVC: CustomVC {
    
    @IBOutlet var imgView: UIImageView?
    
    @IBOutlet var nameLbl: UILabel?
    
    @IBOutlet var productIdLbl: UILabel?
    
    @IBOutlet var hexCodeLbl: UILabel?
    
    
    @IBAction func backBtnPressed(_ sender: AnyObject) {
        
        if screenState == ScreenState.personal {
            performSegue(withIdentifier: "BackToItemEdit", sender: self)
        } else if screenState == ScreenState.business {
            performSegue(withIdentifier: "BackToItemAdd", sender: self)
        } else if screenState == ScreenState.homes {
            performSegue(withIdentifier: "BackToItemAdd", sender: self)
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
