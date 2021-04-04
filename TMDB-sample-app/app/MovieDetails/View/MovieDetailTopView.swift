//
//  MovieDetailTopView.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 04/04/21.
//

import Foundation
import SwiftUI
import Nuke

class MovieDetailTopView: UIView {
    private var movieModel: MovieInfoModel
    
    init(frame: CGRect, movieModel: MovieInfoModel) {
        self.movieModel = movieModel
        super.init(frame: frame)
        self.movieImage.isHidden = false
        self.movieColumnDetails.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -10).isActive = true
        
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        
        let moviePosterPath = movieModel.posterPath
        let request = ImageRequest(url: URL(string: "https://image.tmdb.org/t/p/w500\(moviePosterPath)")!, processors: [
            ImageProcessors.RoundedCorners(radius: 16)
        ])
        
        let options = ImageLoadingOptions(placeholder: UIImage(named: "cup"),
                                          transition: .fadeIn(duration: 0.33),
                                          failureImage: UIImage(named: "cup"),
                                          contentModes: .init(success: .scaleAspectFit, failure: .center, placeholder: .center))
        
        Nuke.loadImage(with: request,options: options, into: imageView)
        return imageView
    }()
    
    private lazy var movieColumnDetails: MovieDetailColumnView = {
        let columnView = MovieDetailColumnView(frame: .zero, movieModel: movieModel)
        columnView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(columnView)
        columnView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        columnView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        columnView.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 10).isActive = true
        columnView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        return columnView
    }()
}
