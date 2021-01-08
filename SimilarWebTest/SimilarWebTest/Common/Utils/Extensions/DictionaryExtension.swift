//
//  DictionaryExtension.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 08/01/2021.
//

import Foundation

extension Dictionary {
    func convert<T, U>(_ transform: ((key: Key, value: Value)) throws -> (T, U)) rethrows -> [T: U] {
        var dictionary = [T: U]()
        for (key, value) in self {
            let transformed = try transform((key, value))
            dictionary[transformed.0] = transformed.1
        }
        return dictionary
    }
}
