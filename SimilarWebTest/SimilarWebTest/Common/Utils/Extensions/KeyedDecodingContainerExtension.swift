//
//  KeyedDecodingContainerExtension.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 08/01/2021.
//

import Foundation

extension KeyedDecodingContainer {
    func decode<T: RawRepresentable>(_ type: [T: URL].Type, forKey key: Key) throws -> [T: URL] where T.RawValue == String {
        let urlsDictionary = try self.decode([String: String].self, forKey: key)
        var result = [T: URL]()
        for (key, value) in urlsDictionary {
            if let kind = T(rawValue: key),
                let url = URL(string: value) {
                result[kind] = url
            }
        }
        return result
    }
}
