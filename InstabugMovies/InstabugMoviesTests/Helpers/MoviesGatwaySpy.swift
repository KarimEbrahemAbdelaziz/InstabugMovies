//
//  MoviesGatwaySpy.swift
//  InstabugMoviesTests
//
//  Created by Karim Ebrahem on 3/23/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

@testable import InstabugMovies
import Foundation

class MoviesGatewaySpy: MoviesGateway {
    
    var fetchMoviesResultToBeReturned: Result<[Movie]>!
    var addMovieResultToBeReturned: Result<Movie>!
    
    var addedMovie: Movie!
    
    func fetchMovies(pageNumber: Int, completionHandler: @escaping FetchMoviesEntityGatewayCompletionHandler) {
        completionHandler(fetchMoviesResultToBeReturned)
    }
    
    func add(parameters: AddMovieParameters, completionHandler: @escaping AddMovieEntityGatewayCompletionHandler) {
        addedMovie = Movie(id: parameters.id,
                           title: parameters.title,
                           overview: parameters.overview,
                           date: parameters.date,
                           poster: parameters.poster)
        completionHandler(addMovieResultToBeReturned)
    }
    
}
