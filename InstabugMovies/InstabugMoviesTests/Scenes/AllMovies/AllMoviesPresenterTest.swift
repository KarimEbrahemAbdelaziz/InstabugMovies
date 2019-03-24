//
//  AllMoviesPresenterTest.swift
//  InstabugMoviesTests
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

@testable import InstabugMovies
import XCTest

class AllMoviesPresenterTest: XCTestCase {

    let diplayMoviesUseCaseStub = DiplayMoviesUseCaseStub()
    let addMovieUseCaseSpy = AddMovieUseCaseSpy()
    let moviesViewRouterSpy = MoviesViewRouterSpy()
    let allMoviesViewSpy = AllMoviesViewSpy()
    
    var allMoviesPresenter: AllMoviesPresenterImplementation!
    
    override func setUp() {
        super.setUp()
        
        allMoviesPresenter = AllMoviesPresenterImplementation(view: allMoviesViewSpy, displayMoviesUseCase: diplayMoviesUseCaseStub, addMovieUseCase: addMovieUseCaseSpy, router: moviesViewRouterSpy)
    }

    override func tearDown() {
        super.tearDown()
        
        allMoviesPresenter = nil
    }
    
    // MARK: - Tests
    
    func testViewDidLoadSuccessRefreshAllMoviesViewCalled() {
        // Given
        let moviesToBeReturned = Movie.createMoviesArray()
        diplayMoviesUseCaseStub.resultToBeReturned = .success(moviesToBeReturned)
        
        // When
        allMoviesPresenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(allMoviesViewSpy.refreshAllMoviesViewCalled, "refreshAllMoviesView was not called")
    }
    
    func testViewDidLoadSuccessNumberOfMovies() {
        // Given
        let expectedNumberOfMovies = 5
        let moviesToBeReturned = Movie.createMoviesArray(numberOfElements: expectedNumberOfMovies)
        diplayMoviesUseCaseStub.resultToBeReturned = .success(moviesToBeReturned)
        
        // When
        allMoviesPresenter.viewDidLoad()
        
        // Then
        XCTAssertEqual(expectedNumberOfMovies, allMoviesPresenter.numberOfMovies, "Number of movies mismatch")
    }
    
    func testViewDidLoadFailureDisplayMoviesRetrievalError() {
        // Given
        let expectedErrorTitle = "Error"
        let expectedErrorMessage = "Some error message"
        let errorToBeReturned = NSError.createError(withMessage: expectedErrorMessage)
        diplayMoviesUseCaseStub.resultToBeReturned = .failure(errorToBeReturned)
        
        // When
        allMoviesPresenter.viewDidLoad()
        
        // Then
        XCTAssertEqual(expectedErrorTitle, allMoviesViewSpy.displayAllMoviesRetrievalErrorTitle, "Error title doesn't match")
        XCTAssertEqual(expectedErrorMessage, allMoviesViewSpy.displayAllMoviesRetrievalErrorMessage, "Error message doesn't match")
    }
    
    func testConfigureCellHasExpectedIndormation() {
        // Given
        allMoviesPresenter.movies = Movie.createMoviesArray()
        let rowToConfigure = 1
        let expectedDisplayedTitle = "Movie \(rowToConfigure)"
        let expectedDisplayedOverview = "Overview for movie \(rowToConfigure)"
        let expectedDisplayedReleaseDate = "23-3-2019"
        let expectedDisplayedPoster = "http://posterformovie\(rowToConfigure).png"
        
        let movieCellSpy = MovieCellSpy()
        
        // When
        allMoviesPresenter.configureAPI(cell: movieCellSpy, forRow: rowToConfigure)
        
        // Then
        XCTAssertEqual(expectedDisplayedTitle, movieCellSpy.displayedTitle, "The title we expected was not displayed")
        XCTAssertEqual(expectedDisplayedOverview, movieCellSpy.displayedOverview, "The overview we expected was not displayed")
        XCTAssertEqual(expectedDisplayedReleaseDate, movieCellSpy.displayedReleaseDate, "The date we expected was not displayed")
        XCTAssertEqual(expectedDisplayedPoster, movieCellSpy.displayedPoster, "The poster we expected was not displayed")
    }
    
    func testAddButtonPressedNavigatesToAddMovieView() {
        // When
        allMoviesPresenter.addButtonPressed()
        
        // Then
        XCTAssertTrue(allMoviesPresenter === moviesViewRouterSpy.passedAddMoviePresenterDelegate, "AllMoviesPresenter wasn't passed as delegate to AllMoviesViewRouter")
    }
    
    func testAddMoviePresenterDidAddMovieRefreshAllMoviesViewCalled() {
        // Given
        let addedMovie = Movie.createMovie()
        let addMovieViewRouterSpy = AddMovieViewRouterSpy()
        let addMoviePresenterStub = AddMoviePresenterStub(router: addMovieViewRouterSpy)
        
        // When
        allMoviesPresenter.addMoviePresenter(addMoviePresenterStub, didAdd: addedMovie)
        
        // Then
        XCTAssertTrue(allMoviesPresenter.localMovies.contains(addedMovie), "Movie wasn't added in the presenter")
        XCTAssertTrue(addMovieViewRouterSpy.didCallDismiss, "Dismiss wasn't called on the AddMovieViewRouter")
        XCTAssertTrue(allMoviesViewSpy.refreshAllMoviesViewCalled, "refreshAllMoviesView was not called")
    }
    
    func testAddMoviePresenterCancelDismissView() {
        // Given
        let addMovieViewRouterSpy = AddMovieViewRouterSpy()
        let addMoviePresenterStub = AddMoviePresenterStub(router: addMovieViewRouterSpy)
        
        // When
        allMoviesPresenter.addMoviePresenterCancel(presenter: addMoviePresenterStub)
        
        // Then
        XCTAssertTrue(addMovieViewRouterSpy.didCallDismiss, "Dismiss wasn't called on the AddMovieViewRouter")
    }

}
