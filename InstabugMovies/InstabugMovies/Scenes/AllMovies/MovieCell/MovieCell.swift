//
//  MovieCell.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell, MovieCellView {
    
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var moviePosterImageView: CachedImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDateLabel: UILabel!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 8.0
    }
    
    func display(title: String) {
        self.movieDateLabel.text = title
    }
    
    func display(poster: String) {
        self.moviePosterImageView.loadImage(urlString: poster)
    }
    
    func display(releaseDate: String) {
        self.movieDateLabel.text = releaseDate
    }
    
    func display(overview: String) {
        self.movieOverviewLabel.text = overview
    }
    
}
