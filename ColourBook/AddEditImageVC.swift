//
//  AddEditVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-06.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class AddEditImageVC: CustomVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var photoTitleLbl: UILabel! 
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var textField: UITextField?
    
    @IBOutlet weak var imgView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var userItem: User?
    
    var businessItem: Business?
    
    var addressItem: Address?
    
    @IBAction func addPicBtnPressed(_sender: UIButton!) {
        
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        present(self.imagePicker, animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedImage = info[UIImagePickerControllerEditedImage] as! UIImage
  
        
        self.imgView.contentMode = .scaleAspectFill
        self.imgView.image = pickedImage
        
        
        if screenState == .personal {
            userItem?.image = pickedImage
            
        } else if screenState == .business {
            businessItem?.image = pickedImage
            
        } else if screenState == .homes {
            addressItem?.image = pickedImage
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField?.resignFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(false)
        
        self.imagePicker.delegate = self
        
        
        textField?.delegate = self
        
        if screenState == .personal {
            
            textField?.text = userItem?.name
            photoTitleLbl.text = "My Profile Picture"
            self.imgView.image = userItem?.image
            
        } else if screenState == .business {
            
            textField?.text = businessItem?.name
            photoTitleLbl.text = "Business Logo"
            self.imgView.image = businessItem?.image

            
        } else if screenState == .homes {
            
            textField?.text = addressItem?.name
            photoTitleLbl.text = "Address Profile Picture"
            self.imgView.image = addressItem?.image

        }
        
        self.saveBtn.addTarget(self, action: #selector(self.saveBtnPressed(_:)), for: .touchUpInside)
        

    }
    
    func saveBtnPressed(_ sender: Any?) {
        
            performSegue(withIdentifier: "BackToItemEdit", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToItemEdit" {
            
            
            if let detail = segue.destination as? ItemListEditVC {
                
                if screenState == .personal {
                
                detail.user = userItem!
                detail.screenState = screenState
                detail.titleLbl?.text = self.userItem?.name
                
                } else if screenState == .business {
                    
                    detail.businessItem = businessItem
                    detail.screenState = screenState
                    detail.titleLbl?.text = self.businessItem?.name

                    
                } else if screenState == .homes {
                    
                    detail.addressItem = addressItem
                    detail.screenState = screenState
                    detail.titleLbl?.text = self.addressItem?.name

                    
                }
                
                
                
                
            }
    }
        
    }

   
}
