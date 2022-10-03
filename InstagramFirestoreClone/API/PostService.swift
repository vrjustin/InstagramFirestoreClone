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
            
            
            let docRef = COLLECTION_POSTS.addDocument(data: data, completion: completion)
            
            self.updateUserFeedAfterPost(postId: docRef.documentID)
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            let posts = documents.map({ Post(postId: $0.documentID, dataDictionary: $0.data())})
            completion(posts)
        }
    }
    
    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        let query = COLLECTION_POSTS
            .whereField("owner", isEqualTo: uid)
        
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            var posts = documents.map({ Post(postId: $0.documentID, dataDictionary: $0.data())})
            
            //since firebase does not allow us to use the whereField and a orderBy function at the same time. First use the whereField above and now we'll manually sort the returned posts.
            posts.sort { post1, post2 in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            
            completion(posts)
        }
        
    }
    
    static func fetchPost(withPostId postId: String, completion: @escaping(Post) -> Void) {
        COLLECTION_POSTS.document(postId).getDocument { snapshot, error in
            if let error = error {
                print("DEBUG: Error getting Post: \(postId) error: \(error.localizedDescription)")
                return
            }
            guard let document = snapshot else { return }
            guard let data = document.data() else { return }
            let post = Post(postId: document.documentID, dataDictionary: data)
            completion(post)
        }
    }
    
    static func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes + 1])
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard post.likes > 0 else { return }
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes":post.likes - 1])
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).delete() { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
        }
    }
    
    static func checkIfUserLikedPost(post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        COLLECTION_USERS.document(uid).collection("user-likes")
            .document(post.postId)
            .getDocument { snapshot, error in
            
                guard let didLike = snapshot?.exists else { return }
                completion(didLike)
        }
    }
    
    static func fetchFeedPosts(completion: @escaping([Post]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var posts = [Post]()
        
        COLLECTION_USERS.document(uid).collection("user-feed").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                fetchPost(withPostId: document.documentID) { post in
                    posts.append(post)
                    //Need to sort these before returning via completion handler.
                    posts.sort { post1, post2 in
                        return post1.timestamp.seconds > post2.timestamp.seconds
                    }
                    
                    completion(posts)
                }
            })
        }
        
    }
    
    static func updateUserFeedAfterFollowing(user: User, didFollow: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_POSTS
            .whereField("owner", isEqualTo: user.uid)
        query.getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: Error getting posts error: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            let docIDs = documents.map({ $0.documentID })
            
            docIDs.forEach { docId in
                if didFollow {
                    COLLECTION_USERS.document(uid).collection("user-feed").document(docId).setData([:])
                } else {
                    COLLECTION_USERS.document(uid).collection("user-feed").document(docId).delete()
                }
            }
            
        }
    }
    
    /*
     This is not the most efficient way to handle this. Ideally the updating of userfeed should occur on
     the backend just when a post is uploaded. One network call in that case.
     */
    private static func updateUserFeedAfterPost(postId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        //First get the list of followers for that uid.
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: Error retreiving followers for uid: \(uid) with error: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                COLLECTION_USERS.document(document.documentID).collection("user-feed").document(postId).setData([:])
            }
            COLLECTION_USERS.document(uid).collection("user-feed").document(postId).setData([:])
        }
    }
}
