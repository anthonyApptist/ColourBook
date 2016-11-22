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
    
    @IBOutlet weak var iconView: UIView!
    
    @IBOutlet weak var skipLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        

        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        let scrollViewHeight: CGFloat = self.scrollView.frame.height
        
        self.scrollView.isScrollEnabled = true
        self.scrollView.isPagingEnabled = true
        
        self.iconView.backgroundColor = UIColor.init(red: 210/255, green: 197/255, blue: 173/255, alpha: 1.0)
        
        self.iconView.layer.cornerRadius = 16
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 3, height: self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageCtrl.currentPage = 0
        
       
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       /*
        self.skipBtn.setBorderWidth()
        self.skipBtn.setSpacing(space: 4.0)
        self.titleLbl.setSpacing(space: 6.0)
        self.skipLbl.setSpacing(space: 4.0)
 */
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
            self.scanLbl.text = "Scan your product"
         
        } else if Int(page) == 1 {
            self.scanLbl.text = "View your product"

        } else if Int(page) == 2 {
            self.scanLbl.text = "Add your product to your Personal Bucket List"
            self.scanLbl.numberOfLines = 3
            
        } else if Int(page) == 3 {
            self.scanLbl.text = "Add your product to your home"
            
            
        }
        
    }
}



