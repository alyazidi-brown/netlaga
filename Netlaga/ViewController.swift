//
//  ViewController.swift
//  Netlaga
//
//  Created by Scott Brown on 3/22/23.
//https://github.com/firebase/quickstart-ios/issues/586

import UIKit
import SwiftUI


class ViewController: UIViewController {
    
    var viewCheck = GradientView()
    
    
    
    var logoImageView = UIImageView()
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor(red: 232.0/255.0, green: 113.0/255.0, blue: 35.0/255.0, alpha: 1.0), UIColor(red: 168.0/255.0, green: 23.0/255.0, blue: 222.0/255.0, alpha: 1.0)]
                gradient.locations = [0.0 , 1.0]
                gradient.startPoint = CGPoint(x : 0.0, y : 0)
                gradient.endPoint = CGPoint(x :0.0, y: 0.5) // you need to play with 0.15 to adjust gradient vertically
                gradient.frame = view.bounds
                view.layer.addSublayer(gradient)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        viewCheck.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        self.view.addSubview(viewCheck)
        
        
     
        
        logoImageView.image = UIImage(named: "Netlaga logo transparent centred")
        
        
        logoImageView.frame = CGRect(x: -20, y: view.frame.height/2 - 75, width: view.frame.width - 40, height: 150)
        viewCheck.addSubview(logoImageView)
        
        
    
    }
    
    //Function to generate the UIImage from 2 colors.
    func createGradient(color1: UIColor, color2: UIColor) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        let image = image(from: gradientLayer)
        return image
    }

    //Function to generate an Image from a CALayer.
    func image(from layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, true, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage ?? UIImage()
    }
    
    
   


}

