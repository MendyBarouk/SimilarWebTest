//
//  UnsplashSearch.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 08/01/2021.
//

import Foundation

struct UnsplashSearch<T:Codable>: Codable {
    let total: Int
    let totalPage: Int
    let results: [T]
    
    private enum CodingKeys: String, CodingKey {
        case total
        case totalPage = "total_pages"
        case results
    }
}
