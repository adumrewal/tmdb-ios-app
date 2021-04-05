//
//  MovieDetailsViewController.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 04/04/21.
//

import Foundation
import CoreData
import SwiftUI

class MovieDetailsViewController: UIViewController {
    private var viewModel: MovieDetailsViewModel
    
    init(_ movieInfoModel: MovieInfoModel, managedObjectContext: NSManagedObjectContext) {
        viewModel = MovieDetailsViewModel(movieInfoModel, managedObjectContext: managedObjectContext)
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillAppear(animated)
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
        overview.bottomAnchor.constraint(equalTo: favoriteButton.topAnchor, constant: -20).isActive = true
        overview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        overview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        return overview
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(isFavoriteButtonTapped(_:)), for: .touchUpInside)
        
        let movieInfoModel = viewModel.movieInfoModel()
        let moc = viewModel.currentMOC()
        let checkFavorite = SavedItemsMOHandler.checkMovieInfoExistsInSavedItems(movieInfoModel, moc: moc)
        setButtonIconForState(button, checkFavorite: checkFavorite)
        
        view.addSubview(button)
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        return button
    }()
    
    func setButtonIconForState(_ button: UIButton, checkFavorite: Bool) {
        if checkFavorite == true {
            button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            button.setTitle("   Saved", for: .normal)
        } else if checkFavorite == false {
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.setTitle("   Add to Saved", for: .normal)
        }
    }
    
    @objc func isFavoriteButtonTapped(_ sender: UIButton) {
        let movieInfoModel = viewModel.movieInfoModel()
        let moc = viewModel.currentMOC()
        let checkFavorite = SavedItemsMOHandler.checkMovieInfoExistsInSavedItems(movieInfoModel, moc: moc)
        
        setButtonIconForState(sender, checkFavorite: !checkFavorite)
        if checkFavorite == true {
            SavedItemsMOHandler.removeMovieInfoObjectFromSavedItems(movieInfoModel, moc: moc)
        } else if checkFavorite == false {
            SavedItemsMOHandler.addMovieInfoObjectToSavedItems(movieInfoModel, moc: moc)
        }
    }
}
