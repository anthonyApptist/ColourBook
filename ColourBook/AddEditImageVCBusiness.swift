//
//  AddEditImageVC-Business.swift
//  ColourBook
//
//  Created by Mark Meritt on 2017-02-10.
//  Copyright © 2017 Apptist. All rights reserved.
//

import UIKit

class AddEditImageVCBusiness: CustomVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var photoTitleLbl: UILabel!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField?
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var siteTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var postalCodeTextField: UITextField!
    
    @IBOutlet weak var imgView: UIImageView!

    @IBAction func addPicBtnPressed(_sender: UIButton!) {
        
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    let imagePicker = UIImagePickerController()
    
    var selectedLocation: Location?
    
    var image: String? = ""
    var resizedImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.imagePicker.delegate = self
        siteTextField.delegate = self
        phoneTextField.delegate = self
        postalCodeTextField.delegate = self
        locationTextField.delegate = self
        
        self.getBusinessInfo(user: self.signedInUser)
        
        self.saveBtn.addTarget(self, action: #selector(self.saveBtnPressed(_:)), for: .touchUpInside)
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
        
        if (self.nameTextField?.text)! == "" || self.locationTextField.text == "" {
            let alert = UIAlertController(title: "Must have name and location", message: "Enter them", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let businessArray: [String] = [(self.nameTextField?.text!)!, self.locationTextField.text!, self.phoneTextField!.text!, (self.siteTextField?.text!)!, (self.postalCodeTextField?.text!)!, self.image!]
            DataService.instance.saveBusinessProfile(profile: businessArray, user: self.signedInUser)
            
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        
//        performSegue(withIdentifier: "BackToItemEdit", sender: self) // change to back to ItemListAdd
        
    }
    
    // MARK: - Save Button Segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToItemEdit" {
            
            if let detail = segue.destination as? ItemListEditVC { // change to ItemListAdd
                detail.screenState = self.screenState
                detail.selectedLocation = self.selectedLocation
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField?.resignFirstResponder()
        locationTextField?.resignFirstResponder()
        siteTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        postalCodeTextField.resignFirstResponder()
    }
    

}
