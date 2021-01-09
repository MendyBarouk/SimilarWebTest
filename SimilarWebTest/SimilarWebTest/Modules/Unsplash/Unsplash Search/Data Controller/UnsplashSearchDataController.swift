//
//  UnsplashSearchDataController.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 08/01/2021.
//

import Foundation
import ProcedureKit

protocol UnsplashSearchDataControllerDelegate: class {
    func dataControllerWillBringData(_ dataController: UnsplashSearchDataController)
    func dataController(_ dataController: UnsplashSearchDataController, didFinishBringDataWithError error: Error?)
}

class UnsplashSearchDataController {
    private lazy var currentCursor = self.initialCursor()
    private lazy var searchText = ""
    private var unsplashSearch: UnsplashSearch<UnsplashPhoto> = UnsplashSearch(total: 0, totalPage: 0, results: [])
    private let queue = ProcedureQueue()
    private weak var delegate: UnsplashSearchDataControllerDelegate?
    
    init(delegate: UnsplashSearchDataControllerDelegate) {
        self.delegate = delegate
    }
    
    func performQuery(searchText: String) {
        self.searchText = searchText
        currentCursor = initialCursor()
        fetchData()
    }
    
    func shouldLoadMore() -> Bool {
        currentCursor = nextCursor()
        fetchData()
        return true
    }
}

private extension UnsplashSearchDataController {
    func fetchData() {
        queue.cancelAllOperations()
        let bringJsonOperation = BringJsonOperation(requestOperation: UnsplashPhotosSearchRequestOperation(query: searchText, cursor: currentCursor))
        bringJsonOperation.addDidFinishBlockObserver(synchronizedWith: DispatchQueue.main) { [weak self] (bringJsonOperation, error) in
            guard let self = self else { return }
            guard !bringJsonOperation.isCancelled else { return }
            
            self.unsplashSearch = bringJsonOperation.output.value?.value ?? UnsplashSearch(total: 0, totalPage: 0, results: [])
            self.delegate?.dataController(self, didFinishBringDataWithError: bringJsonOperation.output.error)
        }
        
        queue.addOperation(bringJsonOperation)
    }
    func initialCursor() -> UnsplashPagedCursor {
        return UnsplashPagedCursor(page: 1)
    }
    func nextCursor() -> UnsplashPagedCursor {
        return UnsplashPagedCursor(page: currentCursor.page + 1)
    }
}

extension UnsplashSearchDataController: ReusableDataController {
    typealias Object = UnsplashPhoto
    func numberOfItems(in section: Int) -> Int {
        return unsplashSearch.results.count
    }
    
    func object(at indexPath: IndexPath) -> UnsplashPhoto {
        precondition(0..<unsplashSearch.results.count ~= indexPath.row)
        return unsplashSearch.results[indexPath.row]
    }
}
