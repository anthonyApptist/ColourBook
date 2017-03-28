//
//  AddEditVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-06.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddEditImageVC: CustomVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var photoTitleLbl: UILabel!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var textField: UITextField?
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBAction func addPicBtnPressed(_sender: UIButton!) {
        
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    let imagePicker = UIImagePickerController()
    
    var selectedLocation: Location?
    
    var resizedImg: UIImage?
    
    var ref: FIRDatabaseReference?
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        
        self.ref = DataService.instance.usersRef.child(self.signedInUser.uid)
        
        self.backButtonNeeded = true
        
        self.imagePicker.delegate = self
        
        textField?.delegate = self
        
        self.saveBtn.addTarget(self, action: #selector(self.saveBtnPressed(_:)), for: .touchUpInside)
        
        if screenState == .personal {
            self.textField?.text = self.signedInUser.name
            if self.signedInUser.image == "" || self.signedInUser.image == nil {
                let image = UIImage(named: "darkgreen.jpg")
                self.imgView.image = image
            }
            else {
                let image = self.stringToImage(imageName: self.signedInUser!.image!)
                self.imgView.image = image
            }
        }
        if screenState == .business || screenState == .homes {
            self.textField?.text = self.selectedLocation?.name
            if self.selectedLocation!.image == "" || self.selectedLocation!.image == nil {
                let image = UIImage(named: "darkgreen.jpg")
                self.imgView.image = image
            }
            else {
                let locationImage = self.stringToImage(imageName: self.selectedLocation!.image!)
                self.imgView.image = locationImage
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.ref?.removeAllObservers()
    }
    
    // MARK: - ImagePicker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // chosen image
        let pickedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // turn image to data
        let pickedImageData: Data = UIImageJPEGRepresentation(pickedImage, 0.9)!
    
        // encode image data string
        let pickedImageDataString = pickedImageData.base64EncodedString()
        
        self.resizedImg = self.resizeImage(image: pickedImage, targetSize: self.imgView.frame.size)
        self.imgView.image = self.resizedImg
        self.imgView.contentMode = .scaleAspectFit
        
        let resizedData: Data = UIImageJPEGRepresentation(resizedImg!, 0.9)!
        let resizedDataString = resizedData.base64EncodedString()
        
        if self.screenState == .personal {
            self.signedInUser.image = resizedDataString
        }
        if self.screenState == .business || self.screenState == .homes {
            self.selectedLocation?.image = resizedDataString
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save Button
    
    func saveBtnPressed(_ sender: Any?) {
        
        if screenState == .personal {
            DataService.instance.saveInfoFor(user: self.signedInUser.uid, screenState: self.screenState, location: "", image: self.signedInUser.image, name: self.signedInUser.name)
            AuthService.instance.saveDisplay(name: self.signedInUser.name!)
        }
        if screenState == .business {
            DataService.instance.saveInfoFor(user: self.signedInUser.uid, screenState: self.screenState, location: (self.selectedLocation?.locationName)!, image: self.selectedLocation?.image ?? "", name: self.selectedLocation?.name)
            DataService.instance.businessRef.child((self.selectedLocation?.locationName)!).updateChildValues(["name" : self.selectedLocation?.name ?? "", "image" : self.selectedLocation?.image ?? ""])
        }
        if screenState == .homes {
            DataService.instance.saveInfoFor(user: self.signedInUser.uid, screenState: self.screenState, location: (self.selectedLocation?.locationName)!, image: self.selectedLocation?.image ?? "", name: self.selectedLocation?.name)
            DataService.instance.addressRef.child((self.selectedLocation?.locationName)!).updateChildValues(["name" : self.selectedLocation?.name ?? "", "image" : self.selectedLocation?.image ?? ""])
        }
        
        performSegue(withIdentifier: "BackToItemEdit", sender: self)
        
    }
    
    
    // MARK: - Save Button Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToItemEdit" {
            
            if let detail = segue.destination as? ItemListEditVC {
                detail.screenState = self.screenState
                detail.selectedLocation = self.selectedLocation
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField?.resignFirstResponder()
        if self.screenState == .personal {
            self.signedInUser.name = (self.textField?.text)!
        }
        if self.screenState == .business || self.screenState == .homes {
            self.selectedLocation?.name = self.textField?.text
        }
    }
    
    
    
}
