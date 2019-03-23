//
//  AddMovieUseCaseTest.swift
//  InstabugMoviesTests
//
//  Created by Karim Ebrahem on 3/23/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

@testable import InstabugMovies
import XCTest

class AddMovieUseCaseTest: XCTestCase {

    let moviesGatewaySpy = MoviesGatewaySpy()
    var addMovieUseCase: AddMovieUseCaseImplementation!
    
    override func setUp() {
        super.setUp()
        
        addMovieUseCase = AddMovieUseCaseImplementation(moviesGateway: moviesGatewaySpy)
    }
    
    override func tearDown() {
        super.tearDown()
        
        addMovieUseCase = nil
    }
    
    func testAddMovieSuccessCallsCompletionHandler() {
        // Given
        let movieToAddParameters = AddMovieParameters(id: 0,
                                                      title: "Movie 0",
                                                      overview: "Overview for movie 0",
                                                      date: "23-3-2019",
                                                      poster: "http://posterformovie0.png")
        let movieToAdd = Movie.createMovie()
        let expectedResultToBeReturned: Result<Movie> = Result.success(movieToAdd)
        moviesGatewaySpy.addMovieResultToBeReturned = expectedResultToBeReturned
        
        let addMovieCompletionHandlerExpectation = expectation(description: "Add Movie Expectation")
        
        // When
        addMovieUseCase.add(parameters: movieToAddParameters) { (result) in

            // Then
            XCTAssertEqual(expectedResultToBeReturned, result, "Completion handler didn't return the expected result")
            XCTAssertEqual(movieToAdd, self.moviesGatewaySpy.addedMovie, "Incorrect movie passed to the gateway")
            addMovieCompletionHandlerExpectation.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testAddMovieFailureCallsCompletionHandler() {
        // Given
        let movieToAddParameters = AddMovieParameters(id: 0,
                                                      title: "Movie 0",
                                                      overview: "Overview for movie 0",
                                                      date: "23-3-2019",
                                                      poster: "http://posterformovie0.png")
        let movieToAdd = Movie.createMovie()
        let expectedResultToBeReturned: Result<Movie> = Result.failure(NSError.createError(withMessage: "Any error message"))
        moviesGatewaySpy.addMovieResultToBeReturned = expectedResultToBeReturned
        
        let addMovieCompletionHandlerExpectation = expectation(description: "Add Movie Expectation")
        
        // When
        addMovieUseCase.add(parameters: movieToAddParameters) { (result) in
            
            // Then
            XCTAssertEqual(expectedResultToBeReturned, result, "Completion handler didn't return the expected result")
            XCTAssertEqual(movieToAdd, self.moviesGatewaySpy.addedMovie, "Incorrect movie passed to the gateway")
            addMovieCompletionHandlerExpectation.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

}
