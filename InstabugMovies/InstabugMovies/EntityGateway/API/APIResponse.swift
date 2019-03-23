//
//  APIResponse.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

// All entities that model the API responses can implement this so we can handle all responses in a generic way
protocol InitializableWithData {
    init(data: Data?) throws
}

// Optionally, if you use JSON you can implement InitializableWithJson protocol
protocol InitializableWithJson {
    init(json: [String: Any]) throws
}

// Can be thrown when we can't even reach the API
struct NetworkRequestError: Error {
    let error: Error?
    
    var localizedDescription: String {
        return error?.localizedDescription ?? "Network request error - no other information"
    }
}

// Can be thrown when we reach the API but the it returns a 4xx or a 5xx
struct APIError: Error {
    let data: Data?
    let httpUrlResponse: HTTPURLResponse
}

// Can be thrown by InitializableWithData.init(data: Data?) implementations when parsing the data
struct APIParseError: Error {
    static let code = 999
    
    let error: Error
    let httpUrlResponse: HTTPURLResponse
    let data: Data?
    
    var localizedDescription: String {
        return error.localizedDescription
    }
}

// This wraps a successful API response and it includes the generic data as well
// The reason why we need this wrapper is that we want to pass to the client the status code and the raw response as well
struct APIResponse<T: InitializableWithData> {
    let entity: T
    let httpUrlResponse: HTTPURLResponse
    let data: Data?
    
    init(data: Data?, httpUrlResponse: HTTPURLResponse) throws {
        do {
            self.entity = try T(data: data)
            self.httpUrlResponse = httpUrlResponse
            self.data = data
        } catch {
            throw APIParseError(error: error, httpUrlResponse: httpUrlResponse, data: data)
        }
    }
}

// Some endpoints might return a 204 No Content
// We can't have Void implement InitializableWithData so we've created a "Void" response
struct VoidResponse: InitializableWithData {
    init(data: Data?) throws {
        
    }
}

extension Array: InitializableWithData {
    init(data: Data?) throws {
        guard let data = data,
            let jsonObject = try? JSONSerialization.jsonObject(with: data),
            let jsonArray = jsonObject as? [[String: Any]] else {
                throw NSError.createPraseError()
        }
        
        guard let element = Element.self as? InitializableWithJson.Type else {
            throw NSError.createPraseError()
        }
        
        self = try jsonArray.map( { return try element.init(json: $0) as! Element } )
    }
}

extension NSError {
    static func createPraseError() -> NSError {
        return NSError(domain: "com.karimebrahem.instabugmovies",
                       code: APIParseError.code,
                       userInfo: [NSLocalizedDescriptionKey: "A parsing error occured"])
    }
}
