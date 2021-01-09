//
//  NetworkRequestOperation.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 09/01/2021.
//

import Foundation
import ProcedureKit

class NetworkRequestOperation<T:Decodable>: Procedure, OutputProcedure {
    typealias ResponseType = T
    typealias Output = URLRequest
    private var _output: Pending<ProcedureResult<Output>> = .pending
    private let lock = NSLock()
    var output: Pending<ProcedureResult<Output>> {
        get { return lock.withCriticalScope { _output } }
        set {
            lock.withCriticalScope {
                _output = newValue
            }
        }
    }
    
    enum Method: String {
        case get, post, put, delete
    }
    
    enum QueryFormat {
        case json, urlEncoded
    }

    enum QueryType {
        case body, path
    }
    
    enum RequestError: Error {
        case invalidURL, noHTTPResponse, http(status: Int)

        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL."
            case .noHTTPResponse:
                return "Not a HTTP response."
            case .http(let status):
                return "HTTP error: \(status)."
            }
        }
    }
    
    var endpoint: String { return "" }
    var method: NetworkRequestOperation.Method { return .get }
    var format: NetworkRequestOperation.QueryFormat { return .urlEncoded }
    var type: NetworkRequestOperation.QueryType { return .path }
    var timeoutInterval = 30.0
    
    // MARK: - Prepare the request
    func prepareURLComponents() -> URLComponents? {
        return URLComponents()
    }

    func prepareParameters() -> [String: Any]? {
        return nil
    }

    func prepareHeaders() -> [String: String]? {
        return nil
    }

    func prepareURLRequest() throws -> URLRequest {
        let parameters = prepareParameters()

        guard let url = prepareURLComponents()?.url else {
            throw RequestError.invalidURL
        }

        switch type {
        case .body:
            var mutableRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
            if let parameters = parameters {
                switch format {
                case .json:
                    mutableRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                case .urlEncoded:
                    mutableRequest.httpBody = queryParameters(parameters, urlEncoded: true).data(using: .utf8)
                }
            }
            return mutableRequest

        case .path:
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.query = queryParameters(parameters)
            return URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
        }
    }

    private func queryParameters(_ parameters: [String: Any]?, urlEncoded: Bool = false) -> String {
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: ".-_")

        var query = ""
        parameters?.forEach { key, value in
            let encodedValue: String
            if let value = value as? String {
                encodedValue = urlEncoded ? value.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? "" : value
            } else {
                encodedValue = "\(value)"
            }
            query = "\(query)\(key)=\(encodedValue)&"
        }
        return query
    }
    
    override func execute() {
        guard !isCancelled else { finish(); return }
        do {
            var request = try prepareURLRequest()
            request.allHTTPHeaderFields = prepareHeaders()
            request.httpMethod = method.rawValue
            finish(withResult: .success(request))
        } catch {
            finish(withResult: .failure(error))
        }
    }
}
