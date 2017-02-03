//
//  ReportHandler.swift
//  ColourBook
//
//  Created by Mark Meritt on 2017-02-02.
//  Copyright © 2017 Apptist. All rights reserved.
//

import Foundation
import UIKit

class ReportHandler:NSObject {
    
    static let sharedInstance = ReportHandler()
    
    let reportView = FlagView()
    
    func show(container: UIViewController) {
        
        reportView.messageContent.text = "Report This Item? Tell Us Why"
        container.view.addblurView(on: true, blurEffect: reportView.blurEffect, blurview: reportView.blurEffectView)
        reportView.showView()
        container.view.addSubview(reportView)
        
    }
    
}
