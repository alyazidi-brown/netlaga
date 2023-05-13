//
//  CustomAnnotation.swift
//  Netlaga
//
//  Created by Scott Brown on 5/1/23.
//

import UIKit
import MapKit
import CoreLocation

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate :CLLocationCoordinate2D
    var title :String?
    var subtitle :String?
    
    init(coordinate :CLLocationCoordinate2D, title :String?, subtitle :String?) {
        
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
}
