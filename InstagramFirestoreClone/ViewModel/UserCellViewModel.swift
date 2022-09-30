//
//  UserCellViewModel.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/27/22.
//

import Foundation

struct UserCellViewModel {
    private let user: User
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var userName: String {
        return user.username
    }
    
    var fullName: String {
        return user.fullName
    }
    
    init(user: User) {
        self.user = user
    }
}
