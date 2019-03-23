//
//  APIClient.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

protocol APIRequest {
    var urlRequest: URLRequest { get }
}

protocol APIClient {
    func execute<T>(request: APIRequest, completionHandler: @escaping (_ result: Result<APIResponse<T>>) -> Void)
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

class ApiClientImplementation: APIClient {
    
    let urlSession: URLSessionProtocol
    
    init(urlSessionConfiguration: URLSessionConfiguration, completionHandlerQueue: OperationQueue) {
        urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: completionHandlerQueue)
    }
    
    // This should be used mainly for testing purposes
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    // MARK: - ApiClient
    
    func execute<T>(request: APIRequest, completionHandler: @escaping (Result<APIResponse<T>>) -> Void) {
        let dataTask = urlSession.dataTask(with: request.urlRequest) { (data, response, error) in
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkRequestError(error: error)))
                }
                return
            }
            
            let successRange = 200...299
            if successRange.contains(httpUrlResponse.statusCode) {
                do {
                    let response = try APIResponse<T>(data: data, httpUrlResponse: httpUrlResponse)
                    DispatchQueue.main.async {
                        completionHandler(.success(response))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(.failure(APIError(data: data, httpUrlResponse: httpUrlResponse)))
                }
            }
        }
        dataTask.resume()
    }
    
}
