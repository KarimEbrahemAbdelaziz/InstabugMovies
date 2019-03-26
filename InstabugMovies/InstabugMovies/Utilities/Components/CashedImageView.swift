//
//  CashedImageView.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import UIKit

/**
 A convenient UIImageView to load and cache images.
 */
class CachedImageView: UIImageView {
    
    static let imageCache = NSCache<NSString, DiscardableImageCacheItem>()
    
    var url: URL!
    var downloadedImage: UIImage!
    private var emptyImage: UIImage = UIImage(named: "empty-movie-poster")!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
    }
    
    /**
     Easily load an image from a URL string and cache it to reduce network overhead later.
     
     - parameter urlString: The url location of your image, usually on a remote server somewhere.
     - parameter completion: Optionally execute some task after the image download completes
     */
    
    func loadImage(urlString: String, completion: (() -> ())? = nil) {
        image = nil
        
        let urlKey = urlString as NSString
        
        if let cachedItem = CachedImageView.imageCache.object(forKey: urlKey) {
            image = cachedItem.image
            completion?()
            return
        }
        
        guard let url = URL(string: "http://image.tmdb.org/t/p/w185\(urlString)") else {
            image = emptyImage
            return
        }
        
        self.url = url
        startDownload(urlString: urlString)
    }
    
    func startDownload(urlString: String) {
        guard InstaubgImagePendingOperations.shared.downloadsInProgress[urlString] == nil else { return }
        
        let downloader = InstaubgImageDownloader(self)
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                InstaubgImagePendingOperations.shared.downloadsInProgress.removeValue(forKey: urlString)

                if self.downloadedImage != self.emptyImage {
                    let cacheItem = DiscardableImageCacheItem(image: self.downloadedImage)
                    CachedImageView.imageCache.setObject(cacheItem, forKey: urlString as NSString)
                    self.image = self.downloadedImage
                } else {
                    self.image = self.downloadedImage
                }
            }
        }

        InstaubgImagePendingOperations.shared.downloadsInProgress[urlString] = downloader
        InstaubgImagePendingOperations.shared.downloadQueue.addOperation(downloader)
    }
}
