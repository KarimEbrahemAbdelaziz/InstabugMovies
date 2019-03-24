//
//  AllMoviesPresenter.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

protocol AllMoviesView: class {
    func refreshAllMoviesView()
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
    var router: AllMoviesViewRouter { get }
    func viewDidLoad()
    func configure(cell: MovieCellView, forRow row: Int)
    func addButtonPressed()
}

class AllMoviesPresenterImplementation: AllMoviesPresenter {
    fileprivate weak var view: AllMoviesView?
    fileprivate let displayMoviesUseCase: DisplayMoviesUseCase
    fileprivate let addMovieUseCase: AddMovieUseCase
    internal let router: AllMoviesViewRouter
    
    // Normally this would be file private as well, we keep it internal so we can inject values for testing purposes
    var movies = [Movie]()
    
    var numberOfMovies: Int {
        return movies.count
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
        self.displayMoviesUseCase.displayMovies(pageNumber: 1) { (result) in
            switch result {
            case let .success(movies):
                self.handleMoviesReceived(movies)
            case let .failure(error):
                self.handleMoviesError(error)
            }
        }
    }
    
    func configure(cell: MovieCellView, forRow row: Int) {
        let movie = movies[row]
        
        cell.display(title: movie.title)
        cell.display(poster: movie.poster)
        cell.display(overview: movie.overview)
        cell.display(releaseDate: movie.date)
    }
    
    func addButtonPressed() {
        
    }
    
    // MARK: - Private
    
    fileprivate func handleMoviesReceived(_ movies: [Movie]) {
        self.movies = movies
        view?.refreshAllMoviesView()
    }
    
    fileprivate func handleMoviesError(_ error: Error) {
        // Here we could check the error code and display a localized error message
        view?.displayAllMoviesRetrievalError(title: "Error", message: error.localizedDescription)
    }
    
}
