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
    
    func fetchMovies(completionHandler: @escaping FetchMoviesEntityGatewayCompletionHandler) {
        completionHandler(fetchMoviesResultToBeReturned)
    }
    
    func add(parameters: AddMovieParameters, completionHandler: @escaping AddMovieEntityGatewayCompletionHandler) {
        
    }
    
}
