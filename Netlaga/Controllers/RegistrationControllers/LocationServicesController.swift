//
//  LocationServicesController.swift
//  Netlaga
//
//  Created by Scott Brown on 04/08/2023.
//

import UIKit
import SwiftUI
import CoreLocation


class LocationServicesController: UIViewController, CLLocationManagerDelegate {
    
    var signUp : Bool = false
    
    var viewCheck = GradientView()
    
    var transparentView = UIView()
    
    var logoImageView = UIImageView()
    
    var manager: CLLocationManager? = nil
    
    let netlagaLabel: UILabel = {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var fontSize: CGFloat = 0.0
        
        switch (deviceIdiom) {

        case .pad:
            
            fontSize = 46
           
            
        case .phone:
           
            fontSize = 40
        default:
            
            fontSize = 40
           
        }
        
        let label = UILabel()
        label.text = "Netlaga"
        label.textColor = .white
        label.textAlignment = .left
        
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize)
        
        return label
    }()
    
    let countryLabel: UILabel = {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var fontSize: CGFloat = 0.0
        
        switch (deviceIdiom) {

        case .pad:
            
            fontSize = 46
           
            
        case .phone:
           
            fontSize = 38
        default:
            
            fontSize = 38
           
        }
        
        let label = UILabel()
        label.text = "Set your location services"
        label.textColor = .white
        label.textAlignment = .left
        //label.font = UIFont.systemFont(ofSize: fontSize)
        
        label.font = UIFont(name:"HelveticaNeue-Bold", size: fontSize)
        label.numberOfLines = 0
        return label
    }()
    
    let instructionalLabel: UILabel = {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var fontSize: CGFloat = 0.0
        
        switch (deviceIdiom) {

        case .pad:
            
            fontSize = 28
           
            
        case .phone:
           
            fontSize = 20
        default:
            
            fontSize = 20
           
        }
        
        let label = UILabel()
        label.text = "We use your location to help you meet people around you."
        label.textColor = .white
        label.textAlignment = .left
        //label.font = UIFont.systemFont(ofSize: fontSize)
        label.font = UIFont(name: "Arial", size: fontSize)
        label.numberOfLines = 0
        return label
    }()
    

    
    private let locationAuthButton: NewAuthButton =  {
        let button = NewAuthButton(type: .system)
        button.setTitle("Location Services", for: .normal)
        
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        // 2. check the idiom
        switch (deviceIdiom) {

        case .pad:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
            //print("iPad style UI")
        case .phone:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
           // print("iPhone and iPod touch style UI")
       // case .tv:
           // print("tvOS style UI")
        default:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
           // print("Unspecified UI idiom")
        }
        
        return button
    }()

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
        
        

        
        locationAuthButton.frame = CGRect(x: 40, y: 650, width: view.frame.width - 80, height: 50)
        viewCheck.addSubview(locationAuthButton)
        locationAuthButton.layer.cornerRadius = locationAuthButton.frame.height/2
        
        logoImageView.image = UIImage(named: "FullLogo_Transparent_NoBuffer")
        
        
        logoImageView.frame = CGRect(x: 165, y: view.frame.height/2 - 300, width: view.frame.width - 330, height: 95)
        viewCheck.addSubview(logoImageView)
        
        viewCheck.addSubview(countryLabel)
        countryLabel.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 120)
        
        viewCheck.addSubview(instructionalLabel)
        instructionalLabel.anchor(top: countryLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingRight: 20, height: 60)
        
        //logoImageView.centerY(inView: self.view)
        //logoImageView.centerX(inView: self.view)
        //logoImageView.anchor(//(width: view.frame.width - 40, height: 150)
        
       
        
        //self.view.backgroundColor = .white
        
    
    }
    
    /*
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
    */
    
    
    @objc func phoneAction() {
        
        let vc =  PhoneViewController() //your view controller
        vc.signUp = signUp
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
         
        
    }
    
    @objc func emailAction() {
        
        
        
        let vc = EmailViewController()//PhoneViewController() //EmailViewController()//PhoneViewController() //your view controller
        vc.signUp = signUp
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func findMe() {
        // IMPORTANT 1. Add this to plist to allow tracking: NSLocationWhenInUseUsageDescription
        // IMPORTANT 2. Reset Simulator, then select Debug > Location > City Bycle Ride to trigger tracking (otherwise no locations)
        manager = CLLocationManager()
        manager!.delegate = self
        manager!.desiredAccuracy = kCLLocationAccuracyBest
        manager!.requestWhenInUseAuthorization()
        manager!.startUpdatingLocation()
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
            // self.locationTextField.text = "Navigation Tracking Not Authorized!"
        } else {
            print("LocationManager Authorized")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
    
    @objc func loginAction() {
        
        //findMe()
        /*
        if let bundleId = Bundle.main.bundleIdentifier,
            let url = URL(string: "\(UIApplication.openSettingsURLString)&root=Privacy&path=LOCATION/\(bundleId)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
         */
        
        if !hasLocationPermission() {
            let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            let alertController = UIAlertController(title: "Location Permission On", message: "Thank you for enabling location permissions.  Now you have enabled many cool features.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                
            })
            
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        let manager = CLLocationManager()
        
        
            
            if CLLocationManager.locationServicesEnabled() {
                switch manager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    hasPermission = false
                case .authorizedAlways, .authorizedWhenInUse:
                    hasPermission = true
                @unknown default:
                    break
                }
            } else {
                hasPermission = false
            }
            
        
        
        return hasPermission
    }
    
    func dismiss() {
            dismiss(animated: true, completion: nil)
        }
    


}




