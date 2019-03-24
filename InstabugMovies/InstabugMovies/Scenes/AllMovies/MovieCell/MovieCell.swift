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
        self.moviePosterImageView.loadImage(urlString: poster)
    }
    
    func display(posterImage: String) {
        guard let image = getImage(imageName: posterImage) else {
            self.moviePosterImageView.image = UIImage(named: "")
            return
        }
        self.moviePosterImageView.image = image
    }
    
    private func getImage(imageName: String) -> UIImage? {
        var savedImage: UIImage?
        if let imagePath = getFilePath(fileName: imageName) {
            savedImage = UIImage(contentsOfFile: imagePath)
        } else {
            savedImage = nil
        }
        return savedImage
    }
    
    private func getFilePath(fileName: String) -> String? {
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        var filePath: String?
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if paths.count > 0 {
            let dirPath = paths[0] as NSString
            filePath = dirPath.appendingPathComponent(fileName)
        }
        else {
            filePath = nil
        }
        
        return filePath
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
