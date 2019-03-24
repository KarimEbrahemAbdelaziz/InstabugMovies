//
//  DiplayMoviesUseCaseStub.swift
//  InstabugMoviesTests
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

@testable import InstabugMovies
import Foundation

class DiplayMoviesUseCaseStub: DisplayMoviesUseCase {
    
    var resultToBeReturned: Result<[Movie]>!
    
    func displayMovies(pageNumber: Int, completionHandler: @escaping DisplayMoviesUseCaseCompletionHandler) {
        completionHandler(resultToBeReturned)
    }
    
}
