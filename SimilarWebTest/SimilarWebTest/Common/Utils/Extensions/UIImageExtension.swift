//
//  UIImageExtension.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 10/01/2021.
//

import UIKit

extension UIImage {
    func getHeightKeepingRatioByWidth(_ width: CGFloat, adjustedInset: UIEdgeInsets = UIEdgeInsets.zero) -> CGFloat {
        let ratio = size.width / size.height
        let height = width / ratio
        return height - (adjustedInset.top + adjustedInset.bottom)
    }
}
