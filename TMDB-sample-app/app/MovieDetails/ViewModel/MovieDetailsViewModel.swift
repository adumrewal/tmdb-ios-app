//
//  MovieDetailsViewModel.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 04/04/21.
//

import Foundation

class MovieDetailsViewData {
    var movieInfoModel: MovieInfoModel
    
    init(_ movieInfoModel: MovieInfoModel) {
        self.movieInfoModel = movieInfoModel
    }
}

class MovieDetailsViewModel {
    weak var viewController: MovieDetailsViewController?
    private var dataModel: MovieDetailsViewData
    
    init(_ movieInfoModel: MovieInfoModel) {
        dataModel = MovieDetailsViewData(movieInfoModel)
    }
    
    func movieInfoModel() -> MovieInfoModel {
        return dataModel.movieInfoModel
    }
    
    func movieTitle() -> String {
        return dataModel.movieInfoModel.title
    }
}
