//
//  AddMoviePresenterStub.swift
//  InstabugMoviesTests
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

@testable import InstabugMovies
import Foundation

class AddMoviePresenterStub: AddMoviePresenter {

    var router: AddMovieRouter
    
    init (router: AddMovieRouter) {
        self.router = router
    }
    
    var manimumReleaseDate =  Date()
    
    func addButtonPressed(parameters: AddMovieParameters) {
        
    }
    
    func cancelButtonPressed() {
        
    }
}
