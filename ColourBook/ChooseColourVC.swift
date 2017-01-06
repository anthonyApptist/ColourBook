//
//  ChooseColourViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 13/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChooseColourVC: CustomVC {
    
    var paint: Paint?
    
    var currentColour: String?
    
    var searchColourTextfield: UITextField!
    
    var searchColourButton: UIButton!
    
    var addToPaintButton: UIButton!

    var searchResultView: UIView!
    
    var coloursArray: [Colour] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        //MARK: View

        // search colour text field
        
        searchColourTextfield = UITextField(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height * 0.05))
        
        searchColourTextfield.placeholder = "search for your colour"
        
        searchColourTextfield.textColor = UIColor.black
        
        searchColourTextfield.backgroundColor = UIColor.white
        
        searchColourTextfield.textAlignment = .center
        
        // search results view
        
        searchResultView = UIView(frame: CGRect(x: 0, y: 20 + view.frame.height * 0.05, width: 0, height: 0))
        
        searchResultView.backgroundColor = UIColor.black
        
        let colourTitle = UILabel(frame: CGRect(x: searchResultView.center.x - ((searchResultView.frame.width * 0.6)/2), y: searchResultView.center.y - ((searchResultView.frame.height * 0.1)/2), width: searchResultView.frame.width * 0.6, height: searchResultView.frame.height * 0.1))
        
        colourTitle.backgroundColor = UIColor.white
        
        colourTitle.text = "Colour"
        
        colourTitle.textColor = UIColor.black
        
        searchResultView.addSubview(colourTitle)
        
        // search colour button
        
        searchColourButton = UIButton(frame: CGRect(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.maxY - (3 * (view.frame.height * 0.05)) - 30, width: view.frame.width * 0.6, height: view.frame.height * 0.05))
        
        searchColourButton.setTitle("Search", for: .normal)
        
        searchColourButton.addTarget(self, action: #selector(searchColourButtonFunction), for: .touchUpInside)
        
        searchColourButton.isUserInteractionEnabled = true
        
        searchColourButton.setTitleColor(UIColor.white, for: .normal)
        
        searchColourButton.backgroundColor = UIColor.black
        
        // add to paint button
        
        addToPaintButton = UIButton(frame: CGRect(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.maxY - (2 * (view.frame.height * 0.05)) - 15, width: view.frame.width * 0.6, height: view.frame.height * 0.05))
        
        addToPaintButton.setTitle("Add to Paint", for: .normal)
        
        addToPaintButton.setTitleColor(UIColor.white, for: .normal)
        
        addToPaintButton.backgroundColor = UIColor.black
        
        // add to view
        
        view.addSubview(searchColourTextfield)
        
        view.addSubview(searchColourButton)
        
        view.addSubview(addToPaintButton)
        
        view.addSubview(searchResultView)
        
    }
    
    func searchColourButtonFunction() {
        
        if searchColourTextfield.text != nil {
            
            let searchQuery = searchColourTextfield.text?.capitalized
            
            // check database
            
            DataService.instance.paintDataRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                for hexcode in snapshot.children.allObjects {
                    
                    let colourProfile = hexcode as? FIRDataSnapshot
                    
                    let paintData = colourProfile?.value as? NSDictionary
                    
                    let manufacturerID = paintData?["manufacturerID"] as! String
                    
                    let productCode = paintData?["productCode"] as! String
                    
                    let colourName = paintData?["colourName"] as! String
                    
                    let colourHexCode = colourProfile?.key
                    
                    let colour = Colour(manufacturerID: manufacturerID, productCode: productCode, colourName: colourName, colourHexCode: colourHexCode!)
                    
                    self.coloursArray.append(colour)
                    
                }
                
                for colour in self.coloursArray {
                    
                    if colour.colourName == searchQuery! {
                        
                        let colourView = ColourResultsVC()
                        
                        colourView.colour = colour
                        
                        self.currentColour = colour.colourHexCode
                        
                        self.paint?.colour = self.currentColour!
                        
                        self.searchResultView.addSubview(colourView)
                    }
                    
                    if colour.colourHexCode == searchQuery! {
                        
                        let colourView = ColourResultsVC()
                        
                        colourView.colour = colour
                        
                        self.currentColour = colour.colourHexCode
                        
                        self.paint?.colour = self.currentColour!
                        
                        self.searchResultView.addSubview(colourView)

                    }
                    
                    /*
                    if self.coloursArray.last != searchQuery! {
                        
                            self.currentColour = ""
                            
                            let alertView = UIAlertController(title: "Result", message: "colour searched is not in database", preferredStyle: .alert)
                            
                            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
                            alertView.addAction(alertAction)
                            
                            self.present(alertView, animated: true, completion: nil)
                        
                    }
                    */
                    
                    else {
                        
                        
                        
                    }
                    
                    
                }
                
                
            })
        }
        
        else {
            let alertView = UIAlertController(title: "No colour to search for", message: "type in a colour", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertView.addAction(alertAction)
            
            present(alertView, animated: true, completion: nil)
        }
    }
    
    func addToPaintFunction() {
        
        // check if there was a search results/user selected colour
        
        if self.currentColour == "" {
            
            let alertView = UIAlertController(title: "No colour searched", message: "type to search for a new colour", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertView.addAction(alertAction)
            
            present(alertView, animated: true, completion: nil)
        }
            
        // if there is colour add hexcode to paint
        
        else {
            
            self.paint?.colour = self.currentColour!
            
            // transfer new paint profile back to post scan VC
            
            dismiss(animated: true, completion: nil)
            
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchColourTextfield.resignFirstResponder()
    }
}
