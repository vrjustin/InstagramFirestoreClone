//
//  AuthService.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/26/22.
//

import Foundation
import UIKit

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static func registerUser(withCredential credentials: AuthCredentials) {
        print("DEBUG: Credentials are: \(credentials)")
    }
}
