//
//  UserService.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/26/22.
//

import Foundation
import FirebaseAuth

struct UserService {
    static func fetchUser(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            if let error = error {
                print("DEBUG: error retrieving users data: error is: \(error.localizedDescription)")
            }
            guard let dataDictionary = snapshot?.data() else { return }
            
            let user = User(withDataDictionary: dataDictionary)
            completion(user)
        }
    }
}
