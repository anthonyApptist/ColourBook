
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
    
    
    @IBOutlet weak var scanBtn: UIButton!
    
    
    @IBOutlet weak var pageCtrl: UIPageControl!
    
    let locationManager = CLLocationManager()
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func viewBtnPressed() {
        
        
        
    }
    
    @IBAction func scanBtnPressed() {
        
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")
        
        present(scanView!, animated: false, completion: nil)
        
    }
    
    @IBAction func logOut() {
        
        AuthService.instance.performSignOut()
                
        let scanView = storyboard?.instantiateViewController(withIdentifier: "LogInVC")
        
        present(scanView!, animated: false, completion: nil)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.scanBtn.addTarget(self, action: #selector(MyDashboardVC.scanBtnPressed), for: .touchUpInside)
        
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
        
        self.titleLbl.setSpacing(space: 4.0)
        self.viewBtn.setSpacing(space: 4.0)
        self.scanBtn.setSpacing(space: 4.0)
        
        
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
            self.descLbl.text = "personal"
        } else if Int(currentPage) == 1 {
            self.descLbl.text = "business"
        } else if Int(currentPage) == 2 {
            self.descLbl.text = "my homes"
        } else if Int(currentPage) == 3 {
            self.descLbl.text = "my account"
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0.0
        
        let pageWidth = scrollView.frame.size.width
        let fractional = scrollView.contentOffset.x / pageWidth
        let page = lround(Double(fractional))
        
        self.pageCtrl.currentPage = page;
        
        if Int(page) == 0 {
            self.descLbl.text = "personal"
            self.scanBtn.backgroundColor = colours.goldColour()
            self.viewBtn.backgroundColor = colours.goldColour()
            self.scanBtn.setTitle("scan", for: .normal)
            UIView.animate(withDuration: 1.0) {
                self.viewBtn.alpha = 1.0
            }
            
            self.scanBtn.removeTarget(self, action: #selector(MyDashboardVC.logOut), for: .touchUpInside)
            self.scanBtn.addTarget(self, action: #selector(MyDashboardVC.scanBtnPressed), for: .touchUpInside)
            
            
        } else if Int(page) == 1 {
            self.descLbl.text = "business"
            self.viewBtn.backgroundColor = colours.pinkColour()
            self.scanBtn.backgroundColor = colours.pinkColour()
            self.scanBtn.setTitle("scan", for: .normal)
            UIView.animate(withDuration: 1.0) {
                self.viewBtn.alpha = 1.0
            }
            
            self.scanBtn.removeTarget(self, action: #selector(MyDashboardVC.logOut), for: .touchUpInside)
            self.scanBtn.addTarget(self, action: #selector(MyDashboardVC.scanBtnPressed), for: .touchUpInside)
            
        } else if Int(page) == 2 {
            self.descLbl.text = "my homes"
            self.viewBtn.backgroundColor = colours.purpleColour()
            self.scanBtn.backgroundColor = colours.purpleColour()
            self.scanBtn.setTitle("scan", for: .normal)
            UIView.animate(withDuration: 1.0) {
                self.viewBtn.alpha = 1.0
            }
            
            self.scanBtn.removeTarget(self, action: #selector(MyDashboardVC.logOut), for: .touchUpInside)
            self.scanBtn.addTarget(self, action: #selector(MyDashboardVC.scanBtnPressed), for: .touchUpInside)

        } else if Int(page) == 3 {
            self.descLbl.text = "my account"
            self.scanBtn.backgroundColor = colours.greenColour()
            self.scanBtn.setTitle("log out", for: .normal)
            self.viewBtn.superview?.backgroundColor = UIColor.white
            UIView.animate(withDuration: 1.0) {
                self.viewBtn.alpha = 0.0
            }
            
            self.scanBtn.removeTarget(self, action: #selector(MyDashboardVC.scanBtnPressed), for: .touchUpInside)
            self.scanBtn.addTarget(self, action: #selector(MyDashboardVC.logOut), for: .touchUpInside)

        }
        
    }

}
