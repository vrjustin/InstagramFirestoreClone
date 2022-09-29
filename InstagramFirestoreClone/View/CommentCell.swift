//
//  CommentCell.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/29/22.
//

import Foundation
import UIKit

class CommentCell: UICollectionViewCell {
    // MARK: - PROPERTIES
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "username_here ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "Some test hardcoded comment here...", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedString
        return label
    }()
    
    // MARK: - LIFECYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(commentLabel)
        commentLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
