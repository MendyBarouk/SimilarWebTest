//
//  UnsplashDetailsPageViewController.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 10/01/2021.
//

import UIKit

protocol PagerDataController {
    associatedtype Object
    func currentObject() -> Object
    func previousObject() -> Object?
    func nextObject() -> Object?
    func didSelect(object: Object)
}

class UnsplashDetailsPageViewController: UIPageViewController {
    
    private var dataController: UnsplashSearchDataController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        if let dataController = self.dataController {
            setViewControllers([generateUnsplashDetailsC(with: dataController.currentObject())], direction: .forward, animated: false, completion: nil)
        }
    }
}

extension UnsplashDetailsPageViewController {
    func bindData(_ dataController: UnsplashSearchDataController) {
        self.dataController = dataController
    }
}

private extension UnsplashDetailsPageViewController {
    func generateUnsplashDetailsC(with unsplashPhoto: UnsplashPhoto) -> UnsplashDetailsViewController {
        let unsplashDetailsVC = storyboard!.instantiateViewController(withIdentifier: "\(UnsplashDetailsViewController.self)") as! UnsplashDetailsViewController
        unsplashDetailsVC.bindData(with: unsplashPhoto)
        return unsplashDetailsVC
    }
    
    func extractCurrentUnplashPhoto() -> UnsplashPhoto? {
        guard let unsplashDetailsVC = viewControllers?.first as? UnsplashDetailsViewController else { return nil }
        return unsplashDetailsVC.unsplashPhoto
    }
}

private typealias UnsplashDetailsPageViewController_UIPageViewController = UnsplashDetailsPageViewController
extension UnsplashDetailsPageViewController_UIPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let previousUnsplashPhoto = dataController?.previousObject() else { return nil }
        return generateUnsplashDetailsC(with: previousUnsplashPhoto)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let nextUnsplashPhoto = dataController?.nextObject() else { return nil }
        return generateUnsplashDetailsC(with: nextUnsplashPhoto)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        guard let currrentUnsplashPhoto = extractCurrentUnplashPhoto() else { return }
        dataController?.didSelect(object: currrentUnsplashPhoto)
    }
}
