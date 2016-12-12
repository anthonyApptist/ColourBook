//
//  User.swift
//  PoplurDemo
//
//  Created by Anthony Ma on 29/9/2016.
//  Copyright © 2016 Anthony Ma. All rights reserved.
//

import UIKit

class User {
    
    private var _uid: String
    private var _email: String
    private var _name: String
    private var _imageName: String?
    
    var items: [PaintCan]
    
    var uid: String {
        return _uid
    }
    
    var email: String {
        return _email
    }
    
    var name: String {
        return _name
    }
    
    var imageName: String {
        return _imageName!
    }
    
    var image: UIImage?
    
    init(uid: String, email: String, name: String) {
        _uid = uid
        _email = email
        items = []
        _name = name
        _imageName = "darkred"
        
        self.image = UIImage(named: _imageName!)
    }
    
    func addItem(item: PaintCan) {
        items.append(item)
    }

}
