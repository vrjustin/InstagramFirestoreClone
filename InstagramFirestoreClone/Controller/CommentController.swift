//
//  CommentController.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/29/22.
//

import Foundation
import UIKit

private let collectionViewCellIdentifier = "commentCollectionViewCellIdentifier"

class CommentController: UICollectionViewController {
    
    // MARK: - PROPERTIES
    
    private let post: Post
    
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccessoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - LIFECYCLE
    
    init(post: Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        navigationItem.title = "Comments"

        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
}

// MARK: - UICollectionViewDataSource

extension CommentController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}

// MARK: - CommentInputAccessoryViewDelegate

extension CommentController: CommentInputAccessoryViewDelegate {
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String) {
        guard let tab = self.tabBarController as? MainTabController else { return }
        guard let user = tab.user else { return }
        showLoader(true)
        CommentsService.uploadComment(comment: comment, postID: post.postId, user: user) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Error uploading comment to firebase. error is: \(error.localizedDescription)")
                return
            }
            inputView.clearCommentTextView()
        }
        
    }
}
