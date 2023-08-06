//
//  PhoneViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/2/22.
//

import UIKit
import FirebaseAuth
import Foundation
import Alamofire

struct ResponseData: Decodable {
    var countries: [Country]
}
struct Country : Decodable {
    var abb: String
    var name: String
    var code: String
    
}

class PhoneViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var signUp : Bool = false
    
    var rangeCounter: Int = 0
    
    var viewCheck = GradientView()
    
    var list =  [String]()//["1", "2", "3"]
    
    var alphaList =  [String]()
    
    var codeList =  [String]()
    
    var countryList : [Country] = []
    
    private var verificationId: String?
    
    var picker = UIPickerView()
    
    var fullNumber : String = ""
    
    var alphaCode: String = ""
    
    var areaCode: String = ""
    
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
    
    private let phoneField: UITextField = {
        
      let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "Phone (Digits Only)"
        field.returnKeyType = .continue
        field.textAlignment = .center
        return field
        
    }()
    
    private let countryField: UITextField = {
        
      let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "Number Code"
        field.returnKeyType = .continue
        field.textAlignment = .center
        return field
        
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
    
    let phoneLabel: UILabel = {
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
        label.text = "Enter remaining digits of your phone number (digits only)"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    let countryLabel: UILabel = {
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
        label.text = "What's Your Number?"
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
        label.text = "We will text you a code to verify you are real and protect our community."
        label.textColor = .white
        label.textAlignment = .left
        //label.font = UIFont.systemFont(ofSize: fontSize)
        label.font = UIFont(name: "Arial", size: fontSize)
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //
        //self.presentAlertController(withTitle: <#T##String#>, message: <#T##String#>)
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
        //view.backgroundColor = .systemBackground
        print("where 1")
        viewCheck.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        self.view.addSubview(viewCheck)
      
        viewCheck.addSubview(backButton)
        backButton.anchor(top: viewCheck.topAnchor, left: viewCheck.leftAnchor, paddingTop: 50, paddingLeft: 20, width: 40, height: 40)
        
        
        viewCheck.addSubview(countryLabel)
        countryLabel.anchor(top: backButton.bottomAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 20, width: 300, height: 80)
        
        
        print("where 2")

        
        continueButton.frame = CGRect(x: 40, y: 650, width: view.frame.width - 80, height: 50)
        viewCheck.addSubview(continueButton)
        continueButton.layer.cornerRadius = continueButton.frame.height/2
  

        
        print("where 4")
        viewCheck.addSubview(countryField)
        countryField.anchor(top: countryLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 80, paddingLeft: 20, width: 150, height: 50)
        countryField.layer.cornerRadius = 18
        countryField.layer.masksToBounds = true
        countryField.delegate = self
        
        
        print("where 3")
        viewCheck.addSubview(phoneField)
        phoneField.anchor(top: countryLabel.bottomAnchor, left: countryField.rightAnchor, right: viewCheck.rightAnchor, paddingTop: 80, paddingLeft: 5, paddingRight: 20, height: 50)
        phoneField.delegate = self
        phoneField.layer.cornerRadius = 18
        phoneField.layer.masksToBounds = true
        
        viewCheck.addSubview(phoneRequiredLabel)
        phoneRequiredLabel.anchor(top: phoneField.bottomAnchor, left: phoneField.leftAnchor, right: phoneField.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, height: 50)
        
        
        
        viewCheck.addSubview(instructionalLabel)
        instructionalLabel.anchor(top: phoneRequiredLabel.bottomAnchor, left: viewCheck.leftAnchor, right: viewCheck.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20, height: 50)
    
        
        //viewCheck.addSubview(phoneLabel)
        //phoneLabel.anchor(bottom: phoneField.topAnchor, paddingBottom: 30, width: 220, height: 50)
        //phoneLabel.centerX(inView: viewCheck)
        
        phoneLabel.text = "Enter remaining digits of your phone number (digits only)"
        countryLabel.text = "What's Your Number?"
        
        countryLabel.numberOfLines = 0
        
        phoneLabel.numberOfLines = 0
        
        picker.delegate = self
        picker.dataSource = self
        countryField.inputView = picker
        
        phoneRequiredLabel.isHidden = true
        phoneField.isHidden = true
        
        //print("load json \(loadJson(filename: "areacode"))")
        
        print("the list entry \(loadJson(filename: "areacode2"))")
        
        if loadJson(filename: "areacode2") != nil {
            
            print("the list entry 2")
            
            countryList = loadJson(filename: "areacode2")!
                       
            list = countryList.map{$0.name}
            
            codeList = countryList.map{$0.code}
            
            alphaList = countryList.map{$0.abb}
               
            print("the list \(list)")
           
            
        } else {
           
            
            
        }
        //print("load json \(readJSONFile(forName: "areacode"))")
        
        //readJSONFile(forName: "areacode")
    }
    
    func loadJson(filename fileName: String) -> [Country]? {
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.countries
            } catch {
                print("error:\(error)")
            }
        }
        return nil
      
        
        
        
        
        
        
    }
     
    
    /*
    func readJSONFile(forName name: String) {
        
        print("accessed json file")
      
        guard let bundlePath = Bundle.main.path(forResource: name, ofType: "json") else {
            print("accessed json file2")
            return}
        
        let url = URL(fileURLWithPath: bundlePath)
        print("accessed json file3")
        
        do {
            let data = try Data(contentsOf: url)
            
            print("json data \(data)")
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(ResponseData.self, from: data)
            //return jsonData.country
        } catch {
            print("error:\(error)")
        }
    }
   */
     
    
    @objc func backAction() {
        print("It goes here")
        
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return list[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return list.count
        }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var spaceHolder: String = ""
        
        countryField.text = "\(alphaList[row]) \(codeList[row])"
        
        spaceHolder = "\(alphaList[row]) \(codeList[row])"
        
        alphaCode = alphaList[row]
        
        areaCode = codeList[row]
        
        phoneField.isHidden = false
        
        let range = spaceHolder.range(of: spaceHolder)
        
        let convertedRange = NSRange(range!, in: spaceHolder)
        
        rangeCounter = spaceHolder.count
        
        print("range count \(rangeCounter)")
        
    }


