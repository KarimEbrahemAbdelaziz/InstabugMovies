//
//  MoviesGateway.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/23/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

typealias FetchMoviesEntityGatewayCompletionHandler = (_ movies: Result<[Movie]>) -> Void
typealias AddMovieEntityGatewayCompletionHandler = (_ movie: Result<Movie>) -> Void

protocol MoviesGateway {
    func fetchMovies(pageNumber: Int, completionHandler: @escaping FetchMoviesEntityGatewayCompletionHandler)
    func add(parameters: AddMovieParameters, completionHandler: @escaping AddMovieEntityGatewayCompletionHandler)
}
