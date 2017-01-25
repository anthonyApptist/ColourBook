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
    
    @IBAction func addPicBtnPressed(_sender: UIButton!) {
        
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        present(self.imagePicker, animated: true, completion: nil)
        
    }
    
    let imagePicker = UIImagePickerController()
    
    var selectedLocation: String?
    
    var image: String?
    
    var resizedImg: UIImage?
    
    var postalCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        
        textField?.delegate = self
        
        self.saveBtn.addTarget(self, action: #selector(self.saveBtnPressed(_:)), for: .touchUpInside)
        
        if screenState == .personal {
            DispatchQueue.global(qos: .background).async {
                self.getProfileFor(user: self.signedInUser.uid)
            }
            DispatchQueue.main.async {
                self.setPersonalInfo()
            }
        }
        if screenState == .business || screenState == .homes {
            DispatchQueue.global(qos: .background).async {
                self.getInfoFor(location: self.selectedLocation, user: self.signedInUser.uid, screenState: self.screenState)
            }
            
            DispatchQueue.main.async {
                self.setLocationInfo()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    // MARK: - ImagePicker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // chosen image
        let pickedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // turn image to data
        let pickedImageData: Data = UIImageJPEGRepresentation(pickedImage, 0.9)!
    
        // encode image data string
        let pickedImageDataString = pickedImageData.base64EncodedString()

        // assign to image string
        self.image = pickedImageDataString
        
        self.resizedImg = self.resizeImage(image: pickedImage, targetSize: self.imgView.frame.size)
        self.imgView.image = self.resizedImg
        self.imgView.contentMode = .scaleAspectFit
        
        let resizedData: Data = UIImageJPEGRepresentation(resizedImg!, 0.9)!
        let resizedDataString = resizedData.base64EncodedString()
        
        self.image = resizedDataString
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
            
            DataService.instance.saveInfoFor(user: self.signedInUser.uid, screenState: self.screenState, location: "", image: self.image, name: self.textField?.text)
        
            AuthService.instance.saveDisplay(name: (self.textField?.text)!)
        }
        if screenState == .business {
            
            DataService.instance.saveInfoFor(user: self.signedInUser.uid, screenState: self.screenState, location: self.selectedLocation, image: self.image, name: self.textField?.text)
            
            DataService.instance.businessRef.child(self.selectedLocation!).updateChildValues(["name" : self.textField?.text ?? "", "image" : self.image ?? ""])
        }
        if screenState == .homes {
            
            DataService.instance.saveInfoFor(user: self.signedInUser.uid, screenState: self.screenState, location: self.selectedLocation, image: self.image, name: self.textField?.text)
            
            DataService.instance.addressRef.child(self.selectedLocation!).updateChildValues(["name" : self.textField?.text ?? "", "image" : self.image ?? ""])
        }
        
        performSegue(withIdentifier: "BackToItemEdit", sender: self)
        
    }
    
    // MARK: - Business/Address Info
    
    func getInfoFor(location: String?, user: String, screenState: ScreenState) {
        
        getLocationRefFor(location: location!, user: user, screenState: screenState)
        let locationInfoRef = DataService.instance.generalRef
        
        locationInfoRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let profile = snapshot.value as? NSDictionary
            
            let postalCode = profile?["postalCode"] as! String
            
            let image = profile?["image"] as! String
            
            if let name = profile?["name"] as? String {
                self.textField?.text = name
            }
            else {
                self.textField?.text = ""
            }
            
            self.postalCode = postalCode
            
            self.image = image
            
            if self.image == nil || self.image == "" {
                
                let image = UIImage(named: "darkgreen.jpg")
                
                self.imgView.image = image
                
            }
            
            else {
                
                let locationImage = self.stringToImage(imageName: self.image!)
    
                self.imgView.image = locationImage
                
            }
            
            
            
        })
        
    }
    
    func getLocationRefFor(location: String?, user: String, screenState: ScreenState) {
        
        if screenState == .business {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user).child(BusinessDashboard).child(location!)
        }
        else if screenState == .homes {
            DataService.instance.generalRef = DataService.instance.usersRef.child(user).child(AddressDashboard).child(location!)
        }
        
    }
    
    // MARK: - Firebase Personal Info
    
    func getProfileFor(user: String) {
        
        let uidRef = DataService.instance.usersRef.child(user)
        
        uidRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let profile = snapshot.value as? NSDictionary
            
            let image = profile?["image"] as! String
            
            self.image = image
            
            if self.image == nil || self.image == "" {
                
                let image = UIImage(named: "darkgreen.jpg")
                
                self.imgView.image = image
                
            }
                
            else {
                
                let locationImage = self.stringToImage(imageName: self.image!)
                
                self.imgView.image = locationImage
                
            }
            
        })
        
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
    
    // MARK: - Set UI data
    
    func setLocationInfo() {
        
        
        
    }
    
    func setPersonalInfo() {
        
        if self.signedInUser.name.isEmpty {
            self.textField?.text = ""
        }
        else {
            self.textField?.text = self.signedInUser.name
        }
        
        self.photoTitleLbl.text = self.signedInUser.email
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField?.resignFirstResponder()
    }
    
    
    
}
