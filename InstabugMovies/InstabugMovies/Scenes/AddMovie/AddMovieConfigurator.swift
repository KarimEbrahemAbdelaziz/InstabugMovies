//
//  AddMovieConfigurator.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

protocol AddMovieConfigurator {
    func configure(addMovieViewController: AddMovieViewController)
}

class AddMovieConfiguratorImplementation: AddMovieConfigurator {
    
    var addMoviePresenterDelegate: AddMoviePresenterDelegate?
    
    init(addMoviePresenterDelegate: AddMoviePresenterDelegate?) {
        self.addMoviePresenterDelegate = addMoviePresenterDelegate
    }
    
    func configure(addMovieViewController: AddMovieViewController) {
        
        let apiClient = ApiClientImplementation(urlSessionConfiguration: URLSessionConfiguration.default,
                                                completionHandlerQueue: OperationQueue.main)
        let moviesGateway = APIMoviesGatewayImplementation(apiClient: apiClient)
        
        let addMovieUseCase = AddMovieUseCaseImplementation(moviesGateway: moviesGateway)
        
        let router = AddMovieRouterImplementation(addMovieViewController: addMovieViewController)
        
        let presenter = AddMoviePresenterImplementation(
            view: addMovieViewController,
            addMovieUseCase: addMovieUseCase,
            router: router, delegate: addMoviePresenterDelegate
        )
        
        addMovieViewController.presenter = presenter
        
    }
}
