//
//  User.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/26/22.
//

import Foundation

struct User {
    let email: String
    let fullName: String
    let profileImageUrl: String
    let uid: String
    let username: String
    
    init(withDataDictionary dataDictionary: [String:Any]) {
        self.email = dataDictionary["email"] as? String ?? ""
        self.fullName = dataDictionary["fullName"] as? String ?? ""
        self.profileImageUrl = dataDictionary["profileImageUrl"] as? String ?? ""
        self.uid = dataDictionary["uid"] as? String ?? ""
        self.username = dataDictionary["username"] as? String ?? ""
    }
}
