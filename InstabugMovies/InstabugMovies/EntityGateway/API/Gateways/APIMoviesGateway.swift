//
//  APIMoviesGateway.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

class APIMoviesGatewayImplementation: MoviesGateway {
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    // MARK: - MoviesGateway
    
    func fetchMovies(pageNumber: Int, completionHandler: @escaping FetchMoviesEntityGatewayCompletionHandler) {
        let moviesAPIRequest = MoviesAPIRequest(pageNumber: pageNumber)
        apiClient.execute(request: moviesAPIRequest) { (result: Result<APIResponse<APIMovies>>) in
            switch result {
            case let .success(response):
                let movies = response.entity.movies.map { return $0.movie }
                completionHandler(.success(movies))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func add(parameters: AddMovieParameters, completionHandler: @escaping AddMovieEntityGatewayCompletionHandler) {
        // It's just fake implementation because there is no API to add movie
        let movie = Movie(id: parameters.id,
                          title: parameters.title,
                          overview: parameters.overview,
                          date: parameters.date,
                          poster: parameters.poster)
        completionHandler(.success(movie))
    }
    
}
