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
    
    // data
    var selectedLocation: Location? = nil
    var categoriesItems = [String:[ScannedProduct]]()
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.showActivityIndicator()
        
//        DataService.instance.usersRef.child(self.signedInUser.uid).child(PersonalDashboard).child("Living Room").setValue("")
        
        self.getCategoriesFor(screenState: self.screenState, user: self.signedInUser, location: selectedLocation)

    }
    
    @IBAction func scanBtnPressed(_ sender: AnyObject) {
        
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")
        
        present(scanView!, animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let kWhateverHeightYouWant = 150
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(kWhateverHeightYouWant))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return self.categories.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryItemCell", for: indexPath) as! CategoryItemCell
        let categoryName: String = self.categories[indexPath.row]
        cell.titleLbl.text = categoryName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.screenState == .personal {
            
            let cell = collectionView.cellForItem(at: indexPath)
            
            performSegue(withIdentifier: "ConnectToPersonal", sender: cell)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if self.screenState == .personal {
            if let categoryItemCell = sender as? CategoryItemCell {
                if segue.destination is ItemListEditVC {
                    let category = categoryItemCell.titleLbl.text!
                    let editList = segue.destination as! ItemListEditVC
                    let items = self.categoriesItems[category]
                    editList.products = items!
                    editList.selectedCategory = category
                    editList.screenState = self.screenState
                }
            }
        }
    }
    
    func displayErrorMessage(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
