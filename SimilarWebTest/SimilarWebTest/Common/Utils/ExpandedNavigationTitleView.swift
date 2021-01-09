//
//  ExpandedNavigationTitleView.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 09/01/2021.
//

import UIKit

@IBDesignable
class ExpandedNavigationTitleView: UIView {
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}
