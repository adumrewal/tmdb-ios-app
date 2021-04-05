//
//  HomeTabBarController.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 05/04/21.
//

import Foundation
import CoreData
import SwiftUI

class HomeTabBarController: UITabBarController {
    init(_ viewContext: NSManagedObjectContext) {
        super.init(nibName: nil, bundle: nil)
        
        let nowPlayingVC = NowPlayingViewController(viewContext)
        let savedItemsVC = SavedItemsViewController(viewContext)

        let nowPlayingTabBarItem = UITabBarItem(title: "Now Playing", image: .checkmark, tag: 0)
        let savedItemsTabBarItem = UITabBarItem(title: "Saved", image: .actions, tag: 1)

        nowPlayingVC.tabBarItem = nowPlayingTabBarItem
        savedItemsVC.tabBarItem = savedItemsTabBarItem
        self.viewControllers = [nowPlayingVC, savedItemsVC]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
