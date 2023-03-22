//
//  SMSCodeViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/2/22.
//

import UIKit

class SMSCodeViewController: UIViewController, UITextFieldDelegate {
    
    var signUp : Bool = false
    
    private let codeField: UITextField = {
        
      let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "SMS Code"
        field.returnKeyType = .continue
        field.textAlignment = .center
        return field
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        //view.backgroundColor = .systemBackground
        view.addSubview(codeField)
        codeField.frame = CGRect(x:0, y:0, width: 220, height: 50)
        codeField.center = view.center
        codeField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
           print("try here")
            let code = text
            AuthManager.shared.verifyCode(smsCode: code) {[weak self] success in
                print("try here2")
                guard success else {return}
                
                print("try here3")
                
                DispatchQueue.main.async {
                    if self!.signUp == true {
                    let vc = InputViewController()//FacebookViewController()//InputViewController()//EmailViewController()//InputViewController()
                    vc.title = "Enter Code"
                    self?.present(vc, animated: true)
                        
                    } else {
                        
                        let vc = HomeTabBarController()
                        self!.present(vc, animated: true, completion: nil)
                        
                        
                    }
                    
                }
            }
                
                
            }
            
        
        return true
    }


}

