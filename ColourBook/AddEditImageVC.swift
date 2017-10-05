//
//  AddEditVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-06.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import FirebaseDatabase

// Profile Page for an address in both business and homes lists or a user profile page in personal
class AddEditImageVC: ColourBookVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Properties
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var photoTitleLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var textField: UITextField?
    @IBOutlet weak var imgView: UIImageView!
    
    // MARK: - Add Picture Pressed
    @IBAction func addPicBtnPressed(_sender: UIButton!) {
        // image picker configure
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        // present imagepicker
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    // Image Picker
    let imagePicker = UIImagePickerController()
    
    // Model
    var selectedLocation: Address?
    var colourer: Colourer?
    
    // Resized Image
    var resizedImg: UIImage?
    var resizedData: Data?
    
    // Database Reference
    var ref: DatabaseReference?
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.ref = DataService.instance.usersRef.child(self.signedInUser.uid)
        
        self.backButtonNeeded = true
        
        self.imagePicker.delegate = self
        
        textField?.delegate = self
        
        self.saveBtn.addTarget(self, action: #selector(self.saveBtnPressed(_:)), for: .touchUpInside)
        
        /*
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
         */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if self.screenState == .personal {
            self.getPersonalInfo()
        }
        if self.screenState == .business {
            
        }
        if self.screenState == .homes {
            self.getAddressInfo()
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
        
        self.resizedData = UIImageJPEGRepresentation(self.resizedImg!, 1.0)
        
        picker.dismiss(animated: true, completion: nil)
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
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save Button Pressed
    func saveBtnPressed(_ sender: Any?) {
        if (textField?.text)! != "" || self.resizedData != nil {
            if screenState == .personal {
                let name = textField?.text!
                if self.resizedData == nil {
                    DataService.instance.saveNewUserName(name: name!)
                }
                else {
                    StorageService.instance.storePersonalImage(name: name!, imageData: self.resizedData!)
                }
            }
            if screenState == .business {
                let name = textField?.text!
                if self.resizedData == nil {
                    DataService.instance.saveNewUserName(name: name!)
                }
                else {
                    StorageService.instance.storeAddressImage(imageData: self.resizedData!, location: self.selectedLocation!.address!, name: name!)
                }
            }
            if screenState == .homes {
                let name = textField?.text!
                if self.resizedData == nil {
                    DataService.instance.saveNewAddressName(name: name!, location: self.selectedLocation!.address!, screenState: .homes)
                }
                else {
                    StorageService.instance.storeAddressImage(imageData: self.resizedData!, location: self.selectedLocation!.address!, name: name!)
                }
            }
            self.dismiss(animated: true, completion: nil)
//            performSegue(withIdentifier: "BackToItemEdit", sender: self)
        }
        else {
            self.createAlertController(title: "Nothing new to save", message: "some empty fields or nothing to save")
        }
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

    // MARK: - Touches Ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField?.resignFirstResponder()
    }
    
}
