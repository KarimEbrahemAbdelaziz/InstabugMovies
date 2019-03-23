//
//  APIMovie.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

struct APIMovie: InitializableWithData, InitializableWithJson {
    var voteCount: Int?
    var vidoe: Bool?
    var voteAverage: Double?
    var popularity: Double?
    var originalLanguage: String?
    var originalTitle: String?
    var genreIds: [Int]?
    var backdropPath: String?
    var adult: Bool?
    var id: Int
    var title: String?
    var posterPath: String?
    var overview: String?
    var releaseDate: String?
    
    init(data: Data?) throws {
        // Here you can parse the JSON or XML using the build in APIs or your favorite libraries
        guard let data = data,
            let jsonObject = try? JSONSerialization.jsonObject(with: data),
            let json = jsonObject as? [String: Any] else {
                throw NSError.createPraseError()
        }
        
        try self.init(json: json)
        
    }
    
    init(json: [String : Any]) throws {
        guard let id = json["id"] as? Int,
            let voteCount = json["vote_count"] as? Int,
            let vidoe = json["vidoe"] as? Bool,
            let voteAverage = json["vote_average"] as? Double,
            let popularity = json["popularity"] as? Double,
            let originalLanguage = json["original_language"] as? String,
            let originalTitle = json["original_title"] as? String,
            let genreIds = json["genre_ids"] as? [Int],
            let backdropPath = json["backdrop_path"] as? String,
            let title = json["title"] as? String,
            let posterPath = json["poster_path"] as? String,
            let overview = json["overview"] as? String,
            let releaseDate = json["release_date"] as? String,
            let adult = json["adult"] as? Bool
        else {
                throw NSError.createPraseError()
        }
        
        self.id = id
        self.voteCount = voteCount
        self.vidoe = vidoe
        self.voteAverage = voteAverage
        self.popularity = popularity
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.genreIds = genreIds
        self.backdropPath = backdropPath
        self.title = title
        self.posterPath = posterPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.adult = adult
    }
}

extension APIMovie {
    var movie: Movie {
        return Movie(id: id,
                     title: title ?? "",
                     overview: overview ?? "",
                     date: releaseDate ?? "",
                     poster: posterPath ?? "")
    }
}
