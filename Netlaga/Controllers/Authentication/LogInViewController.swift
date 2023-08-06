//
//  LogInViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 9/12/22.
//

import UIKit
import SwiftUI


class LogInViewController: UIViewController {
    
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
    
    
    private let loginButtonAuthButton: NewAuthButton = {
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
    
    
  private let signUpButtonAuthButton: NewAuthButton =  {
      let button = NewAuthButton(type: .system)
      button.setTitle("Sign Up", for: .normal)
      
      button.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
      
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
        
        
        loginButtonAuthButton.frame = CGRect(x: 40, y: 550, width: view.frame.width - 80, height: 50)
        viewCheck.addSubview(loginButtonAuthButton)
        loginButtonAuthButton.layer.cornerRadius = loginButtonAuthButton.frame.height/2
        
        signUpButtonAuthButton.frame = CGRect(x: 40, y: 650, width: view.frame.width - 80, height: 50)
        viewCheck.addSubview(signUpButtonAuthButton)
        signUpButtonAuthButton.layer.cornerRadius = signUpButtonAuthButton.frame.height/2
        
        logoImageView.image = UIImage(named: "Netlaga logo transparent centred")
        
        
        logoImageView.frame = CGRect(x: -20, y: view.frame.height/2 - 75, width: view.frame.width - 40, height: 150)
        viewCheck.addSubview(logoImageView)
        //logoImageView.centerY(inView: self.view)
        //logoImageView.centerX(inView: self.view)
        //logoImageView.anchor(//(width: view.frame.width - 40, height: 150)
        
       
        
        //self.view.backgroundColor = .white
        
    
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
    
    
    
    @objc func loginAction() {
        
        /*
        let vc = PhoneViewController()
        
        let navController = UINavigationController(rootViewController: vc)
        vc.signUp = false
        self.present(navController, animated:true, completion: nil)
        
         */

        let vc =  SignInViewController()//PhoneViewController() //your view controller
        vc.signUp = false
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
         
        
    }
    
    @objc func signUpAction() {
        
        /*
        
        
        let NameScreenData = NameScreenData()
        
        NameScreenData.signUp = true
        
        let settingsView = ContentView(dismissAction: {self.dismiss( animated: true, completion: nil )})
        let settingsViewController = UIHostingController(rootView: settingsView.environmentObject(NameScreenData) )
        
        settingsViewController.modalPresentationStyle = .overFullScreen

        present( settingsViewController, animated: true )
        
         */
        
        let vc = EmailViewController()//PhoneViewController() //EmailViewController()//PhoneViewController() //your view controller
        vc.signUp = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
         
         /*
        let vc = EmailViewController()
        
        let navController = UINavigationController(rootViewController: vc)
        vc.signUp = true
        self.present(navController, animated:true, completion: nil)
          */
        
        /*
        
        let circleView = ContentView(dismissAction: {self.dismiss( animated: true, completion: nil )})
        
        
        let NameScreenData = NameScreenData()
        
        NameScreenData.signUp = true
        
        
     
        let controller = UIHostingController(rootView: circleView.environmentObject(NameScreenData))
                addChild(controller)
                controller.view.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(controller.view)
                circleView.signUp = true
                controller.didMove(toParent: self)

                NSLayoutConstraint.activate([
                    controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                    controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                    controller.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                    controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
                ])
         
         */
    }
    
    func dismiss() {
            dismiss(animated: true, completion: nil)
        }
    


}




