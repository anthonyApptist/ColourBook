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

extension UITextField {
    
    func makeRound() {
        let radius = self.frame.width/8
        self.layer.cornerRadius = radius
        self.clipsToBounds = true

    }
    
}


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
