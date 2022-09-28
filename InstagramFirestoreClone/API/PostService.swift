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
    static func uploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrlString in
            let data = ["caption":caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageUrl": imageUrlString,
                        "owner": uid] as [String: Any]
            
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
            
        }
    }
}
