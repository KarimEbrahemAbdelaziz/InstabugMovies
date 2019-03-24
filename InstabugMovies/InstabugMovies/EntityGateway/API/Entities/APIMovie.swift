//
//  APIMovie.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

struct APIMovies: InitializableWithData, InitializableWithJson {
    var movies = [APIMovie]()
    
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
        guard let movies = json["results"] as? [[String: Any]] else {
                throw NSError.createPraseError()
        }
        
        let parsedMovies: [APIMovie?] = movies.map({ (movie) -> APIMovie? in
            guard let _ = movie["id"] as? Int,
                let _ = movie["title"] as? String,
                let _ = movie["poster_path"] as? String,
                let _ = movie["overview"] as? String,
                let _ = movie["release_date"] as? String
                else {
                    return nil
            }
            return APIMovie(json: movie)
        })
        
        self.movies.append(contentsOf: parsedMovies.compactMap { $0 })
    }
}

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
        
        self.init(json: json)
        
    }
    
    init(json: [String : Any]) {
        self.id = json["id"] as! Int
        self.voteCount = json["vote_count"] as? Int
        self.vidoe = json["vidoe"] as? Bool
        self.voteAverage = json["vote_average"] as? Double
        self.popularity = json["popularity"] as? Double
        self.originalLanguage = json["original_language"] as? String
        self.originalTitle = json["original_title"] as? String
        self.genreIds = json["genre_ids"] as? [Int]
        self.backdropPath = json["backdrop_path"] as? String
        self.title = json["title"] as? String
        self.posterPath = json["poster_path"] as? String
        self.overview = json["overview"] as? String
        self.releaseDate = json["release_date"] as? String
        self.adult = json["adult"] as? Bool
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
