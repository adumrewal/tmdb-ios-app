//
//  HomeViewModel.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 02/04/21.
//

import Foundation

class HomeViewDataModel {
    var movieList: [MovieInfoModel]
    var currentPageNumber: Int
    
    init() {
        movieList = []
        currentPageNumber = 0
    }
}

public class HomeViewModel {
    
    weak var viewController: HomeViewController?
    private let dataModel: HomeViewDataModel
    private lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()
    
    init() {
        dataModel = HomeViewDataModel()
    }
    
    func loadNowPlayingData() {
        networkManager.fetchNowPlaying(page: 1) { (nowPlayingResponseModel) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.handleNowPlayingResult(nowPlayingModel: nowPlayingResponseModel)
            }
        }
    }
    
    func handleNowPlayingResult(nowPlayingModel: NowPlayingResponseModel) {
        handlePageDetails(nowPlayingModel: nowPlayingModel)
        
        for movieInfoModel in nowPlayingModel.results {
            print(movieInfoModel.title)
            dataModel.movieList.append(movieInfoModel)
        }
        
        updateView()
    }
    
    func handlePageDetails(nowPlayingModel: NowPlayingResponseModel) {
        updateLastFetchedPageNumber(nowPlayingModel.page)
    }
    
    func updateLastFetchedPageNumber(_ page: Int) {
        dataModel.currentPageNumber = page
        print(page)
    }
    
    func updateView() {
        viewController?.updateView()
    }
    
    func nowPlayingMoviesCount() -> Int {
        return dataModel.movieList.count
    }
    
    func nowPlayingMovieInfoModel(at index: Int) -> MovieInfoModel {
        return dataModel.movieList[index]
    }
}
