//
//  PostViewModel.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/29/22.
//

import Foundation
import UIKit

struct PostViewModel {
    
    var post: Post
    
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
    
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    
    var likeButtonImage: UIImage {
        let retImageName = post.didLike ? "like_selected" : "like_unselected"
        return UIImage(imageLiteralResourceName: retImageName)
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
