//
//  Post.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/29/22.
//

import Foundation
import Firebase

struct Post {
    let postId: String
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let timestamp: Timestamp
    let ownerImageUrl: String
    let ownerUserName: String
    
    init(postId: String, dataDictionary: [String:Any]) {
        self.postId = postId
        self.caption = dataDictionary["caption"] as? String ?? ""
        self.likes = dataDictionary["likes"] as? Int ?? 0
        self.imageUrl = dataDictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dataDictionary["owner"] as? String ?? ""
        self.ownerImageUrl = dataDictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUserName = dataDictionary["ownerUsername"] as? String ?? ""
        self.timestamp = dataDictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
