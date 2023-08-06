//
//  SignInViewController.swift
//  Netlaga
//
//  Created by Scott Brown on 15/07/2023.
//

import UIKit
import SwiftUI


class SignInViewController: UIViewController {
    
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
    
    
    private let phoneButtonAuthButton: NewAuthButton = {
      let button = NewAuthButton(type: .system)
      button.setTitle("Sign In With Phone Number", for: .normal)
      
      button.addTarget(self, action: #selector(phoneAction), for: .touchUpInside)
      
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
    
    
  private let emailButtonAuthButton: NewAuthButton =  {
      let button = NewAuthButton(type: .system)
      button.setTitle("Sign In with Email", for: .normal)
      
      button.addTarget(self, action: #selector(emailAction), for: .touchUpInside)
      
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
    
    private let loginButtonAuthButton: NewAuthButton =  {
        let button = NewAuthButton(type: .system)
        button.setTitle("Log In", for: .normal)
        
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
        
        
        phoneButtonAuthButton.frame = CGRect(x: 40, y: 450, width: view.frame.width - 80, height: 50)
        viewCheck.addSubview(phoneButtonAuthButton)
        phoneButtonAuthButton.layer.cornerRadius = phoneButtonAuthButton.frame.height/2
        
        emailButtonAuthButton.frame = CGRect(x: 40, y: 550, width: view.frame.width - 80, height: 50)
        viewCheck.addSubview(emailButtonAuthButton)
        emailButtonAuthButton.layer.cornerRadius = emailButtonAuthButton.frame.height/2
        
        loginButtonAuthButton.frame = CGRect(x: 40, y: 650, width: view.frame.width - 80, height: 50)
        viewCheck.addSubview(loginButtonAuthButton)
        loginButtonAuthButton.layer.cornerRadius = loginButtonAuthButton.frame.height/2
        
        logoImageView.image = UIImage(named: "Netlaga logo transparent centred")
        
        
        logoImageView.frame = CGRect(x: -20, y: view.frame.height/2 - 175, width: view.frame.width - 40, height: 150)
        viewCheck.addSubview(logoImageView)
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
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func dismiss() {
            dismiss(animated: true, completion: nil)
        }
    


}


