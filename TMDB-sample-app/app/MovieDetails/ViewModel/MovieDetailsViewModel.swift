//
//  MovieDetailsViewModel.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 04/04/21.
//

import Foundation
import CoreData

class MovieDetailsViewData {
    var movieInfoModel: MovieInfoModel
    
    init(_ movieInfoModel: MovieInfoModel) {
        self.movieInfoModel = movieInfoModel
    }
}

class MovieDetailsViewModel {
    weak var viewController: MovieDetailsViewController?
    private var dataModel: MovieDetailsViewData
    private var managedObjectContext: NSManagedObjectContext
    
    init(_ movieInfoModel: MovieInfoModel, managedObjectContext: NSManagedObjectContext) {
        dataModel = MovieDetailsViewData(movieInfoModel)
        self.managedObjectContext = managedObjectContext
    }
    
    func movieInfoModel() -> MovieInfoModel {
        return dataModel.movieInfoModel
    }
    
    func movieTitle() -> String {
        return dataModel.movieInfoModel.title
    }
    
    func currentMOC() -> NSManagedObjectContext {
        return managedObjectContext
    }
}
