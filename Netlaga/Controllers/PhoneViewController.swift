//
//  PhoneViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/2/22.
//

import UIKit

class PhoneViewController: UIViewController, UITextFieldDelegate {
    
    var signUp : Bool = false
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            
            let number = "+1\(text)"
            
            User.phone = number
            
            AuthManager.shared.startAuth(phoneNumber: number) { [weak self] success in
                
                
                guard success else {
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


}

