//
//  MoviesAPIRequest.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

struct MoviesAPIRequest: APIRequest {
    
    private let baseURL = "http://api.themoviedb.org/3/discover/movie"
    private var apiKey = "acea91d2bff1c53e6604e4985b6989e2"
    private var pageNumber: Int
    
    init(pageNumber: Int = 1) {
        self.pageNumber = pageNumber
    }
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.query = "api_key=\(apiKey)&page=\(pageNumber)"
        let url: URL = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
