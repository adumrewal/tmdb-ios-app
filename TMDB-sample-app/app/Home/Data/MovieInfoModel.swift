//
//  MovieInfoModel.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 02/04/21.
//

import Foundation

class MovieInfoModel: Codable {
    let posterPath: String
    let releaseDate: String
    let id: Int
    let title: String
}
