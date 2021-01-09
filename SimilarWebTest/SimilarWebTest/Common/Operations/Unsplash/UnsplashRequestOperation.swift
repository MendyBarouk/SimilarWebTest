//
//  UnsplashRequestOperation.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 09/01/2021.
//

import Foundation

class UnsplashRequestOperation<T:Decodable>: NetworkRequestOperation<T> {
    private let configuration: UnsplashAPIConfiguration
    init(configuration: UnsplashAPIConfiguration = UnsplashAPIConfiguration()) {
        self.configuration = configuration
        super.init()
    }
    override func prepareURLComponents() -> URLComponents? {
        guard let apiURL = URL(string: configuration.apiURL) else { return nil }
        
        var urlComponents = URLComponents(url: apiURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint
        return urlComponents
    }
    
    override func prepareHeaders() -> [String : String]? {
        var headers: [String : String] = [:]
        headers["Authorization"] = "Client-ID \(configuration.accessKey)"
        return headers
    }
}
