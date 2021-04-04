//
//  MovieDetailsViewController.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 04/04/21.
//

import Foundation
import SwiftUI

class MovieDetailsViewController: UIViewController {
    private var viewModel: MovieDetailsViewModel
    
    init(_ movieInfoModel: MovieInfoModel) {
        viewModel = MovieDetailsViewModel(movieInfoModel)
        super.init(nibName: nil, bundle: nil)
        
        viewModel.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBackgroundView()
        movieTopView.isHidden = false
        movieOverview.isHidden = false
    }
    
    private func setupNavigationBar() {
        title = viewModel.movieTitle()
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .white
    }
    
    private lazy var movieTopView: MovieDetailTopView = {
        let topView = MovieDetailTopView(frame: .zero, movieModel: viewModel.movieInfoModel())
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(topView)
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        topView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        return topView
    }()
    
    private lazy var movieOverview: MovieDetailOverview = {
        let overview = MovieDetailOverview(frame: .zero, movieModel: viewModel.movieInfoModel())
        overview.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(overview)
        overview.topAnchor.constraint(equalTo: movieTopView.bottomAnchor, constant: 20).isActive = true
        overview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        overview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        overview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        return overview
    }()
}
