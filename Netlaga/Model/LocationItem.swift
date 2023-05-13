//
//  LocationItem.swift
//  Netlaga
//
//  Created by Scott Brown on 5/3/23.
//

import Foundation
import UIKit
import MessageKit
import CoreLocation

class Location : LocationItem {
    
    
    var location: CLLocation = CLLocation()
    
    var size: CGSize
    
    init(location: CLLocation, size: CGSize) {
       
        self.location = location
        self.size = size
    }
}
