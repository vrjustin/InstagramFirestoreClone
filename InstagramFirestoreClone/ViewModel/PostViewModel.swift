//
//  PostViewModel.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/29/22.
//

import Foundation


struct PostViewModel {
    
    let post: Post
    
    var imageUrl: URL? {
        return URL(string: post.imageUrl)
    }
    
    var userProfileImageUrl: URL? {
        return URL(string: post.ownerImageUrl)
    }
    
    var ownerUsername: String {
        return post.ownerUserName
    }
    
    var caption: String {
        return post.caption
    }
    
    var likes: Int {
        return post.likes
    }
    
    var likesLabelText: String {
        
        if likes != 1 {
            return "\(likes) likes"
        } else {
            return "\(likes) like"
        }
        
    }
    
    init(post: Post) {
        self.post = post
    }
    
}
