//
//  SearchResultsTableVC.swift
//  ColourBook
//
//  Created by Anthony Ma on 23/12/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

enum ResultsFor {
    case colours
    case addresses
}

class SearchResultsTableVC: UITableViewController {
    
    var searchFor: ResultsFor?
    
    // colour search result delegate
    var colourResultDelegate: ColourResult?
    
    // address search result delegate
    var addressResultDelegate: AddressResult?
    
    var filteredAddresses: [Location]?
    
    var filteredColours: [Colour]?
    
    var allColours: [Colour]?
    
    var allAddresses: [Location]?
    
    var query: String?

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
        return 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchFor == .colours {
            let cell = tableView.dequeueReusableCell(withIdentifier: "colour") as! ProductCell
            let colour = filteredColours?[indexPath.row]
            cell.box1?.text = colour?.colourName
            cell.box2?.text = colour?.productCode
            cell.box3?.backgroundColor = UIColor(hexString: (colour?.colourHexCode)!)
            return cell
        }
        else if searchFor == .addresses {
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
            
            filteredAddresses = allAddresses!.filter { location in
                let code = location.postalCode.lowercased()
                let locationName = location.locationName.lowercased()
                return locationName.contains(searchText) || code.contains(searchText)
            }
            tableView.reloadData()
        }
    }

    // String to UIImage
    
    func stringToImage(imageName: String) -> UIImage { // add to extensions
        let imageDataString = imageName
        let imageData = Data(base64Encoded: imageDataString)
        let image = UIImage(data: imageData!)
        return image!
    }

}

extension SearchResultsTableVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!.lowercased())
    }
}
