//
//  HomeVC.swift
//  TMDB-sample-app
//
//  Created by Amol Dumrewal on 01/04/21.
//

import Foundation
import CoreData
import SwiftUI

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    private let cellReuseIdentifier = "NowPlayingTableViewCell"
    
    public init(_ managedObjectContext: NSManagedObjectContext) {
        viewModel = HomeViewModel(managedObjectContext)
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
        tableView.isHidden = false
        loadingView.startAnimating()
        viewModel.loadNowPlayingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillAppear(animated)
    }
    
    private func setupNavigationBar() {
        title = "Now playing"
        
        let addButton = UIBarButtonItem.init(systemItem: .add)
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .white
    }
    
    private lazy var homeTabView: UIView = {
        let homeTabView = UIView.init(frame: view.frame)
        homeTabView.translatesAutoresizingMaskIntoConstraints = false
        homeTabView.backgroundColor = .clear
        
        view.addSubview(homeTabView)
        homeTabView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        homeTabView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeTabView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        homeTabView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true

        return homeTabView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(NowPlayingTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.homeTabView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.homeTabView.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.homeTabView.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.homeTabView.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.homeTabView.trailingAnchor).isActive = true
        
        return tableView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingSpinner = UIActivityIndicatorView(style: .medium)
        loadingSpinner.color = .white
        loadingSpinner.hidesWhenStopped = true
        loadingSpinner.autoresizingMask = [.flexibleHeight,
                                           .flexibleWidth,
                                           .flexibleTopMargin,
                                           .flexibleBottomMargin,
                                           .flexibleLeftMargin,
                                           .flexibleRightMargin]
        
        view.addSubview(loadingSpinner)
        loadingSpinner.center = view.center
        return loadingSpinner
    }()
    
    func updateView() {
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nowPlayingMoviesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? NowPlayingTableViewCell else {
            return UITableViewCell()
        }
        
        viewModel.checkAndHandleIfPaginationRequired(at: indexPath.row)
        
        let movieModel = viewModel.nowPlayingMovieInfoModel(at: indexPath.row)
        cell.configure(with: movieModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Does nothing
        let movieModel = viewModel.nowPlayingMovieInfoModel(at: indexPath.row)
        let movieDetailsVC = MovieDetailsViewController(movieModel)
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
