//
//  PhotoMessage.swift
//  DatingApp
//
//  Created by Scott Brown on 12/28/22.
//

import Foundation
import MessageKit


class PhotoMessage: NSObject, MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(path: String) {
        self.url = URL(fileURLWithPath: path)
        self.placeholderImage = UIImage(named: "avatar")!
        self.size = CGSize(width: 240, height: 240)
    }
    
    
    
}

