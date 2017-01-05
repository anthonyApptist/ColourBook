
//
//  MyDashboardVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-11-25.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import MapKit

class MyDashboardVC: CustomVC, UIScrollViewDelegate {
    
    let colours = UIColours(col: UIColor.clear)
    
    var btnPressed: Bool = false
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var descLbl: UILabel!
    
    var descString: String! = "my bucket list"
        
    @IBOutlet weak var viewBtn: UIButton!
    
    
    @IBOutlet weak var scanBtn: UIButton!
    
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var pageCtrl: UIPageControl!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func viewBtnPressed(_ sender: AnyObject?) {
        
        self.backButtonNeeded = true 
        
        if self.titleLbl.text == "personal" {

            performSegue(withIdentifier: "ConnectToPersonal", sender: self)
            
        }
        
        if self.titleLbl.text == "business" {
            
            performSegue(withIdentifier: "ConnectToBusiness", sender: self)
        }
        
        if self.titleLbl.text == "my homes" {
            
            performSegue(withIdentifier: "ConnectToAddresses", sender: self)
        }
        
        if self.titleLbl.text == "search" {
            
            performSegue(withIdentifier: "ConnectToSearch", sender: self)
        }
        
      
    }
    
    @IBAction func scanBtnPressed(_ sender: AnyObject?) {
        
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")
        
        present(scanView!, animated: true, completion: nil)
        
    }
    
