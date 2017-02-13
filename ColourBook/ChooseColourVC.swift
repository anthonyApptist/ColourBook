//
//  ChooseColourViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 13/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol ColourResult {
    func setResultFor(colour: Colour)
}

class ChooseColourVC: CustomVC, UISearchBarDelegate {
    
    var colourAddedDelegate: ColourAdded?
    
    var colourSC: UISearchController?
    
    var selectedColour: Colour?
    
    var hexcode: String?
    
    // view variables
    var searchColourButton: UIButton!
    var addToPaintButton: UIButton!
    var searchResultView: UIView!
    
    var coloursArray: [Colour] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showActivityIndicator()
        view.backgroundColor = UIColor.white
        
        // Search Controller
        let resultsUpdater = SearchResultsTableVC()
        resultsUpdater.searchFor = .colours
        
        colourSC = UISearchController(searchResultsController: resultsUpdater)
        colourSC?.searchResultsUpdater = resultsUpdater
        
        // set results updater delegate link
        resultsUpdater.colourResultDelegate = self
        
        let searchBar = colourSC?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search for colour"
        
        colourSC?.hidesNavigationBarDuringPresentation = true
        colourSC?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        searchBar?.backgroundColor = UIColor.black
        
        DataService.instance.paintDataRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for productCode in snapshot.children.allObjects {
                let colourProfile = productCode as? FIRDataSnapshot
                let paintData = colourProfile?.value as? NSDictionary
                let manufacturerID = paintData?["manufacturerID"] as! String
                let manufacturer = paintData?["manufacturer"] as! String
                let colourName = paintData?["colourName"] as! String
                let colourHexCode = paintData?["hexcode"] as! String
                let productCode = colourProfile?.key
                let colour = Colour(manufacturerID: manufacturerID, productCode: productCode!, colourName: colourName, colourHexCode: colourHexCode, manufacturer: manufacturer)
                self.coloursArray.append(colour)
            }
            resultsUpdater.allColours = self.coloursArray
            self.hideActivityIndicator()
            self.searchColourButton.isUserInteractionEnabled = true
        })
        
        
        //MARK: View
        
        // search results view
        
        searchResultView = UIView(frame: CGRect(x: 0, y: self.backBtn.frame.maxY, width: view.frame.width, height: view.frame.height - (2 * (view.frame.height * 0.10)) - 65))
    
        // search colour button
        
        addToPaintButton = UIButton(type: .system)
        addToPaintButton.frame = CGRect(x: 0, y: view.frame.maxY - (view.frame.height * 0.10) - (view.frame.height * 0.10), width: view.frame.width, height: view.frame.height * 0.10)
        addToPaintButton.setTitle("Add To Paint", for: .normal)
        addToPaintButton.isUserInteractionEnabled = true
        addToPaintButton.setTitleColor(UIColor.white, for: .normal)
        addToPaintButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: addToPaintButton.frame.height * 0.4)
        addToPaintButton.backgroundColor = UIColor.black
        addToPaintButton.titleLabel?.alpha = 0.0
        
        // add to paint button
        searchColourButton = UIButton(type: .system)
        searchColourButton.frame = CGRect(x: 0, y: view.frame.maxY - (view.frame.height * 0.10), width: view.frame.width, height: view.frame.height * 0.10)
        searchColourButton.setTitle("Search", for: .normal)
        searchColourButton.addTarget(self, action: #selector(searchColourButtonFunction), for: .touchUpInside)
        searchColourButton.isUserInteractionEnabled = false
        searchColourButton.setTitleColor(UIColor.white, for: .normal)
        searchColourButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: searchColourButton.frame.height * 0.4)
        searchColourButton.backgroundColor = UIColor.black
        
        // add to view
    
        view.addSubview(searchResultView)
        view.addSubview(searchColourButton)
        view.addSubview(addToPaintButton)
        
    }
    
    // Search
    
    func searchColourButtonFunction() {
        present(self.colourSC!, animated: true) {
            
        }
    }
    
    // MARK: Add to Paint
    
    func addToPaintFunction() {
        
        // sets label in post scan VC
        colourAddedDelegate?.setLabelFor(colour: self.hexcode!)
        // save selected colour to paint
        colourAddedDelegate?.set(colour: self.selectedColour!)
        
        dismiss(animated: true, completion: nil)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

extension ChooseColourVC: ColourResult {
    func setResultFor(colour: Colour) {
        let colourView = ColourView(frame: self.searchResultView.bounds, colour: colour)
        
        self.hexcode = colour.colourHexCode
        print(self.hexcode)
        
        // current colour
        self.selectedColour = colour
        self.searchResultView.addSubview(colourView)
        
        // add to paint button
        
        UIView.animate(withDuration: 1.0, animations: {
            self.addToPaintButton.titleLabel?.alpha = 1.0
            self.addToPaintButton.addTarget(self, action: #selector(self.addToPaintFunction), for: .touchUpInside)
        })
    }
}
