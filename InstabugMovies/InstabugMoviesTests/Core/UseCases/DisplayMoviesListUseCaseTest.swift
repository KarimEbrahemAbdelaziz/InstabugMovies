//
//  DisplayMoviesListUseCaseTest.swift
//  InstabugMoviesTests
//
//  Created by Karim Ebrahem on 3/23/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

@testable import InstabugMovies
import XCTest

class DisplayMoviesListUseCaseTest: XCTestCase {
    
    let moviesGatewaySpy = MoviesGatewaySpy()
    var displayMoviesListUseCase: DisplayMoviesUseCaseImplementation!

    override func setUp() {
        super.setUp()
        
        displayMoviesListUseCase = DisplayMoviesUseCaseImplementation(moviesGateway: moviesGatewaySpy)
    }

    override func tearDown() {
        super.tearDown()
        
        displayMoviesListUseCase = nil
    }

    func testDisplayMoviesSuccessCallsCompletionHandler() {
        // Given
        let moviesToDisplay = Movie.createMoviesArray()
        let expectedResultToBeReturned: Result<[Movie]> = Result.success(moviesToDisplay)
        moviesGatewaySpy.fetchMoviesResultToBeReturned = expectedResultToBeReturned
        
        let displayMoviesCompletionHandlerExpectation = expectation(description: "Display Movies Expectation")
        
        // When
        displayMoviesListUseCase.displayMovies(pageNumber: 1) { (result) in
            
            // Then
            XCTAssertEqual(expectedResultToBeReturned, result, "Completion handler didn't return the expected result")
            displayMoviesCompletionHandlerExpectation.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testDisplayMoviesFailureCallsCompletionHandler() {
        // Given
        let expectedResultToBeReturned: Result<[Movie]> = Result.failure(NSError.createError(withMessage: "Any error message"))
        moviesGatewaySpy.fetchMoviesResultToBeReturned = expectedResultToBeReturned
        
        let displayMoviesCompletionHandlerExpectation = expectation(description: "Display Movies Expectation")
        
        // When
        displayMoviesListUseCase.displayMovies(pageNumber: 1) { (result) in
            
            // Then
            XCTAssertEqual(expectedResultToBeReturned, result, "Completion handler didn't return the expected result")
            displayMoviesCompletionHandlerExpectation.fulfill()
            
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

}
