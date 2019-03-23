//
//  Movie.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/23/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

struct Movie {
    var id: String
    var title: String
    var overview: String
    var date: String
    var poster: String
}

extension Movie: Equatable { }

func == (lhs: Movie, rhs: Movie) -> Bool {
    return lhs.id == rhs.id
}
