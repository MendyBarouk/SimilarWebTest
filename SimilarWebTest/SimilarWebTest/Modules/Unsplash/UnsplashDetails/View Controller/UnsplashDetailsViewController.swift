//
//  UnsplashDetailsViewController.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 10/01/2021.
//

import UIKit

class UnsplashDetailsViewController: UIViewController {
    
    var unsplashPhoto: UnsplashPhoto!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UnsplashDetailsViewController {
    func bindData(with unsplashPhoto: UnsplashPhoto) {
        self.unsplashPhoto = unsplashPhoto
    }
}
