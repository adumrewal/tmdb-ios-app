//
//  NowPlayingMOHandler.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 05/04/21.
//

import Foundation
import CoreData

class NowPlayingMOHandler {
    static func clearNowPlayingMO(moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NowPlayingMO")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
        } catch {
            print("Could not delete NowPlayingMO entity records. \(error)")
        }
    }
    
    static func saveCurrentMovieList(_ movieInfoList: [MovieInfoModel], moc: NSManagedObjectContext) {
        NowPlayingMOHandler.clearNowPlayingMO(moc: moc)
        if let entity = NSEntityDescription.entity(forEntityName: "NowPlayingMO", in: moc) {
            let nowPlayingMO = NSManagedObject(entity: entity, insertInto: moc)
            let movieListData = try? JSONEncoder().encode(movieInfoList)
            nowPlayingMO.setValue(movieListData, forKeyPath: "movieListData")
            nowPlayingMO.setValue(Date(), forKey: "timeStamp")
            
            do {
                try moc.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    static func fetchSavedNowPlayingMovieList(in moc: NSManagedObjectContext) -> [MovieInfoModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NowPlayingMO")
        do {
            let nowPlayingMO = try moc.fetch(fetchRequest)
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
