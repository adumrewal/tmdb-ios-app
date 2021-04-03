//
//  NowPlayingTableViewCell.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 02/04/21.
//

import Foundation
import SwiftUI
import Nuke

class NowPlayingTableViewCell: UITableViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with movieModel: MovieInfoModel) {
        backgroundColor = .clear
        textLabel?.text = movieModel.title
        textLabel?.textColor = .white
        let request = ImageRequest(url: URL(string: "https://image.tmdb.org/t/p/w500\(movieModel.posterPath)")!, processors: [
            ImageProcessors.RoundedCorners(radius: 16)
        ])
        
        let options = ImageLoadingOptions(placeholder: UIImage(named: "cup"),
                                          transition: .fadeIn(duration: 0.33),
                                          failureImage: UIImage(named: "cup"),
                                          contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .center))
        
        Nuke.loadImage(with: request,options: options, into: imageView!)
    }
}
