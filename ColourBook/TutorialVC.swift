//
//  ViewController.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-11-19.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController, UIScrollViewDelegate  {
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var scanLbl: UILabel!
    
    @IBOutlet weak var pageCtrl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var skipLbl: UILabel!
    
    let colours = UIColours()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        let scrollViewHeight: CGFloat = self.scrollView.frame.height
        
        self.scrollView.isScrollEnabled = true
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        
        let pageOne = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
        pageOne.frame.origin = CGPoint(x: scrollView.bounds.size.width/2 - pageOne.frame.width/2, y: scrollView.bounds.size.height/2 - pageOne.frame.height/2)
        pageOne.imageView = UIImageView(frame: CGRect(x: 14, y: 7, width: 108, height: 172))
        pageOne.backgroundColor = colours.goldColour()
        pageOne.addSubview(pageOne.imageView!)
     //   pageOne.imageView?.image = UIImage(named: "goldCBlogo")
        self.scrollView.addSubview(pageOne)
        
        let pageTwo = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
        pageTwo.frame.origin = CGPoint(x: pageOne.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageTwo.frame.height/2)
        pageTwo.imageView = UIImageView(frame: CGRect(x: 14, y: 7, width: 108, height: 172))
        pageTwo.backgroundColor = colours.pinkColour()
        pageTwo.addSubview(pageTwo.imageView!)
  //      pageTwo.imageView?.image = UIImage(named: "pinkCBLogo")
        self.scrollView.addSubview(pageTwo)
        
        let pageThree = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
        pageThree.frame.origin = CGPoint(x: pageTwo.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageThree.frame.height/2)
        pageThree.imageView = UIImageView(frame: CGRect(x: 14, y: 7, width: 108, height: 172))
        pageThree.backgroundColor = colours.purpleColour()
        pageThree.addSubview(pageThree.imageView!)
  //      pageThree.imageView?.image = UIImage(named: "pinkCBLogo")
        self.scrollView.addSubview(pageThree)
        
        let pageFour = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
        pageFour.frame.origin = CGPoint(x: pageThree.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageFour.frame.height/2)
        pageFour.imageView = UIImageView(frame: CGRect(x: 14, y: 7, width: 108, height: 172))
        pageFour.backgroundColor = colours.greenColour()
        pageFour.addSubview(pageFour.imageView!)
 //       pageFour.imageView?.image = UIImage(named: "pinkCBLogo")
        self.scrollView.addSubview(pageFour)
        
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 4, height: self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageCtrl.currentPage = 0
        
        self.skipBtn.setBorderWidth()
        self.titleLbl.setSpacing(space: 6.0)
        self.skipLbl.setSpacing(space: 4.0)
        self.skipLbl.center = skipBtn.center
        
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1
        
        self.pageCtrl.currentPage = Int(currentPage)
        
        if Int(currentPage) == 0 {
            self.scanLbl.text = "Scan your product"
        } else if Int(currentPage) == 1 {
            self.scanLbl.text = "View your product"
        } else if Int(currentPage) == 2 {
            self.scanLbl.text = "Add your product to your Personal Bucket List"
            self.scanLbl.numberOfLines = 3
        } else if Int(currentPage) == 3 {
            self.scanLbl.text = "Add your product to your home"
            self.scanLbl.numberOfLines = 2
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0.0
        
        let pageWidth = scrollView.frame.size.width
        let fractional = scrollView.contentOffset.x / pageWidth
        let page = lround(Double(fractional))
        
        self.pageCtrl.currentPage = page;
        
        if Int(page) == 0 {
            self.topView.backgroundColor = colours.goldColour()
            self.bottomView.backgroundColor = colours.goldColour()
            self.scanLbl.text = "Scan your product"
            
        } else if Int(page) == 1 {
            self.topView.backgroundColor = colours.pinkColour()
            self.bottomView.backgroundColor = colours.pinkColour()
            self.scanLbl.text = "View your product"
            
        } else if Int(page) == 2 {
            self.topView.backgroundColor = colours.purpleColour()
            self.bottomView.backgroundColor = colours.purpleColour()
            self.scanLbl.text = "Add your product to your Personal Bucket List"
            self.scanLbl.numberOfLines = 3
            
        } else if Int(page) == 3 {
            self.topView.backgroundColor = colours.greenColour()
            self.bottomView.backgroundColor = colours.greenColour()
            self.scanLbl.text = "Add your product to your home"
            
            
        }
        
    }
}



