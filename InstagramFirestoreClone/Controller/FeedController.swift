//
//  FeedController.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/25/22.
//

import Foundation
import UIKit
import FirebaseAuth

private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {
    
    // MARK: - PROPERTIES
    
    private var posts = [Post]()
    var post: Post?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        fetchPosts()
    }
    
    // MARK: Actions
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self.tabBarController as? MainTabController
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } catch {
            print("DEBUG: Failed to signout!")
        }
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    
    // MARK: - API
    
    func fetchPosts() {
        guard post == nil else { return }
        
        PostService.fetchPosts { posts in
            self.posts = posts
            print("did fetch posts....")
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }

    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }
        
        navigationItem.title = "Feed"
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
}

// MARK: - UICollectionViewDataSource

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - FeedCellDelegate

extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(controller, animated: true)
    }
}
