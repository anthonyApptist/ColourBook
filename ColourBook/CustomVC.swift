//
//  CustomVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-08.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

enum ScreenState {
    case none
    case personal
    case business
    case homes
    case transfer
}

class CustomVC: UIViewController, UITextFieldDelegate {
    
    var signedInUser: User!
    
    var titleString: String?
    
    var screenState = ScreenState.none
    
    var nextVC: CustomVC?
    
    var backButtonNeeded: Bool?
    
    var backBtnImage = UIImage(named: "arrowBack")
    
    var backBtn = UIButton(frame: CGRect(x: 20, y: 25, width: 40, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get signed in user
        

        //DEFAULT VALUES
        self.signedInUser = AuthService.instance.getSignedInUser()
        
        self.backButtonNeeded = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        print(screenState.hashValue)
        
        
        if screenState == ScreenState.personal {
            self.titleString = "personal"
        } else if screenState == ScreenState.business {
            self.titleString = "business"
        } else if screenState == ScreenState.homes {
            self.titleString = "my homes"
        }
        
        print(titleString ?? "")
        
        if(self.backButtonNeeded == true) {
            
            self.backBtn.setImage(self.backBtnImage, for: .normal)
            self.view.addSubview(self.backBtn)
            
            self.backBtn.addTarget(self, action: #selector(self.backBtnPressed(_:)), for: .touchUpInside)
            
        }
        
        if(self.backButtonNeeded == false) {
            
            self.backBtn.removeFromSuperview()
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textField.resignFirstResponder()
    }
    
   
    func backBtnPressed(_ sender: AnyObject) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.nextVC = segue.destination as? CustomVC
        
        // reload table view if in upcoming view
        
        if let itemListAdd = self.nextVC as? ItemListAddVC {
            itemListAdd.tableView?.reloadData()
        }
        
        self.nextVC?.screenState = self.screenState
    
    }
    
    func setAddEditAddressTitle(screenState: ScreenState) -> String {
        
        if screenState == .business {
            return "edit business"
        }
        else if screenState == .homes {
            return "edit address"
        }
        else {
            return ""
        }
    }
    
    // url to image
    
    func setImageFrom(urlString: String) -> UIImage {
        
        let imageURL = NSURL(string: urlString)
        let imageData = NSData(contentsOf: imageURL as! URL)
        let image = UIImage(data: imageData as! Data)
        return image!
    }
    
    // String to UIImage
    
    func stringToImage(imageName: String) -> UIImage { // add to extensions
        let imageDataString = imageName
        let imageData = Data(base64Encoded: imageDataString)
        let image = UIImage(data: imageData!)
        return image!
    }


    func addTimeStamp() -> String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        // date
        dateFormatter.dateStyle = .medium
        let convertedDate = dateFormatter.string(from: date)
        print(convertedDate)
        
        // time
        dateFormatter.dateFormat = "HH:mm"
        let convertedTime = dateFormatter.string(from: date)
        print(convertedTime)

        let stamp = ("\(convertedDate) \(convertedTime)")
        
        return stamp
        
    }
    
    func createTimestamp() -> String {
        // time
        let date = Date()
        let dateFormatter = DateFormatter()
        // date
        dateFormatter.dateStyle = .medium
        let convertedDate = dateFormatter.string(from: date)
        print(convertedDate)
        // time
        dateFormatter.dateFormat = "HH:mm"
        let convertedTime = dateFormatter.string(from: date)
        print(convertedTime)
        
        return "\(convertedDate) \(convertedTime)"
    }
    
    func showActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func hideActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
