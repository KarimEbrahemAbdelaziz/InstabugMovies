//
//  AllMoviesPresenter.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation
import UIKit

protocol AllMoviesView: class {
    func refreshAllMoviesView()
    func scrollToMyMovies()
    func shouldHideMoviesTableView(hidden: Bool)
    func shouldHideEmptyStateView(hidden: Bool)
    func displayAllMoviesRetrievalError(title: String, message: String)
}

// It would be fine for the cell view to declare a MovieCellViewModel property and have it configure itself
// Using this approach makes the view even more passive/dumb - but I can understand if some might consider it an overkill
protocol MovieCellView {
    func display(title: String)
    func display(poster: String)
    func display(releaseDate: String)
    func display(overview: String)
}

protocol AllMoviesPresenter {
    var numberOfMovies: Int { get }
    var numberOfLocalMovies: Int { get }
    var numberOfLoadingCells: Int { get }
    var numberOfSections: Int { get }
    var router: AllMoviesViewRouter { get }
    func viewDidLoad()
    func tryFetchMoviesAgain()
    func configureAPI(cell: MovieCellView, forRow row: Int)
    func configureLocal(cell: MovieCellView, forRow row: Int)
    func addButtonPressed()
    func fetchNextPageOfMovies()
}

class AllMoviesPresenterImplementation: AllMoviesPresenter, AddMoviePresenterDelegate {
    fileprivate weak var view: AllMoviesView?
    fileprivate let displayMoviesUseCase: DisplayMoviesUseCase
    fileprivate let addMovieUseCase: AddMovieUseCase
    internal let router: AllMoviesViewRouter
    
    // Normally this would be file private as well, we keep it internal so we can inject values for testing purposes
    var movies = [Movie]()
    var localMovies = [Movie]()
    
    private var pageNumber = 1
    
    var numberOfMovies: Int {
        return movies.count
    }
    
    var numberOfLocalMovies: Int {
        return localMovies.count
    }
    
    var numberOfLoadingCells: Int {
        return 1
    }
    
    var numberOfSections: Int {
        return 3
    }
    
    init(view: AllMoviesView,
         displayMoviesUseCase: DisplayMoviesUseCase,
         addMovieUseCase: AddMovieUseCase,
         router: AllMoviesViewRouter) {
        self.view = view
        self.displayMoviesUseCase = displayMoviesUseCase
        self.addMovieUseCase = addMovieUseCase
        self.router = router
    }
    
    // MARK: - AllMoviesPresenter
    
    func viewDidLoad() {
        self.pageNumber = 1
        self.movies.removeAll()
        fetchMovies(at: pageNumber)
    }
    
    func tryFetchMoviesAgain() {
        self.pageNumber = 1
        self.movies.removeAll()
        fetchMovies(at: pageNumber)
    }
    
    func fetchNextPageOfMovies() {
        fetchMovies(at: pageNumber)
    }
    
    func configureAPI(cell: MovieCellView, forRow row: Int) {
        let movie = movies[row]
        
        cell.display(title: movie.title)
        cell.display(poster: movie.poster)
        cell.display(overview: movie.overview)
        cell.display(releaseDate: movie.date)
    }
    
    func configureLocal(cell: MovieCellView, forRow row: Int) {
        let movie = localMovies[row]
        
        cell.display(title: movie.title)
        cell.display(poster: movie.poster)
        cell.display(overview: movie.overview)
        cell.display(releaseDate: movie.date)
    }
    
    func addButtonPressed() {
        router.presentAddMovie(addMoviePresenterDelegate: self)
    }
    
    // MARK: - AddMoviePresenterDelegate
    
    func addMoviePresenter(_ presenter: AddMoviePresenter, didAdd movie: Movie) {
        presenter.router.dismiss()
        localMovies.append(movie)
        view?.refreshAllMoviesView()
        view?.scrollToMyMovies()
    }
    
    func addMoviePresenterCancel(presenter: AddMoviePresenter) {
        presenter.router.dismiss()
    }
    
    // MARK: - Private
    
    fileprivate func fetchMovies(at page: Int) {
        self.displayMoviesUseCase.displayMovies(pageNumber: page) { (result) in
            switch result {
            case let .success(movies):
                self.handleMoviesReceived(movies)
            case let .failure(error):
                self.handleMoviesError(error)
            }
        }
    }
    
    fileprivate func handleMoviesReceived(_ movies: [Movie]) {
        if !movies.isEmpty {
            view?.shouldHideEmptyStateView(hidden: true)
            view?.shouldHideMoviesTableView(hidden: false)
            self.movies.append(contentsOf: movies)
            self.pageNumber += 1
            view?.refreshAllMoviesView()
        } else {
            view?.shouldHideEmptyStateView(hidden: false)
            view?.shouldHideMoviesTableView(hidden: true)
        }
    }
    
    fileprivate func handleMoviesError(_ error: Error) {
        view?.shouldHideEmptyStateView(hidden: false)
        view?.shouldHideMoviesTableView(hidden: true)
        view?.displayAllMoviesRetrievalError(title: "Error", message: error.localizedDescription)
    }
    
}
