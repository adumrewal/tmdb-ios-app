//
//  NowPlayingResponseModel.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 02/04/21.
//

import Foundation

class NowPlayingResponseModel: Decodable {
    let page: Int
    let results: [MovieInfoModel]
    let totalPages: Int
    let totalResults: Int
}
