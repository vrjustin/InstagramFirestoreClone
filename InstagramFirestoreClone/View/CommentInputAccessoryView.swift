//
//  CommentInputAccessoryView.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/29/22.
//

import Foundation
import UIKit

class CommentInputAccessoryView: UIView {
    
    // MARK: - PROPERTIES
    
    private let commentTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeHolderText = "Enter comment.."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.placeholderShouldCenter = true
        return tv
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(CommentInputAccessoryView.self, action: #selector(handlePostTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LIFECYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor,
                               bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor,
                               paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - ACTIONS
    
    @objc func handlePostTapped() {
        print("Handle Post Tapped...")
    }
}
