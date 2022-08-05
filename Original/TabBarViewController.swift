//
//  TabBarViewController.swift
//  Original
//
//  Created by 神林沙希 on 2022/05/13.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor(red: 249 / 255, green: 114/255, blue: 114/255, alpha: 1.0)
    }

//    // MARK: - View Life Cycle
//        override func viewDidLoad() {
//            super.viewDidLoad()
//
//            tabBar.isTranslucent = false
//            tabBar.backgroundColor = .white
//            tabBar.tintColor = #colorLiteral(red: 0.05700000003, green: 0.09799999744, blue: 0.1070000008, alpha: 1)
//
//            delegate = self
//
//            // Instantiate view controllers
//            let homeNav = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! UINavigationController
//
//            let settingsNav = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! UINavigationController
//
//            let newPostVC = self.storyboard?.instantiateViewController(withIdentifier: "NewPostNav") as! UINavigationController
//
//
//            // Create TabBar items
//            homeNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
//
//            settingsNav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
//
//            newPostVC.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
//
//
//            // Assign viewControllers to tabBarController
//            let viewControllers = [homeNav, newPostVC, settingsNav]
//            self.setViewControllers(viewControllers, animated: false)
//
//
//            guard let tabBar = self.tabBar as? CustomTabBar else { return }
//
//            tabBar.didTapButton = { [unowned self] in
//                self.routeToCreateNewAd()
//            }
//        }
//
//        func routeToCreateNewAd() {
//            let createAdNavController = self.storyboard?.instantiateViewController(withIdentifier: "NewPostNav") as! UINavigationController
//            createAdNavController.modalPresentationCapturesStatusBarAppearance = true
//            self.present(createAdNavController, animated: true, completion: nil)
//        }
//    }
//
//    // MARK: - UITabBarController Delegate
//    extension TabBarViewController: UITabBarControllerDelegate {
//        func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//            guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
//                return true
//            }
//
//            // Your middle tab bar item index.
//            // In my case it's 1.
//            if selectedIndex == 1 {
//                return false
//            }
//
//            return true
//        }
}
