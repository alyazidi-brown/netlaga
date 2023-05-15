//
//  PhoneViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/2/22.
//

import UIKit
import FirebaseAuth
import Foundation

class PhoneViewController: UIViewController, UITextFieldDelegate {
    
    var signUp : Bool = false
    
    private var verificationId: String?
    
    private let phoneField: UITextField = {
        
      let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "Phone"
        field.returnKeyType = .continue
        field.textAlignment = .center
        return field
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(phoneField)
        phoneField.frame = CGRect(x:0, y:0, width: 220, height: 50)
        phoneField.center = view.center
        phoneField.delegate = self
    }
    
    /*
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            
            let number = "\(text)"//"+1\(text)"
            
            User.phone = number
            
            AuthManager.shared.startAuth(phoneNumber: number) { [weak self] success, error in
            
                guard success else {
                    
                    self!.presentAlertController(withTitle: "Oops An Error Occured", message: error.localizedDescription)
                    print("or here?")
                    return}
                
                
                print("You make it here?")
                
                DispatchQueue.main.async { [self] in
                    
                    
                    let vc =  SMSCodeViewController() //your view controller
                    vc.signUp = self!.signUp
                    vc.title = "Enter Code"
                    vc.modalPresentationStyle = .overFullScreen
                    self!.present(vc, animated: true, completion: nil)
                    
                }
            }
            
        }
        return true
    }
*/
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            
            let number = "\(text)"//"+1\(text)"
            
            UserTwo.phone = number
            
            PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) {[weak self] verificationId, error in
                
                
                if let error = error {
                       
                    self!.presentAlertController(withTitle: "Oops An Error Occured", message: error.localizedDescription)
                    
                    print("phone error here \(error.localizedDescription)")
                        return
                      }
                 
                
                guard let verificationId = verificationId, error == nil else {
                    self!.presentAlertController(withTitle: "Oops An Error Occured", message: error!.localizedDescription)
                    
                    return
                }
                
                self?.verificationId = verificationId
                
                DispatchQueue.main.async { [self] in
                    
                    
                    let vc =  SMSCodeViewController() //your view controller
                    vc.signUp = self!.signUp
                    vc.verificationId = verificationId
                    vc.title = "Enter Code"
                    vc.modalPresentationStyle = .overFullScreen
                    self!.present(vc, animated: true, completion: nil)
                    
                }
                
            }
            
        }
        return true
    }

}

