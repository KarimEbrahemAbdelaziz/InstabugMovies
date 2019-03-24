//
//  DiscardableImageCacheItem.swift
//  InstabugMovies
//
//  Created by Karim Ebrahem on 3/24/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import UIKit

class DiscardableImageCacheItem: NSObject, NSDiscardableContent {
    
    private(set) public var image: UIImage?
    var accessCount: UInt = 0
    
    init(image: UIImage) {
        self.image = image
    }
    
    func beginContentAccess() -> Bool {
        if image == nil {
            return false
        }
        
        accessCount += 1
        return true
    }
    
    func endContentAccess() {
        if accessCount > 0 {
            accessCount -= 1
        }
    }
    
    func discardContentIfPossible() {
        if accessCount == 0 {
            image = nil
        }
    }
    
    func isContentDiscarded() -> Bool {
        return image == nil
    }
    
}
