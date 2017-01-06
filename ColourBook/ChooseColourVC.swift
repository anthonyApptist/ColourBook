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
        
        searchColourTextfield = UITextField(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height * 0.05))
        
        searchColourTextfield.placeholder = "search for your colour"
        
        searchColourTextfield.textColor = UIColor.black
        
        searchColourTextfield.backgroundColor = UIColor.white
        
        searchColourTextfield.textAlignment = .center
        
        // search results view
        
        searchResultView = UIView(frame: CGRect(x: 0, y: 40 + view.frame.height * 0.05, width: view.frame.width, height: view.frame.height - (view.frame.height * 0.05) - (view.frame.height * 0.05) - (view.frame.height * 0.05) - 40))
        
//        searchResultView.backgroundColor = UIColor.clear
    
        // search colour button
        
        searchColourButton = UIButton(frame: CGRect(x: view.center.x - ((view.frame.width)/2), y: view.frame.maxY - (view.frame.height * 0.05) - (view.frame.height * 0.05), width: view.frame.width, height: view.frame.height * 0.05))
        
        searchColourButton.setTitle("Search", for: .normal)
        
        searchColourButton.addTarget(self, action: #selector(searchColourButtonFunction), for: .touchUpInside)
        
        searchColourButton.isUserInteractionEnabled = true
        
        searchColourButton.setTitleColor(UIColor.white, for: .normal)
        
        searchColourButton.backgroundColor = UIColor.black
        
        // add to paint button
        
        addToPaintButton = UIButton(frame: CGRect(x: view.center.x - ((view.frame.width)/2), y: view.frame.maxY - (view.frame.height * 0.05), width: view.frame.width, height: view.frame.height * 0.05))
        
        addToPaintButton.setTitle("Add to Paint", for: .normal)
        
        addToPaintButton.addTarget(self, action: #selector(addToPaintFunction), for: .touchUpInside)
        
        addToPaintButton.isUserInteractionEnabled = true
        
        addToPaintButton.setTitleColor(UIColor.white, for: .normal)
        
        addToPaintButton.backgroundColor = UIColor.black
        
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
                        
                        self.colourView = ColourResultsVC(frame: self.searchResultView.bounds, colour: colour)
                        
                        self.currentColour = colour.colourHexCode // set current colour as hexcode
                        
                        print(self.currentColour!)
                        
//                        self.paint?.colour = self.currentColour! // add to paint object
                        
                
                        self.searchResultView.addSubview(self.colourView!)
                        
                        
                        
                        print(self.colourView!.colourName.frame)
                        
                        print(self.searchResultView.frame)
                        
                        print(self.colourView?.frame)
                        
                        self.searchColourTextfield.text = ""

                        break
                        
                    }
                    
                    if colour.colourHexCode == colourQuery! {
                        
                        self.colourView = ColourResultsVC(frame: self.searchResultView.frame, colour: colour)
                        
                        self.currentColour = colour.colourHexCode
                        
//                        self.paint?.colour = self.currentColour!
                        
                        self.searchResultView.addSubview(self.colourView!)
                        
                        self.searchColourTextfield.text = ""
                        
                        break

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
