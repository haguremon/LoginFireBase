//
//  User.swift
//  LoginTestFirebase
//
//  Created by IwasakIYuta on 2021/09/09.
//

import Foundation
import Firebase

struct User {
    
    let name: String
    let createdAt: Timestamp
    let email: String
    
    init(dic: [String: Any]) {
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
    }
}
