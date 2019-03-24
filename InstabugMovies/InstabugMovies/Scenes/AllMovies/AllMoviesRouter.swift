//
//  AllMoviesRouter.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import UIKit

protocol AllMoviesViewRouter: ViewRouter {
    // TODO: Present add movie screen protocol function to be added
}

class AllMoviesViewRouterImplementation: AllMoviesViewRouter {
    
    fileprivate weak var allMoviesViewController: AllMoviesViewController?
    
    init(allMoviesViewController: AllMoviesViewController) {
        self.allMoviesViewController = allMoviesViewController
    }
    
    // MARK: - AllMoviesViewRouter
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

