//
//  NotificationService.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/30/22.
//

import Foundation
import Firebase

struct NotificationService {
    
    static func uploadNotification(toUserWithUid uid: String, type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard currentUid != uid else { return }
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()

        var data: [String:Any] = ["timestamp": Timestamp(date: Date()),
                                  "uid": currentUid,
                                  "type": type.rawValue,
                                  "id": docRef.documentID]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotifications() {
        
    }
    
}
