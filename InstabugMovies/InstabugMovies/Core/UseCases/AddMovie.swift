//
//  AddMovie.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/23/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

typealias AddMovieUseCaseCompletionHandler = (_ movie: Result<Movie>) -> Void

protocol AddMovieUseCase {
    func add(parameters: AddMovieParameters, completionHandler: @escaping AddMovieUseCaseCompletionHandler)
}

// This class is used across all layers - Core, UI and Network
// It's not violating any dependency rules.
// However it might make sense for each layer do define it's own input parameters so it can be used independently of the other layers.
struct AddMovieParameters {
    var id: Int
    var title: String
    var overview: String
    var date: String
    var poster: String
}

class AddMovieUseCaseImplementation: AddMovieUseCase {
    let moviesGateway: MoviesGateway
    
    init(moviesGateway: MoviesGateway) {
        self.moviesGateway = moviesGateway
    }
    
    // MARK: - AddMovieUseCase
    
    func add(parameters: AddMovieParameters, completionHandler: @escaping (Result<Movie>) -> Void) {
        self.moviesGateway.add(parameters: parameters) { (result) in
            completionHandler(result)
        }
    }
    
}
