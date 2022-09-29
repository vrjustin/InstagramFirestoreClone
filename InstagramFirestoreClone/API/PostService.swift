//
//  PostService.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/28/22.
//

import Foundation
import UIKit
import Firebase

struct PostService {
    static func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrlString in
            let data = ["caption":caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageUrl": imageUrlString,
                        "owner": uid,
                        "ownerImageUrl": user.profileImageUrl,
                        "ownerUsername": user.username] as [String: Any]
            
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
            
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let posts = documents.map({ Post(postId: $0.documentID, dataDictionary: $0.data())})
            completion(posts)
        }
    }
}
