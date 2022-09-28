//
//  User.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/26/22.
//

import Foundation
import FirebaseAuth

struct User {
    let email: String
    let fullName: String
    let profileImageUrl: String
    let uid: String
    let username: String
    var isFollowed = false
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(withDataDictionary dataDictionary: [String:Any]) {
        self.email = dataDictionary["email"] as? String ?? ""
        self.fullName = dataDictionary["fullName"] as? String ?? ""
        self.profileImageUrl = dataDictionary["profileImageUrl"] as? String ?? ""
        self.uid = dataDictionary["uid"] as? String ?? ""
        self.username = dataDictionary["username"] as? String ?? ""
    }
}
