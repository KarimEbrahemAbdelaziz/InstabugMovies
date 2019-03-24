//
//  AllMoviesViewController.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import UIKit

class AllMoviesViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet private weak var emptyStateView: UIView!
    
    // MARK: - Properties
    
    var configurator = AllMoviesConfiguratorImplementation()
    var presenter: AllMoviesPresenter!
    
    private let movieCellIdentifier = "MovieCell"
    private let movieNibCellIdentifier = "MovieCell"
    private let loadingCellIdentifier = "LoadingCell"
    private let LoadingNibCellIdentifier = "LoadingCell"
    
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

}

// MARK: - AllMoviesView Protocol Functions

extension AllMoviesViewController: AllMoviesView {
    func refreshAllMoviesView() {
        moviesTableView.isHidden = false
        moviesTableView.reloadData()
    }
    
    func displayAllMoviesRetrievalError(title: String, message: String) {
        presentAlert(withTitle: title, message: message)
    }
}

// MARK: - MoviesTableView DataSource and Delegate

extension AllMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfMovies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: movieCellIdentifier, for: indexPath) as! MovieCell
        presenter.configure(cell: movieCell, forRow: indexPath.row)
        return movieCell
    }
    
}
