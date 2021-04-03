//
//  HomeViewModel.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 02/04/21.
//

import Foundation
import CoreData

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
    private let managedObjectContext: NSManagedObjectContext
    private lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()
    
    init(_ moc: NSManagedObjectContext) {
        dataModel = HomeViewDataModel()
        managedObjectContext = moc
    }
    
    func loadNowPlayingData() {
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
    
    func handleNowPlayingResult(nowPlayingModel: NowPlayingResponseModel) {
        handlePageDetails(nowPlayingModel: nowPlayingModel)
        addMovieInfoModelToMovieList(nowPlayingModel.results)
        
        updateView()
        saveCurrentMovieList()
    }
    
    func handlePageDetails(nowPlayingModel: NowPlayingResponseModel) {
        updateLastFetchedPageNumber(nowPlayingModel.page)
    }
    
    func addMovieInfoModelToMovieList(_ modelList: [MovieInfoModel]) {
        for movieInfoModel in modelList {
            dataModel.movieList.append(movieInfoModel)
        }
    }
    
    func updateLastFetchedPageNumber(_ page: Int) {
        dataModel.currentPageNumber = page
        print(page)
    }
    
    func updateViewWithCachedMovieList() {
        let movieModelList = fetchSavedMovieList()
        addMovieInfoModelToMovieList(movieModelList)
        updateView()
    }
    
    func didTap() {
//        fetchSavedMovieList()
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

extension HomeViewModel {
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