func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    print("range count2 \(rangeCounter) \(range.length) \(range.location)")
    
    if textField == countryField {
        
        print("range count3 \(rangeCounter) \(range.length) \(range.location)")
       
        if range.location == rangeCounter - 1{
            return false
        }
        return true
        

    }
    
    return true
}
        
    /*
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
            countryField.text = list[row]//"\(alphaList[row]) \(codeList[row])"
            
            phoneField.text = codeList[row]
            
            phoneLabel.isHidden = false
            phoneField.isHidden = false
            
            let range = codeList[row].range(of: codeList[row])
            
            let convertedRange = NSRange(range!, in: codeList[row])
            
            rangeCounter = codeList[row].count
            
            print("range count \(rangeCounter)")
            
            //textField(textField: phoneField, shouldChangeCharactersInRange: convertedRange, replacementString: codeList[row])
            //textField(phoneField, shouldChangeCharactersIn: convertedRange, replacementString: codeList[row])
            //print(list[row])
        }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("range count2 \(rangeCounter) \(range.length) \(range.location)")
        
        if textField == phoneField {
            
            print("range count3 \(rangeCounter) \(range.length) \(range.location)")
            // handle username rules
            //if range.length>0  && range.location == 0 {
            if range.location == rangeCounter - 1{
                return false
            }
            return true
            
            /*
             if range.length>0  && range.location == 0 {
             return false
             }
             return true
             */
        }
        
        return true
    }
     */
    
    /*
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.length>0  && range.location == 0 {
                return false
        }
        return true
    }
     */
    
    @objc func continueAction() {
        print("It goes here continue")
        
        
        if let text = phoneField.text, !text.isEmpty {
            
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
            
            var number = areaCode + text//"\(text)"//"+1\(text)"
            
            UserTwo.phone = number
            
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
            
        }else {
            
            phoneRequiredLabel.isHidden = false
           
            
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            
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
            
            var number = areaCode + text
            
            number = number.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
            
            UserTwo.phone = number
            
            if signUp == false {
                print("this is the number \(number)")
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
                        
                       //Return to this when testing is complete
                        self.numberVerified(number: number, uid: uid)
                        
                        //Revert to this for testing with phone auth only
                        //self.completephoneAuth(number: number)
                        
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
            
        } else {
            
            phoneRequiredLabel.isHidden = false
           
            
        }
        return true
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

