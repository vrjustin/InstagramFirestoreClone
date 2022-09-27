//
//  SearchController.swift
//  InstagramFirestoreClone
//
//  Created by Justin Maronde on 9/25/22.
//

import Foundation
import UIKit

private let userCellIdentifier = "userCellIdentifier"

class SearchController: UITableViewController {
    
    //MARK: - PROPERTIES
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    //MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: userCellIdentifier)
        tableView.rowHeight = 64
    }
}

//MARK: - UITableViewDataSource

extension SearchController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellIdentifier, for: indexPath)
        return cell
    }
    
}
