//
//  UnsplashSearchRequestOperation.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 09/01/2021.
//

import Foundation

class UnsplashSearchRequestOperation<T:Codable>: UnsplashPagedRequestOperation<UnsplashSearch<T>> {
    
    private let query: String
    init(query: String, cursor: UnsplashPagedCursor, configuration: UnsplashAPIConfiguration = UnsplashAPIConfiguration()) {
        self.query = query
        super.init(with: cursor, configuration: configuration)
    }
    
    override func prepareParameters() -> [String : Any]? {
        var parameters = super.prepareParameters() ?? [:]
        
        parameters["query"] = query
        
        return parameters
    }
}
