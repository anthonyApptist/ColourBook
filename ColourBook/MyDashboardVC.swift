
//
//  MyDashboardVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-11-25.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import MapKit

// show result for search result
protocol SelectedSearchResult {
    func showResult(location: Address)
}

// Home screen, dashboard, for user with five sections
// 1 - Personal list
// 2 - Business list
// 3 - Home list
// 4 - Search Addresses
// 5 - Log out

class MyDashboardVC: ColourBookVC, UIScrollViewDelegate {
    
    // Properties (storyboard)
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var scanBtn: UIButton!
    
    // logo img view for searching addresses w/ search bar in dashboard
    let logoImgView = UIImageView(image: kDarkGreenLogo) // logo for search bar view
    let searchTextField = UITextField()
    
    var iconsLoaded: Bool = false
    var descString: String! = "my bucket list"
    
    @IBOutlet weak var pageCtrl: UIPageControl!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    // cb dashboard
    var cbDashboard: ColourBookDashboard?
    
    // personal, business, homes, search bar, log out
    let pageOne = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
    let pageTwo = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
    let pageThree = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
    let pageFour = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
    let pageFive = IconView(frame: CGRect(x: 0, y: 0, width: 129, height: 183))
    
    // Search Controller
    var resultsUpdater: SearchResultsTableVC?
    var addressSC: UISearchController?
    var allAddress = [Address]()
    
    // MARK: - View Btn Pressed
    @IBAction func viewBtnPressed(_ sender: AnyObject?) {
        if self.titleLbl.text == "personal" {
            performSegue(withIdentifier: "ConnectToCategories", sender: self)
        }
        if self.titleLbl.text == "business" {
            performSegue(withIdentifier: "ConnectToBusiness", sender: self)
        }
        if self.titleLbl.text == "my homes" {
            performSegue(withIdentifier: "ConnectToAddresses", sender: self)
        }
    }
    
    // MARK: - Scan btn Pressed
    @IBAction func scanBtnPressed(_ sender: AnyObject?) {
        let scanView = storyboardInstantiate("BarcodeVC")
        self.present(scanView, animated: true, completion: nil)
    }
    
