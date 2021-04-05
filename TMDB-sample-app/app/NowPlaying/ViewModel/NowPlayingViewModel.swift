//
//  NowPlayingViewModel.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 02/04/21.
//

import Foundation
import CoreData

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

public class NowPlayingViewModel {
    
    weak var viewController: NowPlayingViewController?
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
        saveCurrentMovieList()
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
        let movieModelList = fetchSavedMovieList()
        addMovieInfoModelToMovieList(movieModelList)
        updateView()
    }
    
    func updateView() {
        isLoading = false
        viewController?.updateView()
    }
    
    func didTap() {
//        fetchSavedMovieList()
    }
    
    func loadViewInitialData() {
        fetchNowPlayingData()
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

// MARK:- Core Data handling
extension NowPlayingViewModel {
    func clearNowPlayingMO() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NowPlayingMO")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch {
            print("Could not delete NowPlayingMO entity records. \(error)")
        }
    }
    
    func saveCurrentMovieList() {
        clearNowPlayingMO()
        let context = managedObjectContext
        if let entity = NSEntityDescription.entity(forEntityName: "NowPlayingMO", in: context) {
            let nowPlayingMO = NSManagedObject(entity: entity, insertInto: context)
            let movieListData = try? JSONEncoder().encode(dataModel.movieList)
            nowPlayingMO.setValue(movieListData, forKeyPath: "movieListData")
            nowPlayingMO.setValue(Date(), forKey: "timeStamp")
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func fetchSavedMovieList() -> [MovieInfoModel] {
        let context = managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NowPlayingMO")
        do {
            let nowPlayingMO = try context.fetch(fetchRequest)
            if nowPlayingMO.count > 0,
               let loadedMovieListData = nowPlayingMO[0].value(forKey: "movieListData") as? Data {
                if let loadedMovieList = try? JSONDecoder().decode([MovieInfoModel].self, from: loadedMovieListData) {
                    return loadedMovieList
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
}
