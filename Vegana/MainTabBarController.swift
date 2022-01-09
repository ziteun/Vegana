//
//  MainTabBarController.swift
//  vegana
//
//  Created by hanatour on 2021/12/24.
//

import UIKit
import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        if Auth.auth().currentUser == nil {
            presentLoginController()
        } else {
            setupViewControllers()
        }
    }
    
    fileprivate func presentLoginController() {
        DispatchQueue.main.async {
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func setupViewControllers() {
        // Feed
        let layout = UICollectionViewFlowLayout ()
        layout.minimumLineSpacing = 0
        let homeNavController = templateNavController(unselectedImage: UIImage(systemName: "house")!.withTintColor(.label, renderingMode: .alwaysOriginal), selectedImage: UIImage(systemName: "house.fill")!.withTintColor(.label, renderingMode: .alwaysOriginal), rootViewController: HomeController(collectionViewLayout: layout))
        
        // Challenge
        let diaryController = templateNavController(unselectedImage: UIImage(named: "diary")!.withTintColor(.label, renderingMode: .alwaysOriginal), selectedImage: UIImage(named: "diary_fill")!.withTintColor(.label, renderingMode: .alwaysOriginal), rootViewController: ChallengeViewController())
        
        // Photo Share
        let plusNavController = templateNavController(unselectedImage: UIImage(systemName: "plus.square")!.withTintColor(.label, renderingMode: .alwaysOriginal), selectedImage: UIImage(systemName: "plus.square")!.withTintColor(.label, renderingMode: .alwaysOriginal))
        
        // Heart
        let likeNavController = templateNavController(unselectedImage: UIImage(systemName: "heart")!.withTintColor(.label, renderingMode: .alwaysOriginal), selectedImage: UIImage(systemName: "heart.fill")!.withTintColor(.label, renderingMode: .alwaysOriginal), rootViewController: HeartViewController())
        
        // User
        let userProfileNavController = templateNavController(unselectedImage: UIImage(systemName: "person")!.withTintColor(.label, renderingMode: .alwaysOriginal), selectedImage: UIImage(systemName: "person.fill")!.withTintColor(.label, renderingMode: .alwaysOriginal), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        self.tabBar.tintColor = .black
        self.viewControllers = [homeNavController, diaryController, plusNavController, likeNavController, userProfileNavController]
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let layout = MosiacLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let photoSelectorVC = UINavigationController(rootViewController: photoSelectorController)
            photoSelectorVC.modalPresentationStyle = .fullScreen
            present(photoSelectorVC, animated: true, completion: nil)
            return false
        }
        return true
    }
}
