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
    func dataControllerShouldResetSelection(_ dataController: UnsplashSearchDataController)
    func dataController(_ dataController: UnsplashSearchDataController, didSelectObjectAtIndexPath indexPath: IndexPath)
}

class UnsplashSearchDataController {
    private lazy var currentCursor = self.initialCursor()
    private var searchText: String?
    private var unsplashSearch: UnsplashSearch<UnsplashPhoto> = UnsplashSearch(total: 0, totalPage: 0, results: [])
    private var selectedIndexPath: IndexPath?
    private let queue = ProcedureQueue()
    private weak var delegate: UnsplashSearchDataControllerDelegate?
    
    init(delegate: UnsplashSearchDataControllerDelegate) {
        self.delegate = delegate
    }
    
    func performQuery(searchText: String?) {
        self.searchText = searchText
        currentCursor = initialCursor()
        fetchData()
    }
    
    func shouldLoadMore() -> Bool {
        if let searchText = self.searchText, !searchText.isEmpty {
            guard nextCursor().page < unsplashSearch.totalPage else { return false }
        }
        currentCursor = nextCursor()
        fetchData()
        return true
    }
}

private extension UnsplashSearchDataController {
    func fetchSearchPhotos(with searchText: String) {
        let bringJsonOperation = BringJsonOperation(requestOperation: UnsplashPhotosSearchRequestOperation(query: searchText, cursor: currentCursor))
        bringJsonOperation.addWillExecuteBlockObserver(synchronizedWith: DispatchQueue.main) { [weak self] (_, event) in
            event.doBeforeEvent {
                guard let self = self else { return }
                self.delegate?.dataControllerWillBringData(self)
            }
        }
        bringJsonOperation.addDidFinishBlockObserver(synchronizedWith: DispatchQueue.main) { [weak self] (bringJsonOperation, error) in
            guard let self = self else { return }
            guard !bringJsonOperation.isCancelled else { return }
            
            if let unsplashSearch = bringJsonOperation.output.value?.value {
                if self.currentCursor.page == self.initialCursor().page {
                    self.initiateUnsplashSearch(with: unsplashSearch)
                } else {
                    self.unsplashSearch = UnsplashSearch(total: self.unsplashSearch.total, totalPage: self.unsplashSearch.totalPage, results: self.unsplashSearch.results + unsplashSearch.results)
                }
            }
            self.delegate?.dataController(self, didFinishBringDataWithError: bringJsonOperation.output.error)
        }
        
        queue.addOperation(bringJsonOperation)
    }
    
    func fetchPopularPhotos() {
        let bringJsonOperation = BringJsonOperation(requestOperation: UnsplashPhotosRequestOperation(with: currentCursor))
        bringJsonOperation.addWillExecuteBlockObserver(synchronizedWith: DispatchQueue.main) { [weak self] (_, event) in
            event.doBeforeEvent {
                guard let self = self else { return }
                self.delegate?.dataControllerWillBringData(self)
            }
        }
        bringJsonOperation.addDidFinishBlockObserver(synchronizedWith: DispatchQueue.main) { [weak self] (bringJsonOperation, error) in
            guard let self = self else { return }
            guard !bringJsonOperation.isCancelled else { return }
            
            if let unsplashPhotos = bringJsonOperation.output.value?.value {
                if self.currentCursor.page == self.initialCursor().page {
                    self.initiateUnsplashSearch(with: UnsplashSearch(total: 0, totalPage: 0, results: unsplashPhotos))
                } else {
                    self.unsplashSearch = UnsplashSearch(total: self.unsplashSearch.total, totalPage: self.unsplashSearch.totalPage, results: self.unsplashSearch.results + unsplashPhotos)
                }
            }
            self.delegate?.dataController(self, didFinishBringDataWithError: bringJsonOperation.output.error)
        }
        
        queue.addOperation(bringJsonOperation)
    }
    
    func fetchData() {
        queue.cancelAllOperations()
        if let searchText = self.searchText, !searchText.isEmpty {
            fetchSearchPhotos(with: searchText)
        } else {
            fetchPopularPhotos()
        }
    }
    
    func initiateUnsplashSearch(with unsplashSearch: UnsplashSearch<UnsplashPhoto>) {
        let isShouldReset: Bool
        if let selectedIndexPath = selectedIndexPath,
           self.unsplashSearch.results.indices.contains(selectedIndexPath.row),
           unsplashSearch.results.indices.contains(selectedIndexPath.row) {
            
            isShouldReset = unsplashSearch.results[selectedIndexPath.row] != self.unsplashSearch.results[selectedIndexPath.row]
        } else {
            isShouldReset = true
        }
        self.unsplashSearch = unsplashSearch
        if isShouldReset {
            self.selectedIndexPath = nil
            self.delegate?.dataControllerShouldResetSelection(self)
        }
    }
    
    func initialCursor() -> UnsplashPagedCursor {
        return UnsplashPagedCursor(page: 1)
    }
    
    func nextCursor() -> UnsplashPagedCursor {
        return UnsplashPagedCursor(page: currentCursor.page + 1)
    }
    
    func findIndexPath(from object: Object) -> IndexPath? {
        guard let index = unsplashSearch.results.firstIndex(of: object) else { return nil }
        return IndexPath(row: index, section: 0)
    }
}

extension UnsplashSearchDataController: ReusableDataController {
    typealias Object = UnsplashPhoto
    func numberOfItems(in section: Int) -> Int {
        return unsplashSearch.results.count
    }
    
    func object(at indexPath: IndexPath) -> UnsplashPhoto {
        precondition(unsplashSearch.results.indices.contains(indexPath.row))
        return unsplashSearch.results[indexPath.row]
    }
    
    func didSelect(at indexPath: IndexPath) {
        precondition(unsplashSearch.results.indices.contains(indexPath.row))
        selectedIndexPath = indexPath
    }
}

extension UnsplashSearchDataController: PagerDataController {
    func currentObject() -> UnsplashPhoto {
        precondition(selectedIndexPath != nil)
        return object(at: selectedIndexPath!)
    }
    
    func previousObject() -> UnsplashPhoto? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        let previousIndexPath = IndexPath(row: selectedIndexPath.row - 1, section: selectedIndexPath.section)
        guard 0..<unsplashSearch.results.count ~= previousIndexPath.row else { return nil}
        return object(at: previousIndexPath)
    }
    
    func nextObject() -> UnsplashPhoto? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        let nextIndexPath = IndexPath(row: selectedIndexPath.row + 1, section: selectedIndexPath.section)
        guard 0..<unsplashSearch.results.count ~= nextIndexPath.row else { return nil}
        return object(at: nextIndexPath)
    }
    
    func didSelect(object: UnsplashPhoto) {
        guard let selectedIndexPath = findIndexPath(from: object) else { return }
        self.selectedIndexPath = selectedIndexPath
        delegate?.dataController(self, didSelectObjectAtIndexPath: selectedIndexPath)
    }
}
