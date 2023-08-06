//
//  SMSCodeViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/2/22.
//

import UIKit
import FirebaseAuth
import Foundation
import Alamofire

class SMSCodeViewController: UIViewController, UITextFieldDelegate {
    
    var signUp : Bool = false
    var verificationId: String?

    var viewCheck = GradientView()
    
    var codeOne: String = ""
    var codeTwo: String = ""
    var codeThree: String = ""
    var codeFour: String = ""
    var codeFive: String = ""
    var codeSix: String = ""
    
    private let codeField: UITextField = {
        
      let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "SMS Code"
        field.returnKeyType = .continue
        field.textAlignment = .center
        return field
        
    }()
    
    private let codeFieldOne: UITextField = {
        
      let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = ""
        field.returnKeyType = .continue
        field.textAlignment = .center
        return field
        
    }()
    
    private let codeFieldTwo: UITextField = {
        
      let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = ""
        field.returnKeyType = .continue
        field.textAlignment = .center
        return field
        
    }()
    
    private let codeFieldThree: UITextField = {
        
      let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = ""
        field.returnKeyType = .continue
        field.textAlignment = .center
        return field
        
    }()
    
    private let codeFieldFour: UITextField = {
        
      let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = ""
        field.returnKeyType = .continue
        field.textAlignment = .center
        return field
        
    }()
    
    private let codeFieldFive: UITextField = {
        
      let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = ""
        field.returnKeyType = .continue
        field.textAlignment = .center
        return field
        
    }()
    
    private let codeFieldSix: UITextField = {
        
      let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = ""
        field.returnKeyType = .continue
        field.textAlignment = .center
        return field
        
    }()
    
    let codeLabel: UILabel = {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var fontSize: CGFloat = 0.0
        
        switch (deviceIdiom) {

        case .pad:
            
            fontSize = 38
           
            
        case .phone:
           
            fontSize = 30
        default:
            
            fontSize = 30
           
        }
        
        let label = UILabel()
        label.text = "Enter Your Code"
        label.textColor = .white
        label.textAlignment = .left
        //label.font = UIFont.systemFont(ofSize: fontSize)
        
        label.font = UIFont(name:"HelveticaNeue-Bold", size: fontSize)
        label.numberOfLines = 0
        return label
    }()
    
    private let continueButton: NewAuthButton = {
        let button = NewAuthButton(type: .system)
        button.setTitle("Next", for: .normal)
        
        button.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        
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
    
    private let dismissButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
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
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("<", for: .normal)
        
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        button.setTitleColor(.white, for: .normal)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        // 2. check the idiom
        switch (deviceIdiom) {

        case .pad:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 60)
            //print("iPad style UI")
        case .phone:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
           // print("iPhone and iPod touch style UI")
       // case .tv:
           // print("tvOS style UI")
        default:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
           // print("Unspecified UI idiom")
        }
        
