//
//  NowPlayingTableViewCell.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 02/04/21.
//

import Foundation
import SwiftUI

class NowPlayingTableViewCell: UITableViewCell {
    private var movieInfoView: MovieInfoView?
    
    override func prepareForReuse() {
        movieInfoView?.removeFromSuperview()
        movieInfoView = nil
        super.prepareForReuse()
    }
    
    func configure(with movieModel: MovieInfoModel) {
        backgroundColor = .clear
        selectionStyle = .none
        setupMovieInfoView(with: movieModel)
    }
    
    func setupMovieInfoView(with movieModel: MovieInfoModel) {
        let view = MovieInfoView(frame: .zero, movieModel: movieModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(view)
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        movieInfoView = view
    }

}
