//
//  AllMoviesViewController.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import UIKit

class AllMoviesViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var moviesTableView: UITableView!
    @IBOutlet private weak var emptyStateView: UIView!
    @IBOutlet private weak var tryAgainButton: UIButton!
    
    // MARK: - Properties
    
    var configurator = AllMoviesConfiguratorImplementation()
    var presenter: AllMoviesPresenter!
    
    private let emptyHeaderSectionHeight = 0.0
    private let headerSectionHeight = 44.0
    private let movieCellIdentifier = "MovieCell"
    private let movieNibCellIdentifier = "MovieCell"
    private let loadingCellIdentifier = "LoadingCell"
    private let LoadingNibCellIdentifier = "LoadingCell"
    private let myMoviesSectionHeaderTitle = "My Movies"
    private let allMoviesSectionHeaderTitle = "All Movies"
    private var isFetchingMore = false
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(AllMoviesViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.white
        
        return refreshControl
    }()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Dependencies
        configurator.configure(allMoviesViewController: self)
        presenter.viewDidLoad()
        
        // Setup Views
        setupViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
    
    private func setupViews() {
        hideAllViews()
        registerMoviesTableViewCells()
        addMoviesTableViewFooter()
        self.moviesTableView.addSubview(self.refreshControl)
        tryAgainButton.layer.cornerRadius = tryAgainButton.frame.height / 2
    }
    
    private func hideAllViews() {
        moviesTableView.isHidden = true
        emptyStateView.isHidden = true
    }
    
    private func registerMoviesTableViewCells() {
        let movieCellNib = UINib(nibName: movieNibCellIdentifier, bundle: nil)
        moviesTableView.register(movieCellNib, forCellReuseIdentifier: movieCellIdentifier)
        let loadingCellNib = UINib(nibName: LoadingNibCellIdentifier, bundle: nil)
        moviesTableView.register(loadingCellNib, forCellReuseIdentifier: loadingCellIdentifier)
    }
    
    private func addMoviesTableViewFooter() {
        moviesTableView.tableFooterView = UIView()
    }
    
    // MARK: - IBActions
    
    @IBAction private func addLocalMovie(_ sender: UIBarButtonItem) {
        presenter.addButtonPressed()
    }
    
    
    @IBAction private func tryLoadMoviesAgain(_ sender: UIButton) {
        presenter.tryFetchMoviesAgain()
    }
    
    // MARK: - Private functions
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter.tryFetchMoviesAgain()
        refreshControl.endRefreshing()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isFetchingMore {
                fetchNextMoviesPage()
            }
        }
    }
    
    private func fetchNextMoviesPage() {
        isFetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presenter.fetchNextPageOfMovies()
        }
    }

}

// MARK: - AllMoviesView Protocol Functions

extension AllMoviesViewController: AllMoviesView {
    func shouldHideEmptyStateView(hidden: Bool) {
        emptyStateView.isHidden = hidden
    }
    
    func shouldHideMoviesTableView(hidden: Bool) {
        moviesTableView.isHidden = hidden
    }
    
    func refreshAllMoviesView() {
        isFetchingMore = false
        moviesTableView.isHidden = false
        moviesTableView.reloadData()
    }
    
    func scrollToMyMovies() {
        moviesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func displayAllMoviesRetrievalError(title: String, message: String) {
        isFetchingMore = false
        presentAlert(withTitle: title, message: message)
    }
}

// MARK: - MoviesTableView DataSource and Delegate

extension AllMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 1 {
            return CGFloat(emptyHeaderSectionHeight)
        } else {
            return CGFloat(headerSectionHeight)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return myMoviesSectionHeaderTitle
        } else if section == 1 {
            return allMoviesSectionHeaderTitle
        } else {
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return presenter.numberOfLocalMovies
        } else if section == 1 {
            return presenter.numberOfMovies
        } else {
            return presenter.numberOfLoadingCells
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let movieCell = tableView.dequeueReusableCell(withIdentifier: movieCellIdentifier, for: indexPath) as! MovieCell
            presenter.configureLocal(cell: movieCell, forRow: indexPath.row)
            return movieCell
        } else if indexPath.section == 1 {
            let movieCell = tableView.dequeueReusableCell(withIdentifier: movieCellIdentifier, for: indexPath) as! MovieCell
            presenter.configureAPI(cell: movieCell, forRow: indexPath.row)
            return movieCell
        } else {
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: loadingCellIdentifier, for: indexPath) as! LoadingCell
            loadingCell.loadingIndicator.startAnimating()
            return loadingCell
        }
    }
    
}
