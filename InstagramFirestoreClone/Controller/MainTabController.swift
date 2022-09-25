//
//  MainTabController.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/25/22.
//

import Foundation
import UIKit

class MainTabController: UITabBarController {
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    //MARK: - Helpers
    
    func configureViewControllers() {
        view.backgroundColor = .white

        let feed = FeedController()
        let search = SearchController()
        let imageSelector = ImageSelectorController()
        let notification = NotificationController()
        let profile = ProfileController()
        
        viewControllers = [feed, search, imageSelector, notification, profile]
        
        
    }
}
