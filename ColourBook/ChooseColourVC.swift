//
//  ChooseColourViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 13/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class ChooseColourVC: UIViewController {
    
    var colour: String?
    
    var searchColourTextfield: UITextField!
    
    var searchColourButton: UIButton!
    
    var addToPaintButton: UIButton!

    var searchResultView: UIView!
    
    var dismissButton: UIButton!
    
    var resultView: UIView!

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
        
        searchResultView = UIView(frame: CGRect(x: 0, y: 20 + view.frame.height * 0.05, width: view.frame.width, height: view.frame.height - (3 * (view.frame.height * 0.05 - 60))))
        
        searchResultView.backgroundColor = UIColor.clear
        
        let colourTitle = UILabel(frame: CGRect(x: searchResultView.center.x - ((searchResultView.frame.width * 0.6)/2), y: searchResultView.center.y - ((searchResultView.frame.height * 0.1)/2), width: searchResultView.frame.width * 0.6, height: searchResultView.frame.height * 0.1))
        
        colourTitle.backgroundColor = UIColor.white
        
        colourTitle.text = "Colour"
        
        colourTitle.textColor = UIColor.black
        
        searchResultView.addSubview(colourTitle)
        
        // search colour button
        
        searchColourButton = UIButton(frame: CGRect(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.maxY - (3 * (view.frame.height * 0.05)) - 30, width: view.frame.width * 0.6, height: view.frame.height * 0.05))
        
        searchColourButton.setTitle("Search", for: .normal)
        
        searchColourButton.addTarget(self, action: #selector(searchColourButtonFunction), for: .touchUpInside)
        
        searchColourButton.setTitleColor(UIColor.black, for: .normal)
        
        searchColourButton.backgroundColor = UIColor.white
        
        // add to paint button
        
        addToPaintButton = UIButton(frame: CGRect(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.maxY - (2 * (view.frame.height * 0.05)) - 15, width: view.frame.width * 0.6, height: view.frame.height * 0.05))
        
        addToPaintButton.setTitle("Add to Paint", for: .normal)
        
        addToPaintButton.setTitleColor(UIColor.black, for: .normal)
        
        addToPaintButton.backgroundColor = UIColor.white
        
        // dismiss button 
        
        dismissButton = UIButton(frame: CGRect(x: view.center.x - ((view.frame.width * 0.6)/2), y: view.frame.maxY - (1 * (view.frame.height * 0.05)), width: view.frame.width * 0.6, height: view.frame.height * 0.05))
        
        dismissButton.backgroundColor = UIColor.white
        
        dismissButton.setTitle("Back", for: .normal)
        
        dismissButton.addTarget(self, action: #selector(dismissButtonFunction), for: .touchUpInside)
        
        dismissButton.setTitleColor(UIColor.black, for: .normal)
        
        // add to view
        
        view.addSubview(searchColourTextfield)
        
        view.addSubview(searchColourButton)
        
        view.addSubview(addToPaintButton)
        
        view.addSubview(searchResultView)
        
        view.addSubview(dismissButton)
        
    }
    
    func searchColourButtonFunction() {
        
        if searchColourTextfield.text != nil {
            
            let searchQuery = searchColourTextfield.text?.capitalized
            
            // check database
            
            DataService.instance.paintDataRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(searchQuery!) {
                    
                    let colourView = ColourResultsVC()
                    
                    colourView.exist = true
                    
//                    snapshot.value = 
                    
                }
                
                else {
                    
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
    
    func dismissButtonFunction() {
        dismiss(animated: true, completion: nil)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchColourTextfield.resignFirstResponder()
    }
}
