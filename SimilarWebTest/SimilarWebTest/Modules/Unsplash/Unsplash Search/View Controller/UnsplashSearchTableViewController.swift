//
//  UnsplashSearchTableViewController.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 07/01/2021.
//

import UIKit
import SDWebImage

class UnsplashSearchTableViewController: UITableViewController {
    
    // MARK: - Properies
    private lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.autocapitalizationType = .none
        searchBar.delegate = self
        return searchBar
    }()
    private var dataController: UnsplashSearchDataController!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.verticalScrollIndicatorInsets.top = 80
        dataController = UnsplashSearchDataController(delegate: self)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataController.numberOfItems(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UnsplashSearchTableViewCell.self)", for: indexPath) as! UnsplashSearchTableViewCell
        let unsplashPhoto = dataController.object(at: indexPath)
        
        cell.descriptionLabel.text = unsplashPhoto.description
        DispatchQueue.global(qos: .userInteractive).async {
            let image = UIImage(blurHash: unsplashPhoto.blurHash, size: CGSize(width: 32, height: 32))
            DispatchQueue.main.async {
                cell.unsplashImageView.sd_setImage(with: unsplashPhoto.urls[.small], placeholderImage: image)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    // MARK: - Table view delegate
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    // MARK: - IBActions
    @IBAction func refreshControlValueChanged(_ sender: UIRefreshControl) {
        dataController.performQuery(searchText: searchBar.text ?? "")
    }
}

// MARK: - UISearchBarDelegate Implementation
private typealias UnsplashSearchTableViewController_UISearchBarDelegate = UnsplashSearchTableViewController
extension UnsplashSearchTableViewController_UISearchBarDelegate: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dataController.performQuery(searchText: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}

// MARK: - UISearchBarDelegate Implementation
private typealias UnsplashSearchTableViewController_UnsplashSearchDataControllerDelegate = UnsplashSearchTableViewController
extension UnsplashSearchTableViewController_UnsplashSearchDataControllerDelegate: UnsplashSearchDataControllerDelegate {
    func dataControllerWillBringData(_ dataController: UnsplashSearchDataController) {
        
    }
    
    func dataController(_ dataController: UnsplashSearchDataController, didFinishBringDataWithError error: Error?) {
        tableView.reloadData()
        refreshControl?.endRefreshing()
        if let error = error {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true)
        }
    }
}
