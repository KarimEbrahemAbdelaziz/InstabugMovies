//
//  URLSessionStub.swift
//  InstabugMoviesTests
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

@testable import InstabugMovies
import Foundation

class URLSessionStub: URLSessionProtocol {
    
    typealias URLSessionCompletionHandlerResponse = (data: Data?, response: URLResponse?, error: Error?)
    var responses = [URLSessionCompletionHandlerResponse]()
    
    func enqueue(response: URLSessionCompletionHandlerResponse) {
        responses.append(response)
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return StubTask(response: responses.removeFirst(), completionHandler: completionHandler)
    }
    
    private class StubTask: URLSessionDataTask {
        let testDoubleResponse: URLSessionCompletionHandlerResponse
        let completionHandler: (Data?, URLResponse?, Error?) -> Void
        
        init(response: URLSessionCompletionHandlerResponse, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
            self.testDoubleResponse = response
            self.completionHandler = completionHandler
        }
        
        override func resume() {
            completionHandler(testDoubleResponse.data, testDoubleResponse.response, testDoubleResponse.error)
        }
    }
    
}

extension URL {
    
    static var googleUrl: URL {
        return URL(string: "https://www.google.com")!
    }
    
}

extension HTTPURLResponse {
    
    convenience init(statusCode: Int) {
        self.init(url: URL.googleUrl, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
}
