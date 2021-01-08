//
//  UnsplashSearchTableViewController.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 07/01/2021.
//

import UIKit

class UnsplashSearchTableViewController: UITableViewController {
    
    // MARK: - Properies
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        
        searchController.searchBar.scopeButtonTitles = ["latest", "oldest", "popular"]
        
        return searchController
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    // MARK: - Table view delegate
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UISearchControllerDelegate Implementation
private typealias UnsplashSearchTableViewController_UISearchControllerDelegate = UnsplashSearchTableViewController
extension UnsplashSearchTableViewController_UISearchControllerDelegate: UISearchControllerDelegate {
    
}

// MARK: - UISearchResultsUpdating Implementation
private typealias UnsplashSearchTableViewController_UISearchResultsUpdating = UnsplashSearchTableViewController
extension UnsplashSearchTableViewController_UISearchResultsUpdating: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

// MARK: - UISearchBarDelegate Implementation
private typealias UnsplashSearchTableViewController_UISearchBarDelegate = UnsplashSearchTableViewController
extension UnsplashSearchTableViewController_UISearchBarDelegate: UISearchBarDelegate {
    
}