        return button
    }()
    
    private let resendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Resend", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        button.addTarget(self, action: #selector(resendAction), for: .touchUpInside)
        
       
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        // 2. check the idiom
        switch (deviceIdiom) {

        case .pad:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
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
    
    let phoneRequiredLabel: UILabel = {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var fontSize: CGFloat = 0.0
        
        switch (deviceIdiom) {

        case .pad:
            
            fontSize = 20
           
            
        case .phone:
           
            fontSize = 16
        default:
            
            fontSize = 16
           
        }
        
        let label = UILabel()
        label.text = "Phone Number Required"
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //view.backgroundColor = .white
        //view.backgroundColor = .systemBackground
        
        viewCheck.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        self.view.addSubview(viewCheck)
        
        viewCheck.addSubview(backButton)
        backButton.anchor(top: viewCheck.topAnchor, left: viewCheck.leftAnchor, paddingTop: 50, paddingLeft: 20, width: 40, height: 40)
        
        viewCheck.addSubview(codeLabel)
        codeLabel.anchor(top: backButton.bottomAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 20, width: 300, height: 80)
        
        viewCheck.addSubview(codeFieldFour)
        codeFieldFour.anchor(top: codeLabel.bottomAnchor, left: view.centerXAnchor, paddingTop: 110, paddingLeft: 5, width: 40, height: 50)
        
        codeFieldFour.layer.cornerRadius = 6
        codeFieldFour.layer.masksToBounds = true
        codeFieldFour.delegate = self
        
        viewCheck.addSubview(codeFieldFive)
        codeFieldFive.anchor(top: codeLabel.bottomAnchor, left: codeFieldFour.rightAnchor, paddingTop: 110, paddingLeft: 10, width: 40, height: 50)
        
        codeFieldFive.layer.cornerRadius = 6
        codeFieldFive.layer.masksToBounds = true
        codeFieldFive.delegate = self
        
        viewCheck.addSubview(codeFieldSix)
        codeFieldSix.anchor(top: codeLabel.bottomAnchor, left: codeFieldFive.rightAnchor, paddingTop: 110, paddingLeft: 10, width: 40, height: 50)
        
        codeFieldSix.layer.cornerRadius = 6
        codeFieldSix.layer.masksToBounds = true
        codeFieldSix.delegate = self
        
        viewCheck.addSubview(codeFieldThree)
        codeFieldThree.anchor(top: codeLabel.bottomAnchor, right: view.centerXAnchor, paddingTop: 110, paddingRight: 5, width: 40, height: 50)
        
        codeFieldThree.layer.cornerRadius = 6
        codeFieldThree.layer.masksToBounds = true
        codeFieldThree.delegate = self
        
        viewCheck.addSubview(codeFieldTwo)
        codeFieldTwo.anchor(top: codeLabel.bottomAnchor, right: codeFieldThree.leftAnchor, paddingTop: 110, paddingRight: 10, width: 40, height: 50)
        
        codeFieldTwo.layer.cornerRadius = 6
        codeFieldTwo.layer.masksToBounds = true
        codeFieldTwo.delegate = self
        
        viewCheck.addSubview(codeFieldOne)
        codeFieldOne.anchor(top: codeLabel.bottomAnchor, right: codeFieldTwo.leftAnchor, paddingTop: 110, paddingRight: 10, width: 40, height: 50)
        
        codeFieldOne.layer.cornerRadius = 6
        codeFieldOne.layer.masksToBounds = true
        codeFieldOne.delegate = self
        
        viewCheck.addSubview(phoneRequiredLabel)
        phoneRequiredLabel.anchor(top: codeFieldSix.bottomAnchor, right: codeFieldSix.rightAnchor, paddingTop: 10, paddingRight: 0, width: 200, height: 50)
        
        phoneRequiredLabel.isHidden = true
        
        
        viewCheck.addSubview(resendButton)
        resendButton.anchor(bottom: codeFieldSix.topAnchor, right: codeFieldSix.rightAnchor, paddingBottom: 20, paddingRight: 0, width: 200, height: 50)
        resendButton.contentHorizontalAlignment = .right
        
        
        continueButton.frame = CGRect(x: 40, y: 650, width: view.frame.width - 80, height: 50)
        viewCheck.addSubview(continueButton)
        continueButton.layer.cornerRadius = continueButton.frame.height/2
        
        /*
        view.addSubview(codeField)
        codeField.frame = CGRect(x:0, y:0, width: 220, height: 50)
        codeField.center = view.center
        codeField.delegate = self
        
        view.addSubview(continueButton)
        continueButton.anchor(top: codeField.bottomAnchor, paddingTop: 30, width: 0.5*view.frame.width, height: 50)
        continueButton.centerX(inView: view)
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: continueButton.bottomAnchor, paddingTop: 30, width: 0.5*view.frame.width, height: 50)
        dismissButton.centerX(inView: view)
         */
        
        codeFieldOne.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        codeFieldTwo.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        codeFieldThree.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        codeFieldFour.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        codeFieldFive.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        codeFieldSix.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
            let text = textField.text
            if  text?.count == 1 {
                switch textField{
                case codeFieldOne:
                    codeFieldTwo.becomeFirstResponder()
                case codeFieldTwo:
                    codeFieldThree.becomeFirstResponder()
                case codeFieldThree:
                    codeFieldFour.becomeFirstResponder()
                case codeFieldFour:
                    codeFieldFive.becomeFirstResponder()
                case codeFieldFive:
                    codeFieldSix.becomeFirstResponder()
                case codeFieldSix:
                    codeFieldSix.resignFirstResponder()
                default:
                    break
                }
            }
            if  text?.count == 0 {
                switch textField{
                case codeFieldOne:
                    codeFieldOne.becomeFirstResponder()
                case codeFieldTwo:
                    codeFieldOne.becomeFirstResponder()
                case codeFieldThree:
                    codeFieldTwo.becomeFirstResponder()
                case codeFieldFour:
                    codeFieldThree.becomeFirstResponder()
                case codeFieldFive:
                    codeFieldFour.becomeFirstResponder()
                case codeFieldSix:
                    codeFieldFive.becomeFirstResponder()
                default:
                    break
                }
            }
            else{

            }
        }
    
    /*
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

*/
    
    @objc func backAction() {
        print("It goes here")
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func resendAction() {
       
            let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
                spinningActivity.label.text = "Loading.  Please wait."
            spinningActivity.detailsLabel.text = ""
            
            if (self.view.frame.width > 414) {
                
                //spinningActivity.frame = CGRect(x: self.view.frame.width/2 - 100, y: 300, width: 200, height: 250)
                spinningActivity.minSize = CGSize(width:200, height: 250);
                
                spinningActivity.label.font = UIFont(name: "Helvetica", size:20)
                
                spinningActivity.detailsLabel.font = UIFont(name: "Helvetica", size:18)//label.font = UIFont(name: "Helvetica", size:18)
                
                
            }else{
                
                
                
                
            }
            
        
            var number = UserTwo.phone
            
            
            
            if signUp == false {
            
            let parameters: [String:Any] = ["phoneNumber": number]
            
                    let url = "https://us-central1-datingapp-80400.cloudfunctions.net/phoneExists"
                    
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
                        
                
                   //print("response \(response)")
                        switch response.result {
                            case .success(let dict):
                            
                            let successDict: [String: Any?] = dict as? [String: Any?] ?? [:]
                            
                            let uid = successDict["uid"] as? String ?? ""
                            
                            //self.authTest(uidString: uid)
                                
                            //print("dictionary \(dict)")
                            
                            MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            self.numberVerified(number: number)
                               
                            case .failure(let error):
                            
                            MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                        
                            let alert = UIAlertController(title: "User does not exist", message: "Please check the number again or sign up.", preferredStyle: UIAlertController.Style.alert)

                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "Go To Log In Page?", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                                print("Handle Ok logic here")
                                
                                let vc = LogInViewController()//RegistrationViewController()//InputViewController()
                                vc.view.backgroundColor = .white
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true, completion: nil)
                              
                                }))
                            
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                                  print("Handle Cancel Logic here")
                            }))

                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                            
                            print("delete here5 \(error.localizedDescription)")
                               
                               
                                //completion(nil, error.localizedDescription)
                        }
                    }
            } else {
                
                self.numberVerified(number: number)
                
            }
          
    }
    
    func numberVerified(number: String, uid: String? = "") {
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity.label.text = "Verifying Phone Number.  Please wait."
        spinningActivity.detailsLabel.text = ""
        
        if (self.view.frame.width > 414) {
            
            //spinningActivity.frame = CGRect(x: self.view.frame.width/2 - 100, y: 300, width: 200, height: 250)
            spinningActivity.minSize = CGSize(width:200, height: 250);
            
            spinningActivity.label.font = UIFont(name: "Helvetica", size:20)
            
            spinningActivity.detailsLabel.font = UIFont(name: "Helvetica", size:18)//label.font = UIFont(name: "Helvetica", size:18)
            
            
        }else{
            
            
            
            
        }
        
        let parameters: [String:Any] = ["uid": uid]
        
        let url = "https://us-central1-datingapp-80400.cloudfunctions.net/authExists"
                
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
                    
            
               //print("response \(response)")
            switch response.result {
                
                
            case .success(let dict):
                
                
                let successDict: [String: Any?] = dict as? [String: Any?] ?? [:]
                
                
                let email = successDict["email"] as? String ?? ""
                let emailVerified = successDict["emailVerified"] as? Int ?? 0
                let uid = successDict["uid"] as? String ?? ""
                
                
                if emailVerified == 1 {
                    
                print("we will check with database")
                    
                    self.completephoneAuth(number: number)
                    
                } else {
                    
                    if self.signUp == false {
                        
                        MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        
                        let alert = UIAlertController(title: "User does not exist", message: "Please sign up.", preferredStyle: UIAlertController.Style.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "Go To Log In Page?", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                            print("Handle Ok logic here")
                            
                            let vc = LogInViewController()//RegistrationViewController()//InputViewController()
                            vc.view.backgroundColor = .white
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true, completion: nil)
                            
                            
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                            print("Handle Cancel Logic here")
                        }))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    } else {
                        
                        
                        self.completephoneAuth(number: number)
                    }
                
                print("we will proceed to linking")
                
            }
            
                print("dict \(dict)")
                       
                           
                case .failure(let error):
                
                MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                UIApplication.shared.endIgnoringInteractionEvents()
                
                let alert = UIAlertController(title: "Oops.  Something went wrong", message: "Please sign up. \(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "Go To Log In Page?", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                    
                    let vc = LogInViewController()//RegistrationViewController()//InputViewController()
                    vc.view.backgroundColor = .white
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                    
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                print("delete here5 \(error.localizedDescription)")
                           
                print(error.localizedDescription)
                            //completion(nil, error.localizedDescription)
                    }
                }
        
    }
    
    func completephoneAuth(number: String) {
       
        
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) {[weak self] verificationId, error in
            
            
            if let error = error {
                
                MBProgressHUD.hide(for: (self?.view)!, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                UIApplication.shared.endIgnoringInteractionEvents()
                   
                self!.presentAlertController(withTitle: "Oops An Error Occured", message: error.localizedDescription)
                
                print("phone error here \(error.localizedDescription)")
                    return
                  }
             
            
            guard let verificationId = verificationId, error == nil else {
                
                MBProgressHUD.hide(for: self!.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                UIApplication.shared.endIgnoringInteractionEvents()
                
                self!.presentAlertController(withTitle: "Oops An Error Occured", message: error!.localizedDescription)
                
                return
            }
            
            self?.verificationId = verificationId
            
            MBProgressHUD.hide(for: self!.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

            UIApplication.shared.endIgnoringInteractionEvents()
            
            DispatchQueue.main.async { [self] in
                
                
                let vc =  SMSCodeViewController() //your view controller
                print("4th sign up \(self!.signUp)")
                vc.signUp = self!.signUp
                vc.verificationId = verificationId
                vc.title = "Enter Code"
                vc.modalPresentationStyle = .overFullScreen
                self!.present(vc, animated: true, completion: nil)
                
            }
            
        }
        
        
    }
    
    @objc func continueAction() {
        
       // if let text = codeField.text, !text.isEmpty {
           
           // let code = text
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity.label.text = "Verifying Code.  Please wait."
        spinningActivity.detailsLabel.text = ""
        
        if (self.view.frame.width > 414) {
            
            //spinningActivity.frame = CGRect(x: self.view.frame.width/2 - 100, y: 300, width: 200, height: 250)
            spinningActivity.minSize = CGSize(width:200, height: 250);
            
            spinningActivity.label.font = UIFont(name: "Helvetica", size:20)
            
            spinningActivity.detailsLabel.font = UIFont(name: "Helvetica", size:18)//label.font = UIFont(name: "Helvetica", size:18)
            
            
        }else{
            
            
            
            
        }
        
        if !codeFieldOne.text!.isEmpty, !codeFieldTwo.text!.isEmpty, !codeFieldThree.text!.isEmpty, !codeFieldFour.text!.isEmpty, !codeFieldFive.text!.isEmpty, !codeFieldSix.text!.isEmpty {
           print("try here sms")
            
            //let code = text
            
            codeOne = codeFieldOne.text!
            codeTwo = codeFieldTwo.text!
            codeThree = codeFieldThree.text!
            codeFour = codeFieldFour.text!
            codeFive = codeFieldFive.text!
            codeSix = codeFieldSix.text!
            
            //let code = text
            var code: String = ""
            
            code = codeOne + codeTwo + codeThree + codeFour + codeFive + codeSix
            
            print("the code is good \(code)")
           
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId ?? "", verificationCode: code)
        
            if self.signUp == true {
                
                Auth.auth().currentUser?.link(with: credential) { result, error in
                    
                    MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    guard result != nil, error == nil else {
                        
                        
                        self.presentAlertController(withTitle: "Oops An Error Occured", message: error!.localizedDescription)
                        return
                    }
                   
                    
                    DispatchQueue.main.async {
                        print("5th sign up \(self.signUp)")
                       
                        let vc = InputViewController()
                        vc.title = "Enter Code"
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                            
                        
                    }
                }
                
                
            } else {
                
                auth.signIn(with: credential) { result, error in
                    
                    MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    guard result != nil, error == nil else {
                        
                        self.presentAlertController(withTitle: "Oops An Error Occured", message: error!.localizedDescription)
                        return
                    }
                   
                    
                    DispatchQueue.main.async {
                    
                            
                            let vc = HomeTabBarController()
                        vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                            
                        
                    }
                }
                
                
            }
                
            }else {
                
                MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                UIApplication.shared.endIgnoringInteractionEvents()
                
                phoneRequiredLabel.isHidden = false
            }
        
    }
    
    
    /*
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
        if let text = textField.text, !text.isEmpty {
           print("try here sms")
            let code = text
            
            /*
            guard let verificationId = verificationId else {
                
                self.presentAlertController(withTitle: "Error", message: "Unable to verify")
                
                return
            }
*/
            
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId ?? "", verificationCode: code)
        
        /*
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                
                self.presentAlertController(withTitle: "Oops An Error Occured", message: error!.localizedDescription)
                return
            }
           
            
            DispatchQueue.main.async {
                if self.signUp == true {
                let vc = InputViewController()//EmailViewController()//InputViewController()//FacebookViewController()//InputViewController()//EmailViewController()//InputViewController()
                vc.title = "Enter Code"
                    self.present(vc, animated: true)
                    
                } else {
                    
                    let vc = HomeTabBarController()
                    self.present(vc, animated: true, completion: nil)
                    
                    
                }
                
            }
        }*/
            /*
            Auth.auth().currentUser?.link(with: credential) { result, error in
                guard result != nil, error == nil else {
                    
                    self.presentAlertController(withTitle: "Oops An Error Occured", message: error!.localizedDescription)
                    return
                }
               
                
                DispatchQueue.main.async {
                    print("5th sign up \(self.signUp)")
                    if self.signUp == true {
                    let vc = InputViewController()//EmailViewController()//InputViewController()//FacebookViewController()//InputViewController()//EmailViewController()//InputViewController()
                    vc.title = "Enter Code"
                        self.present(vc, animated: true)
                        
                    } else {
                        
                        print("try here2")
                        
                        let vc = HomeTabBarController()
                        self.present(vc, animated: true, completion: nil)
                        
                        
                    }
                    
                }
            }
             */
            
            if self.signUp == true {
                
                Auth.auth().currentUser?.link(with: credential) { result, error in
                    guard result != nil, error == nil else {
                        
                        self.presentAlertController(withTitle: "Oops An Error Occured", message: error!.localizedDescription)
                        return
                    }
                   
                    
                    DispatchQueue.main.async {
                        print("5th sign up \(self.signUp)")
                       
                        let vc = InputViewController()//EmailViewController()//InputViewController()//FacebookViewController()//InputViewController()//EmailViewController()//InputViewController()
                        vc.title = "Enter Code"
                        vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true)
                            
                        
                    }
                }
                
                
            } else {
                
                auth.signIn(with: credential) { result, error in
                    guard result != nil, error == nil else {
                        
                        self.presentAlertController(withTitle: "Oops An Error Occured", message: error!.localizedDescription)
                        return
                    }
                   
                    
                    DispatchQueue.main.async {
                    
                            
                        let vc = HomeTabBarController()
                        
                        UIApplication.shared.windows.first?.rootViewController = vc
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                        
                        vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                            
                        
                    }
                }
                
                
            }
                
            }
            
        
        return true
    }
    */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity.label.text = "Verifying Phone Number.  Please wait."
        spinningActivity.detailsLabel.text = ""
        
        if (self.view.frame.width > 414) {
            
            //spinningActivity.frame = CGRect(x: self.view.frame.width/2 - 100, y: 300, width: 200, height: 250)
            spinningActivity.minSize = CGSize(width:200, height: 250);
            
            spinningActivity.label.font = UIFont(name: "Helvetica", size:20)
            
            spinningActivity.detailsLabel.font = UIFont(name: "Helvetica", size:18)//label.font = UIFont(name: "Helvetica", size:18)
            
            
        }else{
            
            
            
            
        }
        
        
        if !codeFieldOne.text!.isEmpty, !codeFieldTwo.text!.isEmpty, !codeFieldThree.text!.isEmpty, !codeFieldFour.text!.isEmpty, !codeFieldFive.text!.isEmpty, !codeFieldSix.text!.isEmpty {
           print("try here sms")
            
            codeOne = codeFieldOne.text!
            codeTwo = codeFieldTwo.text!
            codeThree = codeFieldThree.text!
            codeFour = codeFieldFour.text!
            codeFive = codeFieldFive.text!
            codeSix = codeFieldSix.text!
            
            //let code = text
            var code: String = ""
            
            code = codeOne + codeTwo + codeThree + codeFour + codeFive + codeSix
           
            print("the code is good \(code)")
            
            
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId ?? "", verificationCode: code)
        
       
            
            if self.signUp == true {
                
                Auth.auth().currentUser?.link(with: credential) { result, error in
                    
                    MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    guard result != nil, error == nil else {
                        
                        self.presentAlertController(withTitle: "Oops An Error Occured", message: error!.localizedDescription)
                        return
                    }
                   
                    
                    DispatchQueue.main.async {
                        print("5th sign up \(self.signUp)")
                       
                        /*
                        let vc = InputViewController()//EmailViewController()//InputViewController()//FacebookViewController()//InputViewController()//EmailViewController()//InputViewController()
                        vc.title = "Enter Code"
                        vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true)
                         
                         */
                        
                        let vc = LocationServicesController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true)
                        
                            
                        
                    }
                }
                
                
            } else {
                
                auth.signIn(with: credential) { result, error in
                    
                    MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    guard result != nil, error == nil else {
                        
                        self.presentAlertController(withTitle: "Oops An Error Occured", message: error!.localizedDescription)
                        return
                    }
                   
                    
                    DispatchQueue.main.async {
                    
                            
                        let vc = HomeTabBarController()
                        
                        UIApplication.shared.windows.first?.rootViewController = vc
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                        
                        vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                            
                        
                    }
                }
                
                
            }
                
        } else {
            
            MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

            UIApplication.shared.endIgnoringInteractionEvents()
            
            phoneRequiredLabel.isHidden = false
        }
            
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


