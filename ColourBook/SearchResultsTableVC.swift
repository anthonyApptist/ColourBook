//
//  SearchResultsTableVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 23/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit
import GooglePlaces

enum ResultsFor {
    case colours
    case addresses
    case mapSearch
}

class SearchResultsTableVC: UITableViewController {
    
    var searchFor: ResultsFor?
    
    // colour search result delegate
    var colourResultDelegate: ColourResult?
    
    // address search result delegate
    var addressResultDelegate: AddressResult?
    
    // dashboard search result delegate
    var dashboardDelegate: SelectedSearchResult?
    
    // filtered data
    var filteredAddresses: [Location]?
    var filteredColours: [Colour]?
    
    // all data
    var allColours: [Colour]?
    var allAddresses = [Location]()
    
    // google map data
    var allLocations: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        
        if searchFor == .colours {
            self.filteredColours = []
            self.tableView.register(ProductCell.self, forCellReuseIdentifier: "colour")
        }
        
        if searchFor == .addresses {
            self.filteredAddresses = []
            self.tableView.register(LocationCell.self, forCellReuseIdentifier: "address")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchFor == .colours {
            return (filteredColours?.count)!
        }
        if searchFor == .addresses {
            return (filteredAddresses?.count)!
        }
        if searchFor == .mapSearch {
            return (allLocations?.count)!
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchFor == .colours {
            let cell = tableView.dequeueReusableCell(withIdentifier: "colour") as! ProductCell
            let colour = filteredColours?[indexPath.row]
            cell.box1?.text = colour?.colourName
            cell.box2?.text = colour?.productCode
            
            // hexcode
            if (colour?.colourHexCode.contains("-"))! {
                let rgb = colour?.colourHexCode.components(separatedBy: "-")
                let red = Float((rgb?[0])!)
                let green = Float((rgb?[1])!)
                let blue = Float((rgb?[2])!)
                
                cell.box3?.backgroundColor = UIColor(colorLiteralRed: red!/255, green: green!/255, blue: blue!/255, alpha: 1.0)
            }
            else {
                cell.box3?.backgroundColor = UIColor(hexString: (colour?.colourHexCode)!)
            }
            
            return cell
        }
        if searchFor == .addresses {
            let cell = tableView.dequeueReusableCell(withIdentifier: "address") as! LocationCell
            let location = filteredAddresses?[indexPath.row]
            cell.box1?.text = location?.locationName
            cell.box2?.text = location?.postalCode
            // check custom image
            if location?.image == nil || location?.image == "" {
                cell.addressImageView?.image = UIImage(named: "homeIcon")
            }
            else {
                cell.addressImageView?.image = self.stringToImage(imageName: (location?.image)!)
            }
            return cell
        }
        if searchFor == .colours {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")
            cell?.textLabel?.text = self.allLocations?[indexPath.row]
            return cell!
        }

        return UITableViewCell()
    }
    
    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchFor == .colours {
            let selectedColour = filteredColours?[indexPath.row]
            colourResultDelegate?.setResultFor(colour: selectedColour!)
            dismiss(animated: true) {
                
            }
        }
        if searchFor == .addresses {
            let selectedAddress = filteredAddresses?[indexPath.row]
            addressResultDelegate?.setResultsViewFor(location: selectedAddress!)
            dismiss(animated: true) {
                self.dashboardDelegate?.showResult(location: selectedAddress!)
            }
        }
    }

    // filter search query
    func filterContentForSearchText(searchText: String) {
        if searchFor == .colours {
            
            filteredColours = allColours!.filter { colour in
                let productCode = colour.productCode.lowercased()
                let colourName = colour.colourName.lowercased()
                return productCode.contains(searchText) || colourName.contains(searchText)
            }
            tableView.reloadData()
        }
        if searchFor == .addresses {
            
            filteredAddresses = allAddresses.filter { location in
                let code = location.postalCode.lowercased()
                let locationName = location.locationName.lowercased()
                return locationName.contains(searchText) || code.contains(searchText)
            }
            tableView.reloadData()
        }
        if searchFor == .mapSearch {
            
            GMSPlacesClient.shared().autocompleteQuery(searchText, bounds: nil, filter: nil, callback: { (results, error) in
                self.allLocations?.removeAll()
                if results == nil {
                    return
                }
                for result in results! {
                    if let results = result as? GMSAutocompletePrediction {
                        self.allLocations?.append(results.attributedFullText.string)
                    }
                    self.tableView.reloadData()
                }
            })
            
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let parent = self.parent as! UISearchController
        parent.searchBar.resignFirstResponder()
    }

    // String to UIImage
    
    func stringToImage(imageName: String) -> UIImage { // add to extensions
        let imageDataString = imageName
        let imageData = Data(base64Encoded: imageDataString)
        let image = UIImage(data: imageData!)
        return image!
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder() 
    }
}

extension SearchResultsTableVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!.lowercased())
    }
}
