//
//  MyDashboardVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-11-25.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import MapKit

class MyDashboardVC: UIViewController, UIScrollViewDelegate, MKMapViewDelegate {
    
    let colours = UIColours()
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var viewBtn: UIButton!
    
    @IBOutlet weak var viewLbl: UILabel!
    
    @IBOutlet weak var scanBtn: UIButton!
    
    @IBOutlet weak var scanLbl: UILabel!
    
    @IBOutlet weak var pageCtrl: UIPageControl!
    
    let locationManager = CLLocationManager()
    
    @IBAction func viewBtnPressed() {
        
    }
    
    @IBAction func scanBtnPressed() {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        let scrollViewHeight: CGFloat = self.scrollView.frame.height
        
        self.scrollView.isScrollEnabled = true
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        
        let pageOne = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
        pageOne.frame.origin = CGPoint(x: scrollView.bounds.size.width/2 - pageOne.frame.width/2, y: scrollView.bounds.size.height/2 - pageOne.frame.height/2)
        pageOne.imageView = UIImageView(frame: CGRect(x: 23, y: 56, width: 85.9, height: 75))
        pageOne.backgroundColor = colours.goldColour()
        pageOne.addSubview(pageOne.imageView!)
        pageOne.imageView?.image = UIImage(named: "personalIcon")
        self.scrollView.addSubview(pageOne)
        
        let pageTwo = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
        pageTwo.frame.origin = CGPoint(x: pageOne.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageTwo.frame.height/2)
        pageTwo.imageView = UIImageView(frame: CGRect(x: 26, y: 33, width: 77, height: 126))
        pageTwo.backgroundColor = colours.pinkColour()
        pageTwo.addSubview(pageTwo.imageView!)
        pageTwo.imageView?.image = UIImage(named: "moneyIcon")
        self.scrollView.addSubview(pageTwo)
        
        let pageThree = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
        pageThree.frame.origin = CGPoint(x: pageTwo.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageThree.frame.height/2)
        pageThree.imageView = UIImageView(frame: CGRect(x: 33, y: 48, width: 66, height: 94))
        pageThree.backgroundColor = colours.purpleColour()
        pageThree.addSubview(pageThree.imageView!)
        pageThree.imageView?.image = UIImage(named: "homeIcon")
        self.scrollView.addSubview(pageThree)
        
        let pageFour = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
        pageFour.frame.origin = CGPoint(x: pageThree.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageFour.frame.height/2)
        pageFour.imageView = UIImageView(frame: CGRect(x: 12.2, y: 40, width: 106.6, height: 104.3))
        pageFour.backgroundColor = colours.greenColour()
        pageFour.addSubview(pageFour.imageView!)
        pageFour.imageView?.image = UIImage(named: "settingsIcon")
        self.scrollView.addSubview(pageFour)
        
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 4, height: self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageCtrl.currentPage = 0
        
        self.scanBtn.setBorderWidth()
        self.titleLbl.setSpacing(space: 6.0)
        self.viewLbl.setSpacing(space: 4.0)
        self.scanLbl.setSpacing(space: 4.0)
        self.scanBtn.center = scanLbl.center
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1
        
        self.pageCtrl.currentPage = Int(currentPage)
        
        if Int(currentPage) == 0 {
            self.descLbl.text = "Personal"
        } else if Int(currentPage) == 1 {
            self.descLbl.text = "Business"
        } else if Int(currentPage) == 2 {
            self.descLbl.text = "Home Address"
        } else if Int(currentPage) == 3 {
            self.descLbl.text = "Settings"
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
            self.descLbl.text = "Personal"
            
        } else if Int(page) == 1 {
            self.topView.backgroundColor = colours.pinkColour()
            self.bottomView.backgroundColor = colours.pinkColour()
            self.descLbl.text = "Business"
            
        } else if Int(page) == 2 {
            self.topView.backgroundColor = colours.purpleColour()
            self.bottomView.backgroundColor = colours.purpleColour()
            self.descLbl.text = "Home Address"
            
        } else if Int(page) == 3 {
            self.topView.backgroundColor = colours.greenColour()
            self.bottomView.backgroundColor = colours.greenColour()
            self.descLbl.text = "Settings"
            
            
        }
        
    }

}
