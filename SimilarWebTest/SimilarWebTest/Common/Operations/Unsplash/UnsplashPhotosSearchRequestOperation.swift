//
//  UnsplashPhotosSearchRequestOperation.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 09/01/2021.
//

import Foundation

class UnsplashPhotosSearchRequestOperation: UnsplashSearchRequestOperation<UnsplashPhoto> {
    enum OrderBy: String {
        case relevant, latest
    }
    private let orderBy: OrderBy
    init(orderBy: OrderBy = .relevant, query: String, cursor: UnsplashPagedCursor, configuration: UnsplashAPIConfiguration = UnsplashAPIConfiguration()) {
        self.orderBy = orderBy
        super.init(query: query, cursor: cursor, configuration: configuration)
    }
    
    override var endpoint: String { "/search/photos" }
    
    override func prepareParameters() -> [String : Any]? {
        var parameters = super.prepareParameters() ?? [:]
        
        parameters["order_by"] = orderBy.rawValue
        parameters["orientation"] = "landscape"
        
        return parameters
    }
}
