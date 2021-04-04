//
//  NetworkManager.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 02/04/21.
//

import Foundation

public class NetworkManager {
    
    private let session: URLSession
    private let apiKey = "38a73d59546aa378980a88b645f487fc"
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil

        session = URLSession.init(configuration: config)
    }
    
    func fetchNowPlaying(page: Int, completionHandler: @escaping (NowPlayingResponseModel?) -> Void) {
        if let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=\(page)") {
            let task = session.dataTask(with: url) { (data, response, error) in
                if let err = error {
                    print("An Error Occured \(err.localizedDescription)")
                    completionHandler(nil)
                    return
                }
                guard let mime = response?.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    completionHandler(nil)
                    return
                }
                if let jsonData = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedNowPlayingModel = try decoder.decode(NowPlayingResponseModel.self, from: jsonData)
                        completionHandler(decodedNowPlayingModel)
                    } catch {
                        print("JSON error: \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
    }
}
