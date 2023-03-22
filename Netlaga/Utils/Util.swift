//
//  Util.swift
//  DatingApp
//
//  Created by Scott Brown on 1/12/23.
//

import Foundation
import UIKit
import FirebaseStorage

class Util {
    static func getStringFromDate(format: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        //dateFormatter.dateFormat = "YYYY,MMM d,HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
}

