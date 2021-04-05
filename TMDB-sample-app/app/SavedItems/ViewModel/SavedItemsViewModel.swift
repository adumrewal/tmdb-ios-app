//
//  SavedItemsViewModel.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 05/04/21.
//

import Foundation
import CoreData

class SavedItemsDataModel {
    var movieList: [MovieInfoModel]
    
    init() {
        movieList = []
    }
}

public class SavedItemsViewModel {
    weak var viewController: SavedItemsViewController?
    private let dataModel: SavedItemsDataModel
    private let managedObjectContext: NSManagedObjectContext
    
    init(_ moc: NSManagedObjectContext) {
        dataModel = SavedItemsDataModel()
        managedObjectContext = moc
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchSavedItemsMovieList),
                                               name: Notification.Name("SavedItemsChanged"),
                                               object: nil)
    }
    
    @objc func fetchSavedItemsMovieList() {
        let movieInfoList = SavedItemsMOHandler.fetchSavedItemsMovieInfoList(moc: managedObjectContext)
        dataModel.movieList = []
        addMovieInfoModelToMovieList(movieInfoList)
        updateView()
    }

    func addMovieInfoModelToMovieList(_ modelList: [MovieInfoModel]) {
        for movieInfoModel in modelList.reversed() {
            dataModel.movieList.append(movieInfoModel)
        }
    }
    
    func updateView() {
        viewController?.updateView()
    }
    
    func didTap() {
//        fetchSavedMovieList()
    }
    
    func loadViewInitialData() {
        fetchSavedItemsMovieList()
    }
    
    func moviesCount() -> Int {
        return dataModel.movieList.count
    }
    
    func movieInfoModel(at index: Int) -> MovieInfoModel {
        return dataModel.movieList[index]
    }
    
    func currentMOC() -> NSManagedObjectContext {
        return managedObjectContext
    }
}

// MARK:- Pagination
extension SavedItemsViewModel {
    func checkAndHandleIfPaginationRequired(at row: Int) {
        // Does nothing
    }
    
    func handlePaginationRequired() {
        // Does nothing
    }
}
