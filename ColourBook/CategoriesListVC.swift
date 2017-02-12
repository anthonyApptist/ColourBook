//
//  CategoriesListVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2017-01-31.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit

class CategoriesListVC: CustomVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    var selectedLocation: Location?
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    
    let categories = ["Kitchen", "Livingroom", "Dining Room", "Bathroom", "Bedroom", "Garage", "Exterior", "Trim", "Hallway", "Interior re-paint", "Exterior re-paint", "Commercial", "Homebuilders", "Renovations"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    @IBAction func scanBtnPressed(_ sender: AnyObject) {
        
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")
        
        present(scanView!, animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
     //   app.window?.rootViewController = self

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let kWhateverHeightYouWant = 150
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(kWhateverHeightYouWant))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return categories.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryItemCell", for: indexPath) as! CategoryItemCell
        
            cell.titleLbl.text = categories[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.screenState == .personal {
            performSegue(withIdentifier: "ConnectToPersonal", sender: nil)
        }
        if self.screenState == .homes {
            performSegue(withIdentifier: "ConnectToAddresses", sender: nil)
        }
        if self.screenState == .business {
            performSegue(withIdentifier: "ConnectToBusiness", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        
        if segue.identifier == "ConnectToAddresses" {
            
            if let destVC = segue.destination as? ItemListEditVC {
                destVC.screenState = .homes
                destVC.selectedLocation = self.selectedLocation
            }
            
        }
        
        if segue.identifier == "ConnectToBusiness" {
            
            if let destVC = segue.destination as? ItemListEditVC {
                destVC.screenState = .business
                destVC.selectedLocation = self.selectedLocation
            }
            
        }
    }
    
    
}
