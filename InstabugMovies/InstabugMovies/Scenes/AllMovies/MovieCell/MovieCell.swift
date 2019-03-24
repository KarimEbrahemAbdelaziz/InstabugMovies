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
        self.movieTitleLabel.text = title
    }
    
    func display(poster: String) {
        if !poster.contains("file:///") && !poster.isEmpty {
            self.moviePosterImageView.loadImage(urlString: poster)
        } else {
            guard let url = URL(string: poster), let imageData = NSData(contentsOf: url) as Data? else {
                self.moviePosterImageView.image = UIImage(named: "empty-movie-poster")
                return
            }
            self.moviePosterImageView.image = UIImage(data: imageData)
        }
    }
    
    func display(releaseDate: String) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let dateFormatterSet = DateFormatter()
        dateFormatterSet.dateFormat = "MMM dd,yyyy"
        var dateString = "Unknow release date"
        if let date = dateFormatterGet.date(from: releaseDate) {
            dateString = dateFormatterSet.string(from: date)
        } else {
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            if let date = dateFormatterGet.date(from: releaseDate) {
                dateString = dateFormatterSet.string(from: date)
            }
        }
        
        self.movieDateLabel.text = dateString
    }
    
    func display(overview: String) {
        self.movieOverviewLabel.text = overview
    }
    
}
