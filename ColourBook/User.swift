//
//  User.swift
//  PoplurDemo
//
//  Created by Anthony Ma on 29/9/2016.
//  Copyright © 2016 Anthony Ma. All rights reserved.
//

import UIKit

class User {
    
    var items: [Any]
    
    var uid: String
    var email: String
    var name: String
    var image: String?
    
    init(uid: String, email: String, name: String, image: String) {
        self.uid = uid
        self.email = email
        self.name = name
        self.image = image
        self.items = []
    }


}
