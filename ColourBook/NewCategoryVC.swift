//
//  NewCategoryVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 21/5/2017.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit

// View for adding a new category to a personal list
class NewCategoryVC: ColourBookVC {
    
    var imageView: UIImageView?
    var textfield: UITextField?
    var createBtn: UIButton?
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFit
        let image = UIImage(named: "darkgreen.jpg")
        imageView?.image = image
        self.view.addSubview(imageView!)
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        imageView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        imageView?.widthAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true
        imageView?.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true

        textfield = UITextField()
        textfield?.textAlignment = .center
        textfield?.placeholder = "type name of new category"
        self.view.addSubview(textfield!)
        textfield?.translatesAutoresizingMaskIntoConstraints = false
        textfield?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        textfield?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        textfield?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        textfield?.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        
        createBtn = UIButton(type: .system)
        createBtn?.setTitle("Create", for: .normal)
        createBtn?.addTarget(self, action: #selector(self.createBtnPressed), for: .touchUpInside)
        self.view.addSubview(createBtn!)
        createBtn?.translatesAutoresizingMaskIntoConstraints = false
        createBtn?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        createBtn?.topAnchor.constraint(equalTo: textfield!.bottomAnchor, constant: 20).isActive = true
        createBtn?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        createBtn?.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    // MARK: - Create Btn Function
    func createBtnPressed() {
        if textfield!.text != nil || textfield!.text != "" {
            let newCategory = textfield!.text!
            DataService.instance.createNewCategory(newCategory: newCategory)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Touches Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textfield?.resignFirstResponder()
    }
}
