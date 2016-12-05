//
//  CustomAnimatedButton.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-04.
//  Copyright © 2016 Apptist. All rights reserved.
//
import Foundation
import UIKit

class CustomAnimatedButton: UIView {
    
    var isAnimated : Bool = false
    var shouldAnimate: Bool = true
    var startPosition: Float = 0.0
    
    var btnSubmit : UIButton!
    var arrow: UIImageView!
    var keyboardHeight: Float = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup() {
        
        self.isAnimated = false
        self.btnSubmit = UIButton(frame: CGRect(x: 0, y: 0, width: 375, height: 50))
        self.btnSubmit.backgroundColor = UIColor.init(red: 217/256, green: 217/256, blue: 217/256, alpha: 1.0)
        self.btnSubmit.setTitle("NEXT", for: .normal)
        self.btnSubmit.titleLabel?.font = UIFont.init(name: "HelveticaNeue-Thin", size: 13)
        self.btnSubmit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        self.btnSubmit.setTitleColor(UIColor.black, for: .normal)
        
        self.arrow = UIImageView(frame: CGRect(x: 213, y: 19, width: 17, height: 12))
        self.arrow.image = UIImage.init(named: "arrowNext")
        
        self.btnSubmit.setSpacing(space: 1.0)
        
        self.addSubview(self.btnSubmit)
        self.addSubview(self.arrow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    func offsetButtonPosition() {
        if !shouldAnimate {
            return
        }
        if isAnimated == false {
            let offsetPosition = CABasicAnimation(keyPath: "position.y")
            
            offsetPosition.fromValue = self.startPosition
            offsetPosition.toValue = self.startPosition - keyboardHeight
            offsetPosition.duration = 0.05
            offsetPosition.beginTime = 0.0
            offsetPosition.fillMode = kCAFillModeForwards
            offsetPosition.isRemovedOnCompletion = false
            
            isAnimated = true
            self.layer.add(offsetPosition, forKey: "basic")
            
        }
    }
    
    func resetButtonPosition() {
        if !shouldAnimate {
            return
        }
        if isAnimated == true {
            let resetPosition = CABasicAnimation(keyPath: "position.y")
            
            resetPosition.fromValue = self.layer.position.y
            resetPosition.toValue = self.startPosition
            resetPosition.duration = 0.05
            resetPosition.beginTime = 0.0
            resetPosition.fillMode = kCAFillModeForwards
            resetPosition.isRemovedOnCompletion = false
            
            isAnimated = false
            self.layer.add(resetPosition, forKey: "basic")
            
        }
    }
    
    func adjustButtonPosition(){
        if !shouldAnimate {
            return
        }
        if isAnimated == true {
            
            let resetPosition = CABasicAnimation(keyPath: "position.y")
            
            resetPosition.fromValue = self.layer.position.y
            resetPosition.toValue = self.startPosition - keyboardHeight
            resetPosition.duration = 0.05
            resetPosition.beginTime = 0.0
            resetPosition.fillMode = kCAFillModeForwards
            resetPosition.isRemovedOnCompletion = false
            
            isAnimated = true
            self.layer.add(resetPosition, forKey: "basic")
            
        }
    }
    
    
    func keyboardDidShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                _ = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                keyboardHeight = Float(keyboardSize.height)
                self.offsetButtonPosition()
            }
        }
    }
    
    func keyboardWillChange(sender: NSNotification){
        if let userInfo = sender.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                _ = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                if(keyboardHeight != Float(keyboardSize.height)) {
                    keyboardHeight = Float(keyboardSize.height)
                    
                    self.adjustButtonPosition()
                }
            }
        }
    }
    
    func keyboardDidHide(sender: NSNotification) {
        self.resetButtonPosition()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomAnimatedButton.keyboardDidShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomAnimatedButton.keyboardDidHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomAnimatedButton.keyboardWillChange(sender:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
        startPosition = Float(self.layer.position.y)
    }
    
}
