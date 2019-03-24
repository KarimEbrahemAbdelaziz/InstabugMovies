//
//  AddMoviePresenter.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

protocol AddMovieView: class {
    func updateAddButtonState(isEnabled enabled: Bool)
    func updateCancelButtonState(isEnabled enabled: Bool)
    func displayAddMovieError(title: String, message: String)
}

// In the most simple cases (like this one) the delegate wouldn't be needed
// I added it just to highlight how two presenters would communicate
// Most of the time it's fine for the view controller to dimiss itself
protocol AddMoviePresenterDelegate: class {
    func addMoviePresenter(_ presenter: AddMoviePresenter, didAdd movie: Movie)
    func addMoviePresenterCancel(presenter: AddMoviePresenter)
}

protocol AddMoviePresenter {
    var router: AddMovieRouter { get }
    var manimumReleaseDate: Date { get }
    func addButtonPressed(parameters: AddMovieParameters)
    func cancelButtonPressed()
}

class AddMoviePresenterImplementation: AddMoviePresenter {
    fileprivate weak var view: AddMovieView?
    fileprivate var addMovieUseCase: AddMovieUseCase
    fileprivate weak var delegate: AddMoviePresenterDelegate?
    private(set) var router: AddMovieRouter
    
    init(view: AddMovieView,
         addMovieUseCase: AddMovieUseCase,
         router: AddMovieRouter,
         delegate: AddMoviePresenterDelegate?) {
        self.view = view
        self.addMovieUseCase = addMovieUseCase
        self.router = router
        self.delegate = delegate
    }
    
    var manimumReleaseDate: Date {
        return Date()
    }
    
    func addButtonPressed(parameters: AddMovieParameters) {
        updateNavigationItemsState(isEnabled: false)
        addMovieUseCase.add(parameters: parameters) { (result) in
            self.updateNavigationItemsState(isEnabled: true)
            switch result {
            case let .success(movie):
                self.handleMovieAdded(movie)
            case let .failure(error):
                self.handleAddMovieError(error)
            }
        }
    }
    
    func cancelButtonPressed() {
        delegate?.addMoviePresenterCancel(presenter: self)
    }
    
    // MARK: - Private
    
    fileprivate func handleMovieAdded(_ movie: Movie) {
        delegate?.addMoviePresenter(self, didAdd: movie)
    }
    
    fileprivate func handleAddMovieError(_ error: Error) {
        // Here we could check the error code and display a localized error message
        view?.displayAddMovieError(title: "Error", message: error.localizedDescription)
    }
    
    fileprivate func updateNavigationItemsState(isEnabled enabled: Bool) {
        view?.updateAddButtonState(isEnabled: enabled)
        view?.updateCancelButtonState(isEnabled: enabled)
    }
}
