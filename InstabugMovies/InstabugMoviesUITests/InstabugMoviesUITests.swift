//
//  AllMoviesMoviesUITests.swift
//  AllMoviesMoviesUITests
//
//  Created by Karim Ebrahem on 3/23/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import XCTest

class InstabugMoviesUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        
    }

    func testAddButtonPresentNewScreen() {
        // Given
        let moviesNavigationBar = app.navigationBars["Movies"]
        
        // When
        moviesNavigationBar.buttons["Add"].tap()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(moviesNavigationBar.exists, "The movies navigation bar is exist")
        }
    }
    
    func testAddButtonPresentAddMovieScreen() {
        // Given
        let moviesNavigationBar = app.navigationBars["Movies"]
        
        // When
        moviesNavigationBar.buttons["Add"].tap()
        let addMovieNavigationBar = app.navigationBars["Add Movie"]
        
        // Then
        XCTAssertTrue(addMovieNavigationBar.exists, "The add movie navigation bar is exist")
    }
    
    func testCancelButtonDismissAddMovieScreen() {
        // Given
        let moviesNavigationBar = app.navigationBars["Movies"]
        moviesNavigationBar.buttons["Add"].tap()
        let addMovieNavigationBar = app.navigationBars["Add Movie"]
        let cancelButton = addMovieNavigationBar.buttons["Cancel"]
        
        // When
        cancelButton.tap()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(addMovieNavigationBar.exists, "The add movie navigation bar is exist")
        }
    }
    
    func testSaveButtonWithEmptyTitlePresentAlert() {
        // Given
        let moviesNavigationBar = app.navigationBars["Movies"]
        moviesNavigationBar.buttons["Add"].tap()
        let addMovieNavigationBar = app.navigationBars["Add Movie"]
        let saveButton = addMovieNavigationBar.buttons["Save"]
        
        // When
        saveButton.tap()

        // Then
        let movieTitleRequiredAlert = app.alerts["Movie Title Required"]
        XCTAssertTrue(movieTitleRequiredAlert.exists, "Movies error alert not exist")
    }
    
    func testDismissAlertButtonDismissErrorAlert() {
        // Given
        let moviesNavigationBar = app.navigationBars["Movies"]
        moviesNavigationBar.buttons["Add"].tap()
        let addMovieNavigationBar = app.navigationBars["Add Movie"]
        let saveButton = addMovieNavigationBar.buttons["Save"]
        saveButton.tap()
        let movieTitleRequiredAlert = app.alerts["Movie Title Required"]
        let dismissAletButton = movieTitleRequiredAlert.buttons["Dismiss"]
        
        // When
        dismissAletButton.tap()
        
        // Then
        XCTAssertFalse(movieTitleRequiredAlert.exists, "Error Alert still exist")
    }

}
