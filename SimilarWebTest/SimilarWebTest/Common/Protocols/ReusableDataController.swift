//
//  ReusableDataController.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 08/01/2021.
//

import Foundation

protocol ReusableDataController {
    associatedtype Object
    func numberOfItems(in section: Int) -> Int
    func object(at indexPath: IndexPath) -> Object
}
