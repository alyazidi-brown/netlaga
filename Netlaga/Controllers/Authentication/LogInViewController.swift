//
//  LogInViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 9/12/22.
//

import UIKit


class LogInViewController: UIViewController {
    
    private let loginButtonAuthButton: AuthButton = {
      let button = AuthButton(type: .system)
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
    
    
  private let signUpButtonAuthButton: AuthButton =  {
      let button = AuthButton(type: .system)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loginButtonAuthButton.frame = CGRect(x: 40, y: 150, width: view.frame.width - 80, height: 100)
        view.addSubview(loginButtonAuthButton)
        
        signUpButtonAuthButton.frame = CGRect(x: 40, y: 400, width: view.frame.width - 80, height: 100)
        self.view.addSubview(signUpButtonAuthButton)
        
    
    }
    
    
    
    @objc func loginAction() {
        
        let vc =  PhoneViewController() //your view controller
        vc.signUp = false
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
       
        
    }
    
    @objc func signUpAction() {
        
        let vc = PhoneViewController() //EmailViewController()//PhoneViewController() //your view controller
        vc.signUp = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
        
    }
    


}




