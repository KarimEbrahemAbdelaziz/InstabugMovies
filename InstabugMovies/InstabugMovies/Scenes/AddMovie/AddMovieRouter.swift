//
//  AddMovieRouter.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation

protocol AddMovieRouter: ViewRouter {
    func dismiss()
}

class AddMovieRouterImplementation: AddMovieRouter {
    fileprivate weak var addMovieViewController: AddMovieViewController?
    
    init(addMovieViewController: AddMovieViewController) {
        self.addMovieViewController = addMovieViewController
    }
    
    // MARK: - AddBookRouter
    
    func dismiss() {
        addMovieViewController?.dismiss(animated: true, completion: nil)
    }
}
