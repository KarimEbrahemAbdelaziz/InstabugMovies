//
//  InstaubgImageDownloader.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/26/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation
import UIKit

class InstaubgImagePendingOperations {
    
    static let shared = InstaubgImagePendingOperations()
    
    var downloadsInProgress: [String: Operation]
    var downloadQueue: OperationQueue
    
    private init() {
        downloadsInProgress = [:]
        downloadQueue = OperationQueue()
        downloadQueue.name = "Download queue"
        downloadQueue.maxConcurrentOperationCount = 1
    }
    
    func suspendAllOperations() {
        downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        downloadQueue.isSuspended = false
    }
    
}

class InstaubgImageDownloader: Operation {
    let photoRecord: CachedImageView
    
    init(_ photoRecord: CachedImageView) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        if isCancelled { return }
        
        guard let imageData = try? Data(contentsOf: photoRecord.url) else { return }
        
        if isCancelled { return }
        
        if !imageData.isEmpty {
            photoRecord.downloadedImage = UIImage(data:imageData)
        } else {
            photoRecord.downloadedImage = UIImage(named: "empty-movie-poster")
        }
    }
}
