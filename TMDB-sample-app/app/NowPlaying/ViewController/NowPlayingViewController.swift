//
//  NowPlayingViewController.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 01/04/21.
//

import Foundation
import CoreData
import SwiftUI

class NowPlayingViewController: MovieListViewController {
    override init(_ managedObjectContext: NSManagedObjectContext) {
        super.init(managedObjectContext)
        viewModel = NowPlayingViewModel(managedObjectContext)
        viewModel.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
