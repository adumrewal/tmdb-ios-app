//
//  NowPlayingViewModel.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 02/04/21.
//

import Foundation
import CoreData

// MARK:- DataModel
class NowPlayingViewDataModel {
    var movieList: [MovieInfoModel]
    var currentPageNumber: Int
    var totalPages: Int
    
    init() {
        movieList = []
        currentPageNumber = 0
        totalPages = 100 // default upper limit
    }
}

// MARK:- ViewModel
public class NowPlayingViewModel: MovieListViewModelProtocol {
    weak var viewController: MovieListViewControllerProtocol?
    private var isLoading: Bool
    private let dataModel: NowPlayingViewDataModel
    private let managedObjectContext: NSManagedObjectContext
    private lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()
    
    init(_ moc: NSManagedObjectContext) {
        dataModel = NowPlayingViewDataModel()
        managedObjectContext = moc
        isLoading = true
    }

    func fetchNowPlayingData() {
        networkManager.fetchNowPlaying(page: 1) { (nowPlayingResponseModel) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let nowPlayingModel = nowPlayingResponseModel else {
                    self.updateViewWithCachedMovieList()
                    return
                }
                self.handleNowPlayingResult(nowPlayingModel: nowPlayingModel)
            }
        }
    }

    func fetchNextPageNowPlayingData() {
        networkManager.fetchNowPlaying(page: dataModel.currentPageNumber+1) { (nowPlayingResponseModel) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let nowPlayingModel = nowPlayingResponseModel else {
                    self.isLoading = false
                    return
                }
                self.handleNowPlayingResult(nowPlayingModel: nowPlayingModel)
            }
        }
    }

    func handleNowPlayingResult(nowPlayingModel: NowPlayingResponseModel) {
        handlePageDetails(nowPlayingModel: nowPlayingModel)
        addMovieInfoModelToMovieList(nowPlayingModel.results)
        
        updateView()
        NowPlayingMOHandler.saveCurrentMovieList(dataModel.movieList, moc: managedObjectContext)
    }
    
    func handlePageDetails(nowPlayingModel: NowPlayingResponseModel) {
        updateLastFetchedPageNumber(nowPlayingModel)
    }
    
    func addMovieInfoModelToMovieList(_ modelList: [MovieInfoModel]) {
        for movieInfoModel in modelList {
            dataModel.movieList.append(movieInfoModel)
        }
    }
    
    func updateLastFetchedPageNumber(_ nowPlayingModel: NowPlayingResponseModel) {
        dataModel.currentPageNumber = nowPlayingModel.page
        dataModel.totalPages = nowPlayingModel.totalPages
        print("\(dataModel.currentPageNumber) out of \(dataModel.totalPages)")
    }
    
    func updateViewWithCachedMovieList() {
        let movieModelList = NowPlayingMOHandler.fetchSavedNowPlayingMovieList(in: managedObjectContext)
        addMovieInfoModelToMovieList(movieModelList)
        updateView()
    }
    
    func updateView() {
        isLoading = false
        viewController?.updateView()
    }
    
    // MARK: MovieListViewModelProtocol
    func didTap() {
        // Does nothing
    }
    
    func loadViewInitialData() {
        fetchNowPlayingData()
    }
    
    func moviesCount() -> Int {
        return dataModel.movieList.count
    }
    
    func movieInfoModel(at index: Int) -> MovieInfoModel? {
        return dataModel.movieList[index]
    }
    
    func currentMOC() -> NSManagedObjectContext {
        return managedObjectContext
    }
}

// MARK:- Pagination
extension NowPlayingViewModel {
    func checkAndHandleIfPaginationRequired(at row: Int) {
        if (row + 1 == dataModel.movieList.count) && (dataModel.currentPageNumber != dataModel.totalPages) {
            handlePaginationRequired()
        }
    }
    
    func handlePaginationRequired() {
        if !isLoading && dataModel.currentPageNumber != 0 {
            isLoading = true
            fetchNextPageNowPlayingData()
        }
    }
}
