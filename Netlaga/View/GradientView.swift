//
//  GradientView.swift
//  Netlaga
//
//  Created by Scott Brown on 11/07/2023.
//

import Foundation
import UIKit

class GradientView : UIView {
    

    var topColor: UIColor = UIColor(red: 168.0/255.0, green: 23.0/255.0, blue: 222.0/255.0, alpha: 1.0)
    
    var bottomColor: UIColor = UIColor(red: 232.0/255.0, green: 113.0/255.0, blue: 35.0/255.0, alpha: 1.0)
    
    var startPointX: CGFloat = 1//0
    var startPointY: CGFloat = 0//0
    var endPointX: CGFloat = 0//1
    var endPointY: CGFloat = 1//1
    
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    
    
    
}
