//
//  ErrorHandler.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-02.
//  Copyright © 2016 Apptist. All rights reserved.
//

import Foundation
import UIKit

typealias okResponse = () -> Void

class ErrorHandler: NSObject {
    static let sharedInstance = ErrorHandler()
    let errorMessageView = MessageView()
    
    func show(message: String, container: UIViewController) {
        //Show Message View With Message
        errorMessageView.messageContent.text = message
        errorMessageView.offsetImagePosition()
        container.view.addSubview(errorMessageView)
        
    }
    
    func show(title: String, message: String, buttonText: String, container: UIViewController, onOK:okResponse) {
        //Show Alert View With Alert
    }
    
}
