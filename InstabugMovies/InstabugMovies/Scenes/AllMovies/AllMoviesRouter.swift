//
//  AllMoviesRouter.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import UIKit

protocol AllMoviesViewRouter: ViewRouter {
    func presentAddMovie(addMoviePresenterDelegate: AddMoviePresenterDelegate)
}

class AllMoviesViewRouterImplementation: AllMoviesViewRouter {
    
    fileprivate weak var allMoviesViewController: AllMoviesViewController?
    fileprivate weak var addMoviePresenterDelegate: AddMoviePresenterDelegate?
    
    init(allMoviesViewController: AllMoviesViewController) {
        self.allMoviesViewController = allMoviesViewController
    }
    
    // MARK: - AllMoviesViewRouter
    
    func presentAddMovie(addMoviePresenterDelegate: AddMoviePresenterDelegate) {
        self.addMoviePresenterDelegate = addMoviePresenterDelegate
        allMoviesViewController?.performSegue(withIdentifier: "MoviesSceneToAddMovieSceneSegue", sender: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let addMovieViewController = navigationController.topViewController as? AddMovieViewController {
            addMovieViewController.configurator = AddMovieConfiguratorImplementation(addMoviePresenterDelegate: addMoviePresenterDelegate)
        }
    }
    
}

