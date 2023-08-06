//
//  ImageCache.swift
//  Netlaga
//
//  Created by Scott Brown on 23/06/2023.
//

class ImageCache {

    private init() {}

    static let shared = NSCache<NSString, UIImage>()
}