    // MARK: - Logout Fcn
    @IBAction func logOut() {
        AuthService.instance.performSignOut()
        let logInView = storyboardInstantiate("LogInVC")
        present(logInView, animated: false, completion: nil)
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButtonNeeded = false
        self.screenState = .personal
        self.pageCtrl.currentPage = 0

        // set window's root view controller to dashbaord
        app.window?.rootViewController = self
        
        // get user and public info
        
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        self.backBtn.isHidden = true
        app.window?.rootViewController = self
     
        self.scanBtn.addTarget(self, action: #selector(MyDashboardVC.scanBtnPressed), for: .touchUpInside)
        self.viewBtn.addTarget(self, action: #selector(MyDashboardVC.viewBtnPressed), for: .touchUpInside)
        
        // search controller set up
        resultsUpdater = SearchResultsTableVC()
        resultsUpdater?.searchFor = .addresses
        
        addressSC = UISearchController(searchResultsController: resultsUpdater)
        addressSC?.searchResultsUpdater = resultsUpdater
        
        // set results updater delegate link
        resultsUpdater?.dashboardDelegate = self
        
        let searchBar = addressSC?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search an address"
        
        addressSC?.hidesNavigationBarDuringPresentation = true
        addressSC?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
//        searchBar?.backgroundColor = UIColor.black

        // scroll view set up
        self.scrollView.isScrollEnabled = true
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        
        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        let scrollViewHeight: CGFloat = self.scrollView.frame.height
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 5, height: self.scrollView.frame.height)
        self.scrollView.delegate = self
        
        pageOne.frame.origin = CGPoint(x: scrollView.bounds.width/2 - pageOne.frame.width/2, y: scrollView.bounds.size.height/2 - pageOne.frame.height/2)
        pageOne.imageView = UIImageView(frame: CGRect(x: 23, y: 56, width: 85.9, height: 75))
        
        pageOne.imageView?.image = UIImage(named: "personalIcon")
        
        
        pageTwo.frame.origin = CGPoint(x: pageOne.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageTwo.frame.height/2)
        pageTwo.imageView = UIImageView(frame: CGRect(x: 26, y: 33, width: 77, height: 126))
        pageTwo.imageView?.image = UIImage(named: "moneyIcon")
        
        
        pageThree.frame.origin = CGPoint(x: pageTwo.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageThree.frame.height/2)
        pageThree.imageView = UIImageView(frame: CGRect(x: 33, y: 48, width: 66, height: 94))
        pageThree.imageView?.image = UIImage(named: "homeIcon")
        
       
        pageFour.frame.origin = CGPoint(x: pageThree.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageFour.frame.height/2)
        
   //     let textField = UITextField(frame: CGRect(x: 0, y: pageFour.frame.height/2 - pageFour.frame.height/2, width: UIScreen.main.bounds.width/2, height: pageFour.frame.height/2))
       
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.borderRect(forBounds: searchTextField.bounds)
        searchTextField.borderStyle = .roundedRect
        searchTextField.layer.borderColor = UIColor.black.cgColor
        searchTextField.textAlignment = .center
        searchTextField.placeholder = "Search an address"
        pageFour.addSubview(searchTextField)
        searchTextField.centerXAnchor.constraint(equalTo: pageFour.centerXAnchor).isActive = true
        searchTextField.centerYAnchor.constraint(equalTo: pageFour.centerYAnchor).isActive = true
        searchTextField.widthAnchor.constraint(equalTo: pageFour.widthAnchor, multiplier: 2.0).isActive = true
        searchTextField.heightAnchor.constraint(equalTo: pageFour.heightAnchor, multiplier: 0.2).isActive = true
//        searchTextField.isUserInteractionEnabled = false
     //   pageFour.imageView = UIImageView(frame: CGRect(x: 26, y: 56, width: 72, height: 81))
     //   pageFour.imageView?.image = UIImage(named: "search")
 
        searchTextField.delegate = self
        
        
        pageFive.frame.origin = CGPoint(x: pageFour.frame.origin.x + scrollViewWidth, y: scrollView.bounds.size.height/2 - pageFive.frame.height/2)
        pageFive.imageView = UIImageView(frame: CGRect(x: 12.2, y: 40, width: 106.6, height: 104.3))
        pageFive.imageView?.image = UIImage(named: "settingsIcon")

        
        if(iconsLoaded == false) {
            
            pageOne.addSubview(pageOne.imageView!)
            
            self.scrollView.addSubview(pageOne)
            
            pageTwo.addSubview(pageTwo.imageView!)
            
            self.scrollView.addSubview(pageTwo)
            
            pageThree.addSubview(pageThree.imageView!)
            
            self.scrollView.addSubview(pageThree)
            
            //    pageFour.addSubview(pageFour.imageView!)
            
            self.scrollView.addSubview(pageFour)
            
            pageFive.addSubview(pageFive.imageView!)
            
            self.scrollView.addSubview(pageFive)
            
            iconsLoaded = true
            
        }
        
        self.titleLbl.setSpacing(space: 4.0)
        self.viewBtn.setSpacing(space: 4.0)
        self.scanBtn.setSpacing(space: 4.0)
        
        self.screenState = .personal
        self.cbDashboard?.dashboardSetup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    // MARK: - Search Bar DidBeginEditing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.cbDashboard?.getPublicAddresses()
        
        self.present(self.addressSC!, animated: true) {
            self.searchTextField.endEditing(true)
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // personal
        if segue.identifier == "ConnectToCategories" {
            let destination = segue.destination as! CategoriesListVC
//            destination.businessImages = self.businessImages
            destination.screenState = .personal
        }
        // business
        if segue.identifier == "ConnectToBusiness" {
            let destination = segue.destination as! ItemListAddVC
            destination.businessImages = (self.cbDashboard?.businessImages)!
            destination.screenState = .business
        }
        // homes
        if segue.identifier == "ConnectToAddresses" {
            let destination = segue.destination as! ItemListAddVC
            destination.businessImages = (self.cbDashboard?.businessImages)!
            destination.screenState = .homes
        }
    }
    
    // MARK: - ScrollView DidEndScrolling
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
    
    // MARK: - Scroll ViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0.0
        
        let pageWidth = scrollView.frame.size.width
        let fractional = scrollView.contentOffset.x / pageWidth
        let page = lround(Double(fractional))

        self.pageCtrl.currentPage = page;
        
        self.titleLbl.setSpacing(space: 4.0)

        // Determines next page
        if Int(page) == 0 {
            
            if logoImgView.isDescendant(of: self.titleLbl) {
                logoImgView.removeFromSuperview()
            }
            
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
            
            if logoImgView.isDescendant(of: self.titleLbl) {
                logoImgView.removeFromSuperview()
            }
            
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
            
            if logoImgView.isDescendant(of: self.titleLbl) {
                logoImgView.removeFromSuperview()
            }
            
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
            
            
            self.titleString = ""
            self.titleLbl.text = self.titleString
            self.descString = ""
            self.descLbl.text = self.descString
            self.titleLbl.setSpacing(space: 4.0)
            self.screenState = .homes
            
            self.scanBtn.setTitle("scan", for: .normal)
            /*
            UIView.animate(withDuration: 1.0) {
                self.viewBtn.alpha = 1.0
            }
             */
            
            self.scanBtn.removeTarget(self, action: #selector(MyDashboardVC.logOut), for: .touchUpInside)
            self.scanBtn.addTarget(self, action: #selector(MyDashboardVC.scanBtnPressed), for: .touchUpInside)
            
            logoImgView.contentMode = .scaleAspectFit
            self.titleLbl.addSubview(logoImgView)
            logoImgView.translatesAutoresizingMaskIntoConstraints = false
            logoImgView.centerXAnchor.constraint(equalTo: self.titleLbl.centerXAnchor).isActive = true
            logoImgView.centerYAnchor.constraint(equalTo: self.titleLbl.centerYAnchor, constant: 40).isActive = true
            logoImgView.widthAnchor.constraint(equalTo: self.titleLbl.widthAnchor, multiplier: 0.6).isActive = true
            logoImgView.heightAnchor.constraint(equalTo: self.titleLbl.heightAnchor, multiplier: 0.6).isActive = true
            
        } else if Int(page) == 4 {
            
            if logoImgView.isDescendant(of: self.titleLbl) {
                logoImgView.removeFromSuperview()
            }
            
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

extension MyDashboardVC: SelectedSearchResult, ErrorLoading, AddressLoadingComplete {
    // show search result from search bar
    func showResult(location: Address) {
        let searchAddressVC = storyboard?.instantiateViewController(withIdentifier: "SearchAddressVC") as! SearchAddressVC
        searchAddressVC.allAddresses = self.allAddress
        searchAddressVC.currentLocation = location
        searchAddressVC.businessImages = (self.cbDashboard?.businessImages)!
        self.present(searchAddressVC, animated: true) {
            searchAddressVC.setResultsViewFor(location: searchAddressVC.currentLocation!)
        }
    }
    
    // MARK: - Error Loading
    func loadError(_ error: Error) {
        self.createAlertController(title: "Error", message: error.localizedDescription)
    }
    
    // MARK: - Address Loading Complete
    func addressLoadingComplete(allAddresses: [Address]) {
        self.allAddress = allAddresses
        self.resultsUpdater?.allAddresses = allAddresses
    }
    
}
