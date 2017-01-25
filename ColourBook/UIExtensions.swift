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
