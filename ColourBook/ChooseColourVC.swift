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
    
    var colourView: ColourResultsVC?
    
    var coloursArray: [Colour] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        //MARK: View

        // search colour text field

        searchColourTextfield = UITextField(frame: CGRect(x: 0, y: 25, width: view.frame.width, height: 40))
        searchColourTextfield.placeholder = "Search for colour"
        searchColourTextfield.adjustsFontSizeToFitWidth = true
        searchColourTextfield.textColor = UIColor.black
        searchColourTextfield.backgroundColor = UIColor.white
        searchColourTextfield.textAlignment = .center
        
        // search results view
        
        searchResultView = UIView(frame: CGRect(x: 0, y: searchColourTextfield.frame.maxY, width: view.frame.width, height: view.frame.height - (2 * (view.frame.height * 0.10)) - 65))
    
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
        searchColourButton.isUserInteractionEnabled = true
        searchColourButton.setTitleColor(UIColor.white, for: .normal)
        searchColourButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: searchColourButton.frame.height * 0.4)
        searchColourButton.backgroundColor = UIColor.black
        
        // add to view
        
        view.addSubview(searchColourTextfield)
        view.addSubview(searchResultView)
        view.addSubview(searchColourButton)
        view.addSubview(addToPaintButton)
        
    }
    
    func searchColourButtonFunction() {
        
        if searchColourTextfield.text != nil {
            let colourQuery = searchColourTextfield.text?.capitalized
            
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
                    if colour.colourName == colourQuery! {
                        
                        // set results VC
                        self.colourView = ColourResultsVC(frame: self.searchResultView.bounds, colour: colour)
                        self.currentColour = colour.colourHexCode // set current colour as hexcode
                        self.searchResultView.addSubview(self.colourView!)
                        self.searchColourTextfield.text = ""
                        
                        UIView.animate(withDuration: 1.0, animations: { 
                            self.addToPaintButton.titleLabel?.alpha = 1.0
                            self.addToPaintButton.addTarget(self, action: #selector(self.addToPaintFunction), for: .touchUpInside)
                        })

                        break
                    }
                    if colour.colourHexCode == colourQuery! {
                        
                        self.colourView = ColourResultsVC(frame: self.searchResultView.bounds, colour: colour)
                        self.currentColour = colour.colourHexCode
                        self.searchResultView.addSubview(self.colourView!)
                        self.searchColourTextfield.text = ""
                        
                        UIView.animate(withDuration: 1.0, animations: {
                            self.addToPaintButton.titleLabel?.alpha = 1.0
                            self.addToPaintButton.addTarget(self, action: #selector(self.addToPaintFunction), for: .touchUpInside)
                        })
                        
                        break
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
        
        // if colour is in database
        if self.currentColour == "" {
            
            let alertView = UIAlertController(title: "No colour searched", message: "type to search for a new colour", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertView.addAction(alertAction)
            
            present(alertView, animated: true, completion: nil)
        }
        else {
            // add to paint
            self.paint?.colour = self.currentColour!
            
            dismiss(animated: true, completion: nil)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchColourTextfield.resignFirstResponder()
    }
}
