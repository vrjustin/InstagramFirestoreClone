//
//  UserService.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/26/22.
//

import Foundation
import FirebaseAuth

typealias FirestoreCompletion = (Error?) -> Void

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
    
    static func fetchUsers(completion: @escaping ([User]) -> Void) {
        COLLECTION_USERS.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let users = snapshot.documents.map({ User(withDataDictionary: $0.data()) })
            completion(users)
        }
    }
    
    static func followUser(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unfollowUser(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
}
