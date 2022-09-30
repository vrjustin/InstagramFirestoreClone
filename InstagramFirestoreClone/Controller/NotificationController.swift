//
//  NotificationController.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/25/22.
//

import Foundation
import UIKit

private let notificationCellReuseIdentifier = "notificationCellReuseIdentifier"

class NotificationController: UITableViewController {
    
    // MARK: - PROPERTIES
    
    private var notifications = [Notification]() {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNotifications()
    }
    
    // MARK: - API
    
    func fetchNotifications() {
        NotificationService.fetchNotifications { notifications in
            self.notifications = notifications
        }
    }
    
    // MARK: - HELPERS
    
    private func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: notificationCellReuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
    }
}

// MARK: - UITableViewDelegate

extension NotificationController {
    
}

// MARK: - UITableViewDataSource

extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: notificationCellReuseIdentifier, for: indexPath) as! NotificationCell
        return cell
    }
}
