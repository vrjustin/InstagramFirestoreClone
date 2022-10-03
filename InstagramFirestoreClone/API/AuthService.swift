//
//  AuthService.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/26/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    
    static func loginUser(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }

    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping (Error?) -> Void) {
        ImageUploader.uploadImage(image: credentials.profileImage) { profileImageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                
                if let error = error {
                    print("DEBUG: Failed to register new user on firebase! due to: \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data: [String: Any] = ["email": credentials.email,
                                           "fullName": credentials.fullname,
                                           "profileImageUrl": profileImageUrl,
                                           "uid": uid,
                                           "username": credentials.username]
            
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
                
            }
        }
        
    }
    
    static func resetPassword(withEmail email: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
}
