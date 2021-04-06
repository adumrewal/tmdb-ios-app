//
//  SavedItemsViewController.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 05/04/21.
//

import Foundation
import CoreData

class SavedItemsViewController: MovieListViewController {
    override init(_ managedObjectContext: NSManagedObjectContext) {
        super.init(managedObjectContext)
        viewModel = SavedItemsViewModel(managedObjectContext)
        viewModel.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
