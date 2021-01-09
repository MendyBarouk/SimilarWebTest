//
//  UnsplashPagedRequestOperation.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 09/01/2021.
//

import Foundation

struct UnsplashPagedCursor {
    let page: Int
    let perPage: Int
    
    init(page: Int, perPage: Int = 10) {
        self.page = page
        self.perPage = perPage
    }
}

class UnsplashPagedRequestOperation<T:Decodable>: UnsplashRequestOperation<T> {
    
    
    private let cursor: UnsplashPagedCursor
    init(with cursor: UnsplashPagedCursor, configuration: UnsplashAPIConfiguration = UnsplashAPIConfiguration()) {
        self.cursor = cursor
        super.init(configuration: configuration)
    }
    
    override func prepareParameters() -> [String : Any]? {
        var parameters = super.prepareParameters() ?? [:]
        
        parameters["page"] = cursor.page
        parameters["per_page"] = cursor.perPage
        
        return parameters
    }
}