    @IBAction func logOut() {
        
        AuthService.instance.performSignOut()
                
        let logInView = storyboard?.instantiateViewController(withIdentifier: "LogInVC")
        
        present(logInView!, animated: false, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButtonNeeded = false
        self.screenState = .personal
        self.pageCtrl.currentPage = 0
        
        app.window?.rootViewController = self

    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
  
    
    override func viewDidAppear(_ animated: Bool) {
    
        super.viewDidAppear(false)
    
        locationAuthStatus()
        
        self.backBtn.isHidden = true
        
        app.window?.rootViewController = self
     
        self.scanBtn.addTarget(self, action: #selector(MyDashboardVC.scanBtnPressed), for: .touchUpInside)
        
        self.viewBtn.addTarget(self, action: #selector(MyDashboardVC.viewBtnPressed), for: .touchUpInside)
        
        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        let scrollViewHeight: CGFloat = self.scrollView.frame.height
        
        self.scrollView.isScrollEnabled = true
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        
        let pageOne = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
        pageOne.frame.origin = CGPoint(x: scrollView.bounds.size.width/2 - pageOne.frame.width/2, y: scrollView.bounds.size.height/2 - pageOne.frame.height/2)
        pageOne.imageView = UIImageView(frame: CGRect(x: 23, y: 56, width: 85.9, height: 75))
        pageOne.addSubview(pageOne.imageView!)
        pageOne.imageView?.image = UIImage(named: "personalIcon")
        self.scrollView.addSubview(pageOne)
        
        let pageTwo = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
        pageTwo.frame.origin = CGPoint(x: pageOne.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageTwo.frame.height/2)
        pageTwo.imageView = UIImageView(frame: CGRect(x: 26, y: 33, width: 77, height: 126))
        pageTwo.addSubview(pageTwo.imageView!)
        pageTwo.imageView?.image = UIImage(named: "moneyIcon")
        self.scrollView.addSubview(pageTwo)
        
        let pageThree = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
        pageThree.frame.origin = CGPoint(x: pageTwo.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageThree.frame.height/2)
        pageThree.imageView = UIImageView(frame: CGRect(x: 33, y: 48, width: 66, height: 94))
        pageThree.addSubview(pageThree.imageView!)
        pageThree.imageView?.image = UIImage(named: "homeIcon")
        self.scrollView.addSubview(pageThree)
        
        let pageFour = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
        pageFour.frame.origin = CGPoint(x: pageThree.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageFour.frame.height/2)
        pageFour.imageView = UIImageView(frame: CGRect(x: 26, y: 56, width: 72, height: 81))
        pageFour.addSubview(pageFour.imageView!)
        pageFour.imageView?.image = UIImage(named: "search")
        self.scrollView.addSubview(pageFour)
        
        let pageFive = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
        pageFive.frame.origin = CGPoint(x: pageFour.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageFive.frame.height/2)
        pageFive.imageView = UIImageView(frame: CGRect(x: 12.2, y: 40, width: 106.6, height: 104.3))
        pageFive.addSubview(pageFive.imageView!)
        pageFive.imageView?.image = UIImage(named: "settingsIcon")
        self.scrollView.addSubview(pageFive)
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 5, height: self.scrollView.frame.height)
        self.scrollView.delegate = self
        
        self.titleLbl.setSpacing(space: 4.0)
        self.viewBtn.setSpacing(space: 4.0)
        self.scanBtn.setSpacing(space: 4.0)
        
        
    }
    
   
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1
        
        self.pageCtrl.currentPage = Int(currentPage)
        
        if Int(currentPage) == 0 {
            self.titleString = "personal"
            self.titleLbl.text = self.titleString
            self.descString = "my bucket list"
            self.descLbl.text = self.descString
            self.titleLbl.setSpacing(space: 4.0)
            self.screenState = .personal

        } else if Int(currentPage) == 1 {
            self.titleString = "business"
            self.titleLbl.text = self.titleString
            self.descString = "company bucket list"
            self.descLbl.text = self.descString
            self.titleLbl.setSpacing(space: 4.0)
            self.screenState = .business

        } else if Int(currentPage) == 2 {
            self.titleString = "my homes"
            self.titleLbl.text = self.titleString
            self.descString = "home address bucket list"
            self.descLbl.text = self.descString
            self.titleLbl.setSpacing(space: 4.0)
            self.screenState = .homes

        } else if Int(currentPage) == 3 {
            self.titleString = "search"
            self.titleLbl.text = self.titleString
            self.descString = "find any list in the world"
            self.descLbl.text = self.descString
            self.titleLbl.setSpacing(space: 4.0)
            self.screenState = .none
            
        } else if Int(currentPage) == 4 {
            self.titleString = "my account"
            self.titleLbl.text = self.titleString
            self.descString = ""
            self.descLbl.text = self.descString
            self.titleLbl.setSpacing(space: 4.0)

        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0.0
        
        let pageWidth = scrollView.frame.size.width
        let fractional = scrollView.contentOffset.x / pageWidth
        let page = lround(Double(fractional))
        
        self.pageCtrl.currentPage = page;
        
        self.titleLbl.setSpacing(space: 4.0)

        
        if Int(page) == 0 {
            self.titleString = "personal"
            self.titleLbl.text = self.titleString
            self.descString = "my bucket list"
            self.descLbl.text = self.descString
            self.titleLbl.setSpacing(space: 4.0)
            self.screenState = .personal

            self.scanBtn.setTitle("scan", for: .normal)
            UIView.animate(withDuration: 1.0) {
                self.viewBtn.alpha = 1.0
            }
            
            self.scanBtn.removeTarget(self, action: #selector(MyDashboardVC.logOut), for: .touchUpInside)
            self.scanBtn.addTarget(self, action: #selector(MyDashboardVC.scanBtnPressed), for: .touchUpInside)
            
            
        } else if Int(page) == 1 {
            self.titleString = "business"
            self.titleLbl.text = self.titleString
            self.descString = "company bucket list"
            self.descLbl.text = self.descString
            self.titleLbl.setSpacing(space: 4.0)
            self.screenState = .business

            self.scanBtn.setTitle("scan", for: .normal)
            UIView.animate(withDuration: 1.0) {
                self.viewBtn.alpha = 1.0
            }
            
            self.scanBtn.removeTarget(self, action: #selector(MyDashboardVC.logOut), for: .touchUpInside)
            self.scanBtn.addTarget(self, action: #selector(MyDashboardVC.scanBtnPressed), for: .touchUpInside)
            
        } else if Int(page) == 2 {
            self.titleString = "my homes"
            self.titleLbl.text = self.titleString
            self.descString = "home bucket list"
            self.descLbl.text = self.descString
            self.titleLbl.setSpacing(space: 4.0)
            self.screenState = .homes

            self.scanBtn.setTitle("scan", for: .normal)
            UIView.animate(withDuration: 1.0) {
                self.viewBtn.alpha = 1.0
            }
            
            self.scanBtn.removeTarget(self, action: #selector(MyDashboardVC.logOut), for: .touchUpInside)
            self.scanBtn.addTarget(self, action: #selector(MyDashboardVC.scanBtnPressed), for: .touchUpInside)

        } else if Int(page) == 3 {
            self.titleString = "search"
            self.titleLbl.text = self.titleString
            self.descString = "find any list"
            self.descLbl.text = self.descString
            self.titleLbl.setSpacing(space: 4.0)
            self.screenState = .homes
            
            self.scanBtn.setTitle("scan", for: .normal)
            UIView.animate(withDuration: 1.0) {
                self.viewBtn.alpha = 1.0
            }
            
            self.scanBtn.removeTarget(self, action: #selector(MyDashboardVC.logOut), for: .touchUpInside)
            self.scanBtn.addTarget(self, action: #selector(MyDashboardVC.scanBtnPressed), for: .touchUpInside)
            
        } else if Int(page) == 4 {
            self.titleString = "my account"
            self.titleLbl.text = self.titleString
            self.descString = ""
            self.descLbl.text = self.descString
            self.titleLbl.setSpacing(space: 4.0)

            self.scanBtn.setTitle("log out", for: .normal)
            UIView.animate(withDuration: 1.0) {
                self.viewBtn.alpha = 0.0
            }
            
            self.scanBtn.removeTarget(self, action: #selector(MyDashboardVC.scanBtnPressed), for: .touchUpInside)
            self.scanBtn.addTarget(self, action: #selector(MyDashboardVC.logOut), for: .touchUpInside)

        }
        
    }

}
