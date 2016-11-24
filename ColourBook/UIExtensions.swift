//
//  UIExtensions.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-11-20.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit


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


extension UIImage{
    
    func alpha(value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
}

extension UIImageView {
    
    
    func makeBlurImage(targetImageView:UIImageView?)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        targetImageView?.addSubview(blurEffectView)
    }
    
}


extension UIButton {
    
    func setBorderWidth() {
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        
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
