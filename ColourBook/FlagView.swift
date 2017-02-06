//
//  FlagView.swift
//  ColourBook
//
//  Created by Mark Meritt on 2017-02-02.
//  Copyright © 2017 Apptist. All rights reserved.
//

import UIKit

class FlagView: UIView {
    
    var reportDelegate: ReportDelegate?
    
    var titleContent: LabelCustomSpacing!
    
    var messageContent: LabelCustomSpacing!
    
    var innapropriateContentBtn: UIButton!
    
    var missingItemBtn: UIButton!
    
    var cancelBtn: UIButton!
    
    var margins : UILayoutGuide!

    
    var startPositionY: CGFloat = 0.0
    
    var messageShow = false
    
    var viewArray: [UIView] = []
    
    
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()

    
    @IBAction func reportbtnPressed(_ sender: AnyObject) {
        
       UIView.animate(withDuration: 1.0, animations: {
        self.createDoneView()
       }) { (true) in
        self.hideView(sender)
        }

        reportDelegate?.didPressReport()

    }

    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    @IBAction func hideView(_ sender: AnyObject) {
        
    
            self.animateViewToCoordinates(newX: self.frame.origin.x, newY: self.frame.origin.y - UIScreen.main.bounds.height)
            self.blurEffectView.removeFromSuperview()
        
        
    }
    
    private func createDoneView() {
        
        self.animateToScale(scale: 0.5)
        self.missingItemBtn.isHidden = true
        self.titleContent.isHidden = true
        self.cancelBtn.isHidden = true
        self.innapropriateContentBtn.isHidden = true
        self.messageContent.text = "Report Sent!"
        
    }
    
