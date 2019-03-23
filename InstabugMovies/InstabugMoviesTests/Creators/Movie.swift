//
//  Movie.swift
//  InstabugMoviesTests
//
//  Created by Karim Ebrahem on 3/23/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

@testable import InstabugMovies
import Foundation

extension Movie {
    static func createMoviesArray(numberOfElements: Int = 2) -> [Movie] {
        var movies = [Movie]()
        
        for i in 0..<numberOfElements {
            let movie = createMovie(index: i)
            movies.append(movie)
        }
        
        return movies
    }
    
    static func createMovie(index: Int = 0) -> Movie {
        return Movie(id: index, title: "Movie \(index)", overview: "Overview for movie \(index)", date: "23-3-2019", poster: "http://posterformovie\(index).png")
    }
}
