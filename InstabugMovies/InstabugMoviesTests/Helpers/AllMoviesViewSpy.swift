//
//  MoviesViewSpy.swift
//  InstabugMoviesTests
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

@testable import InstabugMovies
import Foundation

class AllMoviesViewSpy: AllMoviesView {
    
    var refreshAllMoviesViewCalled = false
    var displayAllMoviesRetrievalErrorTitle: String?
    var displayAllMoviesRetrievalErrorMessage: String?
    
    func refreshAllMoviesView() {
        refreshAllMoviesViewCalled = true
    }
    
    func displayAllMoviesRetrievalError(title: String, message: String) {
        displayAllMoviesRetrievalErrorTitle = title
        displayAllMoviesRetrievalErrorMessage = message
    }
    
    func scrollToMyMovies() { }
    
    func shouldHideMoviesTableView(hidden: Bool) { }
    
    func shouldHideEmptyStateView(hidden: Bool) { }
    
}

