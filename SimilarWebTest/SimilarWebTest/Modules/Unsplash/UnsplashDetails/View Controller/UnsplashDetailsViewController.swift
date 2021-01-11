//
//  UnsplashDetailsViewController.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 10/01/2021.
//

import UIKit
import SDWebImage

class UnsplashDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userProfilImageView: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var usernameTookPictureLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!
    @IBOutlet weak var constraintTopProfileView: NSLayoutConstraint!
    var unsplashPhoto: UnsplashPhoto?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unsplashPhoto = unsplashPhoto {
            photoImageView.sd_setImage(with: unsplashPhoto.urls[.regular], placeholderImage: UIImage(blurHash: unsplashPhoto.blurHash, size: CGSize(width: 32, height: 32)))
            descriptionLabel.text = unsplashPhoto.description
            userProfilImageView.sd_setImage(with: unsplashPhoto.user.profileImage[.large])
            userFullNameLabel.text = unsplashPhoto.user.displayName
            usernameTookPictureLabel.text = unsplashPhoto.user.username
            likeLabel.text = "\(unsplashPhoto.likesCount) Likes"
            userBioLabel.text = unsplashPhoto.user.bio
        } else {
            scrollView.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        adjusteParallaxViewHeight()
    }
    
    private func adjusteParallaxViewHeight() {
        guard let unsplashPhoto = unsplashPhoto else { return }
        let ratio = CGFloat(unsplashPhoto.width)/CGFloat(unsplashPhoto.height)
        let idealHeightForHeaderView = photoImageView.frame.width/ratio
        print(idealHeightForHeaderView)
        constraintTopProfileView.constant = min(idealHeightForHeaderView, view.frame.midY)
    }
}

extension UnsplashDetailsViewController {
    func bindData(with unsplashPhoto: UnsplashPhoto) {
        self.unsplashPhoto = unsplashPhoto
    }
}
