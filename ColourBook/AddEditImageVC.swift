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
    
    var selectedLocation: String?
    
    var image: String?
    
    var postalCode: String?
    
    var imageString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if screenState == .personal {

            DispatchQueue.global(qos: .background).async {
                
                self.getProfileFor(user: self.signedInUser.uid)
                
            }
            
            DispatchQueue.main.async {
                
                print("This is run on the main queue, after the previous code in outer block")
                
                self.setPersonalInfo()
                
            }

        }
        
        if screenState == .business || screenState == .homes {
            
            DispatchQueue.global(qos: .background).async {
                
                self.getInfoFor(location: self.selectedLocation, user: self.signedInUser.uid, screenState: self.screenState)
                
            }
            
            DispatchQueue.main.async {
                
                print("This is run on the main queue, after the previous code in outer block")
                    
                self.setLocationInfo()
                
            }
            
        }
        
        self.imagePicker.delegate = self
        
        textField?.delegate = self
        
        self.saveBtn.addTarget(self, action: #selector(self.saveBtnPressed(_:)), for: .touchUpInside)
        
    }
    
    @IBAction func addPicBtnPressed(_sender: UIButton!) {
        
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        present(self.imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        let pickedImageData: Data = UIImagePNGRepresentation(pickedImage)!
        
        let pickedImageDataString = pickedImageData.base64EncodedString()
        
        // assign to imageString
        
        self.imageString = pickedImageDataString
        
        self.imgView.contentMode = .scaleAspectFit
        
        self.imgView.image = pickedImage
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print(self.imageString)
        
    }
    
    // MARK: Save Button
    
    func saveBtnPressed(_ sender: Any?) {
        
        DataService.instance.saveInfoFor(user: self.signedInUser.uid, screenState: self.screenState, location: self.selectedLocation, image: self.imageString, name: self.textField?.text)
        
        AuthService.instance.saveDisplay(name: (self.textField?.text)!)
        
        performSegue(withIdentifier: "BackToItemEdit", sender: self)
        
    }
    
    func stringToImage(imageName: String) -> UIImage {
        
        let imageDataString = imageName
        
        let imageData = Data(base64Encoded: imageDataString)
        
        let image = UIImage(data: imageData!)
        
        return image!
        
    }
    
    // MARK: - Get location Info
    
    func getInfoFor(location: String?, user: String, screenState: ScreenState) {
        
        getLocationRefFor(location: location!, user: user, screenState: screenState)
        
        let locationInfoRef = DataService.instance.generalRef
        
        locationInfoRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            
                let profile = snapshot.value as? NSDictionary
                
                let postalCode = profile?["postalCode"] as! String
                
                let image = profile?["image"] as! String
                
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
    
    // MARK: - Get Personal Info
    
    func getProfileFor(user: String) {
        
        let uidRef = DataService.instance.usersRef.child(user)
        
        uidRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let profile = snapshot.value as? NSDictionary
            
            let image = profile?["image"] as! String
            
            self.image = image
            
            self.signedInUser.image = self.image
            
            self.imgView.image = self.stringToImage(imageName: self.signedInUser.image!)
            
        })
        
    }
    
    // MARK: Save Button Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToItemEdit" {
            
            if let detail = segue.destination as? ItemListEditVC {
                
                detail.screenState = self.screenState
                
                detail.selectedLocation = self.selectedLocation
                
            }
        
        }
        
    }
    
    // set location info
    
    func setLocationInfo() {
        
        self.photoTitleLbl.text = self.selectedLocation
        
        self.titleLbl.text = ""
        
    }
    
    // set personal info
    
    func setPersonalInfo() {
        
        if self.signedInUser.name.isEmpty {
            
            self.textField?.text = ""
            
        }
            
        else {
            
            self.textField?.text = self.signedInUser.name
            
        }
        
        self.photoTitleLbl.text = self.signedInUser.email
        
        self.signedInUser.image = self.image
        
        if self.signedInUser.image == nil || self.signedInUser.image!.isEmpty {
            
            let image = UIImage(named: "darkgreen.jpg")
            
            self.imgView.image = image
            
        }
        
        else {
            
            let imageEncodedString = self.signedInUser.image
            
            let imageData = Data(base64Encoded: imageEncodedString!)
            
            let image = UIImage(data: imageData!)
            
            self.imgView.image = image
            
        }
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField?.resignFirstResponder()
    }
    
    
    
}
