//
//  NotificationsController.swift
//  Netlaga
//
//  Created by Scott Brown on 05/08/2023.
//

import UIKit
import SwiftUI
import UserNotifications


class NotificationsController: UIViewController, UNUserNotificationCenterDelegate {
    
    var signUp : Bool = false
    
    var viewCheck = GradientView()
    
    var transparentView = UIView()
    
    var logoImageView = UIImageView()
    
   
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
            
            fontSize = 42
           
            
        case .phone:
           
            fontSize = 32
        default:
            
            fontSize = 32
           
        }
        
        let label = UILabel()
        label.text = "Allow notifications"
        label.textColor = .white
        label.textAlignment = .center
        //label.font = UIFont.systemFont(ofSize: fontSize)
        
        label.font = UIFont(name:"HelveticaNeue-Bold", size: fontSize)
        //label.numberOfLines = 0
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
        label.text = "We'll let you know when you get new matches and messages."
        label.textColor = .white
        label.textAlignment = .left
        //label.font = UIFont.systemFont(ofSize: fontSize)
        label.font = UIFont(name: "Arial", size: fontSize)
        label.numberOfLines = 0
        return label
    }()
    

    
    private let locationAuthButton: NewAuthButton =  {
        let button = NewAuthButton(type: .system)
        button.setTitle("Allow notifications", for: .normal)
        
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
        
        /*
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.center = view.center
        progressView.setProgress(0.5, animated: true)
        progressView.trackTintColor = .lightGray
        progressView.tintColor = .blue
        viewCheck.addSubview(progressView)
         */
        
        locationAuthButton.frame = CGRect(x: 40, y: 650, width: view.frame.width - 80, height: 50)
        viewCheck.addSubview(locationAuthButton)
        locationAuthButton.layer.cornerRadius = locationAuthButton.frame.height/2
        
        logoImageView.image = UIImage(named: "notification")
        
        
        logoImageView.frame = CGRect(x: view.frame.width/2 - 47.5, y: view.frame.height/2 - 300, width: 95, height: 95)
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
    

    
    @objc func loginAction() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    // Already authorized
                }
                else {
                    // Either denied or notDetermined
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                        (granted, error) in
                          // add your own
                        UNUserNotificationCenter.current().delegate = self
                        let alertController = UIAlertController(title: "Notifications are off.", message: "Please turn on notifications to receive alerts.", preferredStyle: .alert)
                        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                })
                            }
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                        alertController.addAction(cancelAction)
                        alertController.addAction(settingsAction)
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)

                        }
                    }
                }
            }
        
        
    }
    
    
    
    func dismiss() {
            dismiss(animated: true, completion: nil)
        }
    


}


