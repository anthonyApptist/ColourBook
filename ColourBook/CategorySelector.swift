//
//  CategorySelector.swift
//  ColourBook
//
//  Created by Anthony Ma on 2017-08-30.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation

class CategorySelector: ColourBook {
    
    // MARK: - Retrieve
    func retrieveInfo() {
        switch self.screenState! {
        case .personal:
            break
        case .business:
            break
        case .homes:
            break
        default:
            break
        }
    }
    
    // MARK: - Get Personal Categories
    func getPersonalCategories() {
        
    }
    
    // MARK: - Get Business Address Categories
    func getBusinessAddressCategories() {
        
    }
    
    // MARK: - Get Home Address Categories
    func getHomeAddressCategories() {
        
    }
}
