//
//  UIExtensions.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-11-20.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

// MARK: - NSObject
extension NSObject { // convienience functions
    // add time stamp
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
    
    // create a timestamp
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
    
    // URL to Image
    func setImageFrom(urlString: String) -> UIImage {
        let imageURL = NSURL(string: urlString)
        let imageData = NSData(contentsOf: imageURL! as URL)
        let image = UIImage(data: imageData! as Data)
        return image!
    }
    
    // String to UIImage
    func stringToImage(imageName: String) -> UIImage {
        let imageDataString = imageName
        let imageData = Data(base64Encoded: imageDataString)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    // Activity Indicator Show/Hide
    func showActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func hideActivityIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // storyboard instantiate view controller
    func storyboardInstantiate(_ identifier: String) -> UIViewController {
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    // MARK: - Reset User Defaults
    func resetUserDefaults() {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }

}

// MARK: - UIViewController
extension UIViewController {
    // Present Controller w/ ScreenState
    func presentColourBookVC(_ viewController: ColourBookVC, with screenState: ScreenState) {
        // set screen state and present
        viewController.screenState = screenState
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Create Alert Controller
    func createAlertController(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createAlertWithDismiss(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UIColor
extension UIColor {
    convenience init(hexString:String) {
        
        let hexString: NSString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
        
        //        let hexString: NSString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let scanner = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}

// MARK: - UILabel
extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
    
    func setSpacing(space: CGFloat) {
        let attributedString = NSMutableAttributedString(string: (self.text!))
        attributedString.addAttribute(NSKernAttributeName, value: space, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}

// MARK: - UIView
extension UIView {
    func pinToTop(view: UIView, margin: CGFloat) -> NSLayoutConstraint {
        let topViewConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: margin)
        
        return topViewConstraint
    }
    
    func pinToLeft(view: UIView, margin: CGFloat) -> NSLayoutConstraint {
        let leftViewConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leadingMargin, multiplier: 1, constant: margin)
        
        return leftViewConstraint
    }
    
    func pinToRight(view: UIView, margin: CGFloat) -> NSLayoutConstraint {
        let rightViewConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1, constant: margin)
        return rightViewConstraint
    }
    
    func pinToBottom(view: UIView, margin: CGFloat) -> NSLayoutConstraint {
        let bottomViewConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottomMargin, multiplier: 1.0, constant: margin)
        return bottomViewConstraint
    }
    
    func animateToScale(scale: CGFloat) {
        UIView.animate(withDuration: 0.5) { 
            self.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
        }
    }
    
    func animateToScale(scaleX: CGFloat, scaleY: CGFloat) {
        UIView.animate(withDuration: 1.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: scaleX, y: scaleY)
        }, completion: nil)
    }
    
    func animateRadius(scale: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.5, animations: {
                self.transform = CGAffineTransform.identity
                
            })
        })
    }
    
    func addblurView(on: Bool, blurEffect: UIBlurEffect, blurview: UIVisualEffectView) {
        blurview.frame = self.bounds
        blurview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if(on) {
            self.addSubview(blurview)
        }else if(!on) {
            blurview.removeFromSuperview()
        }
    }
    
    func animateViewToCoordinates(newX: CGFloat, newY: CGFloat) {
        let height = self.frame.height
        let width = self.frame.width
        
        UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.frame = CGRect(x: newX, y: newY, width: width, height: height)
        }, completion: { (complete: Bool) in
        })
    }
}

// MARK: - UIImage
extension UIImage{
    func alpha(value:CGFloat)->UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

// MARK: - UIImageView
extension UIImageView {
    func makeBlurImage(targetImageView:UIImageView?) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        targetImageView?.addSubview(blurEffectView)
    }
}

// MARK: - UITextField
extension UITextField {
    func makeRound() {
        let radius = self.frame.width/8
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

// MARK: - UIButton
extension UIButton {
    func setBorderWidth() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        
        let radius = self.frame.width/8
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }

    func setSpacing(space: CGFloat) {
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text)!)
        attributedString.addAttribute(NSKernAttributeName, value: space, range: NSMakeRange(0, attributedString.length))
        self.titleLabel?.attributedText = attributedString
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func setAlpha(alpha: CGFloat) {
        UIView.animate(withDuration: 4.0) {
            self.alpha = alpha
        }
    }
    
}
