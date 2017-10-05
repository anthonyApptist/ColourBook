//
//  CategoriesListVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2017-01-31.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

// Categories list before every item list view, with abiltiy to add new category to personal list
class CategoriesListVC: ColourBookVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    // MARK: - Scan Btn Pressed
    @IBAction func scanBtnPressed(_ sender: AnyObject) {
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")
        present(scanView!, animated: true, completion: nil)
    }
    
    // database ref
    var ref: DatabaseReference?
    
    // data
    var selectedLocation: Address? = nil
    var categoriesItems = [String:[PaintCan]]()
    var categories = [String]()
    
    // products with added by
    var businessImages = [String:String]()
    var locationItems = [String:[PaintCan]]()
    
    var paintProducts = [String:[PaintCan]]()

    let app = UIApplication.shared.delegate as! AppDelegate
    
    var addNewBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addNewBtn = UIButton(type: .system)
        addNewBtn?.setTitle("+", for: .normal)
        addNewBtn?.titleLabel?.adjustsFontSizeToFitWidth = true
        addNewBtn?.isHidden = true
        addNewBtn?.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 17.0)
        addNewBtn?.addTarget(self, action: #selector(self.addBtnPressed), for: .touchUpInside)
        self.view.addSubview(addNewBtn!)
        addNewBtn?.translatesAutoresizingMaskIntoConstraints = false
        addNewBtn?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        addNewBtn?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: titleLbl.frame.minY).isActive = true
        addNewBtn?.widthAnchor.constraint(equalTo: titleLbl.heightAnchor, multiplier: 1).isActive = true
        addNewBtn?.heightAnchor.constraint(equalTo: titleLbl.heightAnchor, multiplier: 1).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if self.screenState == .personal {
            self.getCategoriesFor(screenState: self.screenState, location: selectedLocation)
            self.addNewBtn?.isHidden = false
        }
        if self.screenState == .searching {
            self.addNewBtn?.isHidden = true
        }
        //   app.window?.rootViewController = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let kWhateverHeightYouWant = 50
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
        let cell = collectionView.cellForItem(at: indexPath) as? CategoryItemCell
        if self.screenState == .personal {
            performSegue(withIdentifier: "ConnectToPersonal", sender: cell)
        }
        if self.screenState == .homes {
            performSegue(withIdentifier: "ConnectToAddresses", sender: cell)
        }
        if self.screenState == .business {
            performSegue(withIdentifier: "ConnectToBusiness", sender: cell)
        }
        if self.screenState == .searching {
            let itemsList = storyboard?.instantiateViewController(withIdentifier: "ListEditVC") as! ItemListEditVC
            let category = cell?.titleLbl.text
            itemsList.products = self.categoriesItems[category!]!
            itemsList.selectedLocation = self.selectedLocation
            itemsList.selectedCategory = category
            itemsList.screenState = self.screenState
            itemsList.businessImages = self.businessImages
            self.present(itemsList, animated: true, completion: {
                
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: nil)
        
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
        if self.screenState == .business {
            if let categoryItemCell = sender as? CategoryItemCell {
                if segue.destination is ItemListEditVC {
                    let category = categoryItemCell.titleLbl.text!
                    let editList = segue.destination as! ItemListEditVC
                    let items = self.categoriesItems[category]
                    editList.products = items!
                    editList.selectedCategory = category
                    editList.screenState = self.screenState
                    editList.selectedLocation = self.selectedLocation
                    editList.businessImages = self.businessImages
                }
            }
        }
        if self.screenState == .homes {
            if let categoryItemCell = sender as? CategoryItemCell {
                if segue.destination is ItemListEditVC {
                    let category = categoryItemCell.titleLbl.text!
                    let editList = segue.destination as! ItemListEditVC
                    let items = self.categoriesItems[category]
                    editList.products = items!
                    editList.selectedCategory = category
                    editList.screenState = self.screenState
                    editList.selectedLocation = self.selectedLocation
                    editList.businessImages = self.businessImages
                }
            }
        }
    }
    
    // MARK: - Add Button Pressed
    func addBtnPressed() {
        let newCategory = NewCategoryVC()
        self.present(newCategory, animated: true, completion: nil)
    }

    // MARK: - Display Error Message
    func displayErrorMessage(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    
}
