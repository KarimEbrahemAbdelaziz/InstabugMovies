//
//  DisplayMoviesList.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/23/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

typealias DisplayMoviesUseCaseCompletionHandler = (_ movies: Result<[Movie]>) -> Void

protocol DisplayMoviesUseCase {
    func displayMovies(completionHandler: @escaping DisplayMoviesUseCaseCompletionHandler)
}

class DisplayMoviesUseCaseImplementation: DisplayMoviesUseCase {
    let moviesGateway: MoviesGateway
    
    init(moviesGateway: MoviesGateway) {
        self.moviesGateway = moviesGateway
    }
    
    // MARK: - DisplayMoviesUseCase
    
    func displayMovies(completionHandler: @escaping (Result<[Movie]>) -> Void) {
        self.moviesGateway.fetchMovies { (result) in
            completionHandler(result)
        }
    }
}
