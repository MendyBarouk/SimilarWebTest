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
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    private var dataController: UnsplashSearchDataController!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.verticalScrollIndicatorInsets.top = 80
        tableView.prefetchDataSource = self
        dataController = UnsplashSearchDataController(delegate: self)
        dataController.performQuery(searchText: nil)
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
                cell.unsplashImageView.sd_setImage(with: unsplashPhoto.urls[.thumb], placeholderImage: image)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return activityIndicator
    }
    
    // MARK: - Table view delegate
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController else { return }
        guard let unsplashDetailsViewController = navigationController.topViewController as? UnsplashDetailsViewController else { return }
        guard let unsplashSearchTVC = sender as? UnsplashSearchTableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: unsplashSearchTVC) else { return }
        unsplashDetailsViewController.bindData(with: dataController.object(at: indexPath), imageAlreadyDownloaded: unsplashSearchTVC.unsplashImageView.image)
    }

    // MARK: - IBActions
    @IBAction func refreshControlValueChanged(_ sender: UIRefreshControl) {
        dataController.performQuery(searchText: searchBar.text)
    }
}

// MARK: - UITableViewDataSourcePrefetching Implementation
private typealias UnsplashSearchTableViewController_UITableViewDataSourcePrefetching = UnsplashSearchTableViewController
extension UnsplashSearchTableViewController_UITableViewDataSourcePrefetching: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard indexPaths.contains(IndexPath(row: dataController.numberOfItems(in: 0)-1, section: 0)) else { return }
        if dataController.shouldLoadMore() {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - UISearchBarDelegate Implementation
private typealias UnsplashSearchTableViewController_UISearchBarDelegate = UnsplashSearchTableViewController
extension UnsplashSearchTableViewController_UISearchBarDelegate: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tableView.setContentOffset(.zero, animated: false)
        dataController.performQuery(searchText: searchBar.text)
        searchBar.resignFirstResponder()
    }
}

// MARK: - UISearchBarDelegate Implementation
private typealias UnsplashSearchTableViewController_UnsplashSearchDataControllerDelegate = UnsplashSearchTableViewController
extension UnsplashSearchTableViewController_UnsplashSearchDataControllerDelegate: UnsplashSearchDataControllerDelegate {
    func dataControllerWillBringData(_ dataController: UnsplashSearchDataController) {
        activityIndicator.startAnimating()
    }
    
    func dataController(_ dataController: UnsplashSearchDataController, didFinishBringDataWithError error: Error?) {
        tableView.reloadData()
        refreshControl?.endRefreshing()
        activityIndicator.stopAnimating()
        if let error = error {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true)
        }
    }
}
