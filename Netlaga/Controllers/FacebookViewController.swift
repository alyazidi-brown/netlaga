//
//  FacebookViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/3/22.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import AuthenticationServices

class FacebookViewController: UIViewController, LoginButtonDelegate {
    
    private let signInButton = ASAuthorizationAppleIDButton() //Apple Auth
    
    var orLabel = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        signInButton.frame = CGRect(x: 40, y: 150, width: view.frame.width - 80, height: 100)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
       
        orLabel.frame = CGRect(x: 100, y: 300, width: view.frame.width - 200, height: 50)
        orLabel.text = "OR"
        orLabel.textAlignment = .center
        view.addSubview(orLabel)
        
        
        let loginButton = FBLoginButton(frame: .init(x: 40, y: 400, width: view.frame.width - 80, height: 100))//FBLoginButton(frame: .init(x: 40, y: 400, width: view.frame.width - 80, height: 100), permissions: [.publicProfile])
        //loginButton.center = view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)

        
        
    // Handle clicks on the button
   // loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        
            //Facebook Auth
        if let accessToken = AccessToken.current,
           !accessToken.isExpired {
                // User is logged in, do work such as go to next view controller.
            print("User is already logged in")
            print(accessToken)
            firebaseFaceBookLogin(accessToken: accessToken.tokenString)
          
       }
            
    }
    
        //Facebook Auth
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("User Logged In")
        
        if let error = error {
            print("Encountered Erorr: \(error)")
        } else if let result = result, result.isCancelled {
            print("Cancelled")
        }else {
            
            print("Logged In")
            
            if ((result?.grantedPermissions) != nil) == true {
                
            } else if ((result?.declinedPermissions) != nil) == true {
                
            }
            
        }
    
    }
    
        //Facebook Auth
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User Logged Out")
    }
    
    /*
        // Once the button is clicked, show the login dialog
    @objc func loginButtonClicked() {
                let loginManager = LoginManager()
                loginManager.logIn(permissions: ["public_profile", "email"], from: self) { result, error in
                    if let error = error {
                        print("Encountered Erorr: \(error)")
                    } else if let result = result, result.isCancelled {
                        print("Cancelled")
                    } else {
                        print("Logged In")
                    }
                }
            }
    */
    
    //Facebook Auth
    func firebaseFaceBookLogin(accessToken: String) {
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credential, completion: {(authResult, error) in
            
            if let error = error {
                print("firebase login error")
                print(error)
                return
            }
            
            print("firebase login done")
            print(authResult as Any)
            if let user = Auth.auth().currentUser {
                
                print("Current firebase user is")
                print(user)
            }
            
            
        })
    }
    
//Apple Auth
    
    @objc func didTapSignIn() {
        print("need to know how it works3")
        let provider = ASAuthorizationAppleIDProvider()
        print("need to know how it works4")
        let request = provider.createRequest()
        print("need to know how it works5")
        request.requestedScopes = [.fullName, .email]
        print("need to know how it works6")
        let controller = ASAuthorizationController(authorizationRequests: [request])
        print("need to know how it works7")
        controller.delegate = self
        print("need to know how it works8")
        controller.presentationContextProvider = self
        print("need to know how it works9")
        controller.performRequests()
        print("need to know how it works13")
        
    }


}


//Apple Auth

extension FacebookViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed!")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            print("need to know how it works1")
            let firstName = credentials.fullName?.givenName
            
            let lastName = credentials.fullName?.familyName
            
            let email = credentials.email
        default:
            print("need to know how it works2")
            break
        }
    }
    
    
}


//Apple Auth
extension FacebookViewController: ASAuthorizationControllerPresentationContextProviding {
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        print("need to know how it works")
        return view.window!
    }
    
}

