//
//  ColourBook.swift
//  ColourBook
//
//  Created by Anthony Ma on 2017-08-25.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import FirebaseDatabase

// default object for controlling retrieving information
class ColourBook: NSObject {
    
    // screen state for info
    var screenState: ScreenState?
    
    // database reference for screen
    var reference: DatabaseReference?
    
    // protocol: ErrorLoading
    var errorDelegate: ErrorLoading?
    
    // protocol: LoadingComplete
    var loadDelegate: LoadingComplete?
    
    // Init
    init(screenState: ScreenState) {
        super.init()
        
        self.screenState = screenState
    }
    
    // MARK: - Remove Database Observers
    func removeDatabaseObservers() {
        self.reference?.removeAllObservers()
    }
}
