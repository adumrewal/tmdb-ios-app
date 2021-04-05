//
//  SavedItemsMOHandler.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 05/04/21.
//

import Foundation
import CoreData

class SavedItemsMOHandler {
    static func clearSavedItemsMO(moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedItemsMO")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
            NotificationCenter.default.post(name: Notification.Name("SavedItemsChanged"), object: nil)
        } catch {
            print("Could not delete SavedItemsMO entity records. \(error)")
        }
    }
    
    static func removeMovieInfoObjectFromSavedItems(_ movieInfo: MovieInfoModel, moc: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedItemsMO")
        fetchRequest.predicate = NSPredicate(format: "movieId == \(movieInfo.id)")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc.execute(batchDeleteRequest)
            NotificationCenter.default.post(name: Notification.Name("SavedItemsChanged"), object: nil)
        } catch {
            print("Could not delete SavedItemsMO entity record for id: \(movieInfo.id) \(error)")
        }
    }
    
    static func addMovieInfoObjectToSavedItems(_ movieInfo: MovieInfoModel, moc: NSManagedObjectContext) {
        if checkMovieInfoExistsInSavedItems(movieInfo, moc: moc) { return }
        if let entity = NSEntityDescription.entity(forEntityName: "SavedItemsMO", in: moc) {
            let savedItemsMO = NSManagedObject(entity: entity, insertInto: moc)
            let movieInfoData = try? JSONEncoder().encode(movieInfo)
            savedItemsMO.setValue(movieInfoData, forKeyPath: "movieInfoData")
            savedItemsMO.setValue(Date(), forKey: "timeStamp")
            savedItemsMO.setValue(movieInfo.id, forKey: "movieId")
            
            do {
                try moc.save()
                NotificationCenter.default.post(name: Notification.Name("SavedItemsChanged"), object: nil)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    static func checkMovieInfoExistsInSavedItems(_ movieInfo: MovieInfoModel, moc: NSManagedObjectContext) -> Bool {
        let savedItems = fetchSavedItemsMovieInfoList(moc: moc)
        for item in savedItems {
            if item.id == movieInfo.id {
                return true
            }
        }
        return false
    }
    
    static func fetchSavedItemsMovieInfoList(moc: NSManagedObjectContext) -> [MovieInfoModel] {
        var fetchedMovieInfoList: [MovieInfoModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedItemsMO")
        do {
            let saveItemsMOResult = try moc.fetch(fetchRequest)
            for loadedSavedItemObject in saveItemsMOResult {
                if let loadedMovieInfoData = loadedSavedItemObject.value(forKey: "movieInfoData") as? Data,
                   let loadedMovieInfoModel = try? JSONDecoder().decode(MovieInfoModel.self, from: loadedMovieInfoData) {
                    fetchedMovieInfoList.append(loadedMovieInfoModel)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchedMovieInfoList
    }
}
