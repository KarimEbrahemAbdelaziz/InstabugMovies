//
//  AllMoviesConfigurator.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

protocol AllMoviesConfigurator {
    func configure(allMoviesViewController: AllMoviesViewController)
}

class AllMoviesConfiguratorImplementation: AllMoviesConfigurator {
    
    func configure(allMoviesViewController: AllMoviesViewController) {
        
        let apiClient = ApiClientImplementation(urlSessionConfiguration: URLSessionConfiguration.default,
                                                completionHandlerQueue: OperationQueue.main)
        let moviesGateway = APIMoviesGatewayImplementation(apiClient: apiClient)
        
        let displayMoviesUseCase = DisplayMoviesUseCaseImplementation(moviesGateway: moviesGateway)
        let addMovieUseCase = AddMovieUseCaseImplementation(moviesGateway: moviesGateway)
        
        let router = AllMoviesViewRouterImplementation(allMoviesViewController: allMoviesViewController)
        let presenter = AllMoviesPresenterImplementation(
            view: allMoviesViewController,
            displayMoviesUseCase: displayMoviesUseCase,
            addMovieUseCase: addMovieUseCase,
            router: router
        )
        
        allMoviesViewController.presenter = presenter
        
    }
}
