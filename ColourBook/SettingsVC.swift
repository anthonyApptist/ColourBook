//
//  SettingsVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-06.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class SettingsVC: CustomVC, UIScrollViewDelegate {
    
    var selectedBusinessInfo: Business?
    
    var selectedAddressInfo: Address?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(false)

        // Do any additional setup after loading the view.
        
        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        let scrollViewHeight: CGFloat = self.scrollView.frame.height
        
        self.scrollView.isScrollEnabled = true
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView?.showsVerticalScrollIndicator = false
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        self.scrollView.delegate = self
        

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
      
        if segue.identifier == "ShowInfo" {
            
            
            if self.screenState == .business {
                
                if let detail = segue.destination as? AddEditImageVC {
                    
                    detail.businessItem = selectedBusinessInfo
                    detail.screenState = screenState
                }
            } else if self.screenState == .homes {
                
                if let detail = segue.destination as? AddEditImageVC {
                    
                    detail.addressItem = selectedAddressInfo
                    detail.screenState = screenState
                }
            }
        }
        
        if segue.identifier == "ShowMapDetails" {
            
            
            if self.screenState == .business {
                
                if let detail = segue.destination as? AddressListDetailVC {
                    
                    detail.businessItem = selectedBusinessInfo
                    detail.screenState = screenState
                }
            } else if self.screenState == .homes {
                
                if let detail = segue.destination as? AddressListDetailVC {
                    
                    detail.addressItem = selectedAddressInfo
                    detail.screenState = screenState
                }
            }
        }
        
    }
    

}
