//
//  AddMovieUseCaseSpy.swift
//  InstabugMoviesTests
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

@testable import InstabugMovies
import Foundation

class AddMovieUseCaseSpy: AddMovieUseCase {
    
    var resultToBeReturned: Result<Movie>!
    var callCompletionHandlerImmediate = true
    var movieToAdd: Movie?
    
    private var completionHandler: AddMovieUseCaseCompletionHandler?
    
    func add(parameters: AddMovieParameters, completionHandler: @escaping AddMovieUseCaseCompletionHandler) {
        movieToAdd = Movie(id: parameters.id,
                           title: parameters.title,
                           overview: parameters.overview,
                           date: parameters.date,
                           poster: parameters.poster)
        self.completionHandler = completionHandler
        if callCompletionHandlerImmediate {
            callCompletionHandler()
        }
    }
    
    func callCompletionHandler() {
        self.completionHandler?(resultToBeReturned)
    }
}
