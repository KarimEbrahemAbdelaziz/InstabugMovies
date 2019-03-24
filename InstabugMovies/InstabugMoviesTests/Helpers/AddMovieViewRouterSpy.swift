//
//  AddMovieViewRouterSpy.swift
//  InstabugMoviesTests
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

@testable import InstabugMovies
import Foundation

class AddMovieViewRouterSpy: AddMovieRouter {
    var didCallDismiss = false
    
    func dismiss() {
        didCallDismiss = true
    }
}
