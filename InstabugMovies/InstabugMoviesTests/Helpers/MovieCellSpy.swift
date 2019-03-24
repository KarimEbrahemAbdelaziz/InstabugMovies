//
//  MovieCellSpy.swift
//  InstabugMoviesTests
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

@testable import InstabugMovies
import Foundation

class MovieCellSpy: MovieCellView {
    
    var displayedTitle = ""
    var displayedOverview = ""
    var displayedReleaseDate = ""
    var displayedPoster = ""
    var displayedPosterImage = ""
    
    func display(title: String) {
        self.displayedTitle = title
    }
    
    func display(poster: String) {
        self.displayedPoster = poster
    }
    
    func display(posterImage: String) {
        self.displayedPosterImage = posterImage
    }
    
    func display(releaseDate: String) {
        self.displayedReleaseDate = releaseDate
    }
    
    func display(overview: String) {
        self.displayedOverview = overview
    }
    
}