    private func createViews() {
        
        self.titleContent = LabelCustomSpacing(frame: CGRect(x: 0, y: 0, width: 240, height: 80))
        self.titleContent.textColor = UIColor.black
        self.titleContent.font = UIFont.init(name: "HelveticaNeue-Medium", size: 34)
        self.titleContent.numberOfLines = 1
        self.titleContent.text = "Flag Item"
        self.titleContent.textAlignment = .center
        self.titleContent.alpha = 1.0
        self.titleContent.setSpacing(space: 2.0)
        self.titleContent.lineBreakMode = .byWordWrapping
        
        self.messageContent = LabelCustomSpacing(frame: CGRect(x: 0, y: 0, width: 240, height: 38))
        self.messageContent.textColor = UIColor.black
        self.messageContent.font = UIFont.init(name: "HelveticaNeue-Medium", size: 23)
        //   self.messageContent.font = UIFont.boldSystemFont(ofSize: 13)
        self.messageContent.numberOfLines = 0
        self.messageContent.text = "Hi"
        self.messageContent.textAlignment = .center
        self.messageContent.alpha = 1.0
        self.messageContent.setSpacing(space: 2.0)
        self.messageContent.lineBreakMode = .byWordWrapping
        
        self.innapropriateContentBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 240, height: 40))
        self.innapropriateContentBtn.setTitle("Innapropriate Content", for: .normal)
        self.innapropriateContentBtn.titleLabel?.font = UIFont.init(name: "HelvelticaNeue-Medium", size: 13)
        self.innapropriateContentBtn.titleLabel?.numberOfLines = 0
        self.innapropriateContentBtn.setTitleColor(UIColor.black, for: .normal)
        self.innapropriateContentBtn.setBorderWidth()
        self.innapropriateContentBtn.setSpacing(space: 2.0)
        self.innapropriateContentBtn.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        self.innapropriateContentBtn.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
        self.innapropriateContentBtn.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        self.innapropriateContentBtn.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .vertical)
        self.innapropriateContentBtn.titleEdgeInsets.left = 10
        self.innapropriateContentBtn.titleEdgeInsets.right = 10
        self.innapropriateContentBtn.titleEdgeInsets.top = 10
        self.innapropriateContentBtn.titleEdgeInsets.bottom = 10
        self.innapropriateContentBtn.alpha = 1.0
        self.innapropriateContentBtn.addTarget(self, action: #selector(self.reportbtnPressed(_:)), for: .touchUpInside)

        
        self.missingItemBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 240, height: 40))
        self.missingItemBtn.setTitle("Missing Item", for: .normal)
        self.missingItemBtn.titleLabel?.font = UIFont.init(name: "HelvelticaNeue-Medium", size: 13)
        self.missingItemBtn.titleLabel?.numberOfLines = 0
        self.missingItemBtn.setTitleColor(UIColor.black, for: .normal)
        self.missingItemBtn.setBorderWidth()
        self.missingItemBtn.setSpacing(space: 2.0)
        self.missingItemBtn.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        self.missingItemBtn.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
        self.missingItemBtn.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        self.missingItemBtn.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .vertical)
        self.missingItemBtn.titleEdgeInsets.left = 10
        self.missingItemBtn.titleEdgeInsets.right = 10
        self.missingItemBtn.titleEdgeInsets.top = 10
        self.missingItemBtn.titleEdgeInsets.bottom = 10
        self.missingItemBtn.alpha = 1.0
        self.missingItemBtn.addTarget(self, action: #selector(self.reportbtnPressed(_:)), for: .touchUpInside)
        
        self.cancelBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 240, height: 40))
        self.cancelBtn.setTitle("Cancel", for: .normal)
        self.cancelBtn.titleLabel?.font = UIFont.init(name: "HelvelticaNeue-Medium", size: 14)
        self.cancelBtn.setBorderWidth()
        self.cancelBtn.titleLabel?.numberOfLines = 0
        self.cancelBtn.setTitleColor(UIColor.black, for: .normal)
        self.cancelBtn.setSpacing(space: 2.0)
        self.cancelBtn.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
        self.cancelBtn.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .vertical)
        self.cancelBtn.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        self.cancelBtn.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .vertical)
        self.cancelBtn.titleEdgeInsets.left = 10
        self.cancelBtn.titleEdgeInsets.right = 10
        self.cancelBtn.titleEdgeInsets.top = 10
        self.cancelBtn.titleEdgeInsets.bottom = 10
        self.cancelBtn.alpha = 1.0
        self.cancelBtn.addTarget(self, action: #selector(self.hideView(_:)), for: .touchUpInside)
        
     
        
        self.viewArray = [titleContent, messageContent, innapropriateContentBtn, missingItemBtn, cancelBtn]
        
        
    }
    
  
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: UIScreen.main.bounds.width - UIScreen.main.bounds.height/2, y: UIScreen.main.bounds.height/6 - UIScreen.main.bounds.height, width: 300, height: 430))
        self.backgroundColor = UIColor.white
        let radius = self.frame.width/8
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)

        startPositionY = self.layer.position.y
        createViews()
       
        let stackView = UIStackView(arrangedSubviews: self.viewArray)
        stackView.center = self.center
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        self.innapropriateContentBtn.pinToLeft(view: self, margin: 0).isActive = true
        self.innapropriateContentBtn.pinToRight(view: self, margin: 0).isActive = true
        
        self.missingItemBtn.pinToLeft(view: self, margin: 0).isActive = true
        self.missingItemBtn.pinToRight(view: self, margin: 0).isActive = true
        
        self.cancelBtn.pinToLeft(view: self, margin: 0).isActive = true
        self.cancelBtn.pinToRight(view: self, margin: 0).isActive = true
        
        margins = self.layoutMarginsGuide
        
    //    self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: self.margins.leadingAnchor, constant: 40).isActive = true
       self.topAnchor.constraint(equalTo: self.margins.topAnchor, constant: -40).isActive = true
        self.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        self.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0).isActive = true
        

        let viewsDictionary = ["stackView": stackView]
        let stackView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[stackView]-20-|", options: .alignAllCenterX, metrics: nil, views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[stackView]-30-|", options: .alignAllCenterY, metrics: nil, views: viewsDictionary)
        self.addConstraints(stackView_H)
        self.addConstraints(stackView_V)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showView() {
        
        self.animateToScale(scale: 1.0)
        self.missingItemBtn.isHidden = false
        self.titleContent.isHidden = false
        self.cancelBtn.isHidden = false
        self.innapropriateContentBtn.isHidden = false
        self.animateViewToCoordinates(newX: self.frame.origin.x, newY: self.frame.origin.y + UIScreen.main.bounds.height)
        
    }
    
  
    
   

}
