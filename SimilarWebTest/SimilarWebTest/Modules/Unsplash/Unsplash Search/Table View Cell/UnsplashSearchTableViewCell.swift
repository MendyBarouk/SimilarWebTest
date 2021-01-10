//
//  UnsplashSearchTableViewCell.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 08/01/2021.
//

import UIKit

class UnsplashSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var unsplashImageView: UIImageView!
    @IBOutlet weak var descriptionLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        unsplashImageView.layer.masksToBounds = true
        unsplashImageView.layer.borderWidth = 0.5
        unsplashImageView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        unsplashImageView.layer.cornerRadius = unsplashImageView.frame.width/2
    }
}
