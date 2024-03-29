//
//  InterestsViewController.swift
//  partyingApp
//
//  Created by Scott Brown on 8/18/22.
//

import Foundation
import UIKit
import Alamofire
import Firebase
import FirebaseAuth

class InterestsViewController: UIViewController {
    
    var foodsBool: Bool = false
    var sportsBool: Bool = false
    var partyingBool: Bool = false
    var gamingBool: Bool = false
    var moviesBool: Bool = false
    
    var imageViewTapped = ""
    
    var interestsArr : [String] = []
    
    let titleLabel: UILabel = {
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
        label.text = "Interests are..."
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    private let gamingButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Gaming", for: .normal)
        
        button.addTarget(self, action: #selector(gamingAction), for: .touchUpInside)
        
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
    
    private let moviesButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Movies", for: .normal)
        
        button.addTarget(self, action: #selector(moviesAction), for: .touchUpInside)
        
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
    
    private let foodsButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Foods", for: .normal)
        
        button.addTarget(self, action: #selector(foodsAction), for: .touchUpInside)
        
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
    
    private let sportsButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sports", for: .normal)
        
        button.addTarget(self, action: #selector(sportsAction), for: .touchUpInside)
        
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
    
    private let partyingButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Partying", for: .normal)
        
        button.addTarget(self, action: #selector(partyingAction), for: .touchUpInside)
        
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
    
   
    
    private let registerButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Register", for: .normal)
        
        button.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        
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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        print("\(UserTwo.birthday) \(UserTwo.firstName) user struct")
        
        var backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: "backAction", for: .touchUpInside)
        view.addSubview(backbutton)
        backbutton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 50, paddingLeft: 0, width: 40)
        
        
        configureUI()
        
    }
    
    func configureUI() {
        
        
       
        let stackFirst = UIStackView(arrangedSubviews: [titleLabel, foodsButton, sportsButton, partyingButton, moviesButton, gamingButton, registerButton, dismissButton])
        stackFirst.axis = .vertical
        stackFirst.spacing = 50
        stackFirst.distribution = .equalSpacing
        
        view.addSubview(stackFirst)
        stackFirst.anchor(width: 0.9*view.frame.width)
        stackFirst.centerY(inView: view)
        stackFirst.centerX(inView: view)
        
    }
    
        // MARK: - Selectors
    
        
    
        // sends request to the server to upload the Image (ava/cover)
    func uploadImage(id: String) {
            
            imageViewTapped = "ava"
            
            /*
            // save method of accessing ID of current user
            guard let id = currentUser?["id"] else {
                return
            }
             
            */
            
            
            // STEP 1. Declare URL, Request and Params
            // url we gonna access (API)
            let url = URL(string: "https://netlaga.net/uploadImage.php")!
            
            // declaring reqeust with further configs
            var request = URLRequest(url: url)
            
            // POST - safest method of passing data to the server
            request.httpMethod = "POST"
            
            // values to be sent to the server under keys (e.g. ID, TYPE)
            let params = ["id": id, "type": imageViewTapped]
            //let params = ["id": id, "type": "ava"]
            
            // MIME Boundary, Header
            let boundary = "Boundary-\(NSUUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // if in the imageView is placeholder - send no picture to the server
            // Compressing image and converting image to 'Data' type
            var imageData = Data()
            
        /*
            if imageView.image != UIImage(named: "HomeCover.jpg") && imageView.image != UIImage(named: "UserTwo.png") {
                imageData = imageView.image!.jpegData(compressionQuality: 0.5)!
            }
         */
        
        imageData = UserTwo.avaImgData
        
        let testImg = UIImage(data: imageData)
        
        let testOrientation = testImg?.imageOrientation
        
        print("here is the test orientation")
        
        let currentDate = generateCurrentTimeStamp()
            
            // assigning full body to the request to be sent to the server
            request.httpBody = Helper().body(with: params, filename: "\(imageViewTapped)\(currentDate).jpg", filePathKey: "file", imageDataKey: imageData, boundary: boundary) as Data
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    
                    // error occured
                    if error != nil {
                        
                        MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        Helper().showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                        return
                    }
                    
                    
                    do {
                        
                        // save mode of casting any data
                        guard let data = data else {
                            MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                            UIApplication.shared.endIgnoringInteractionEvents()
                            Helper().showAlert(title: "Data Error", message: error!.localizedDescription, from: self)
                            return
                        }
                        
                        let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        print("YOU THERE ESSAY5? \(dataString)")
                        
                        // fetching JSON generated by the server - php file
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                        
                        // save method of accessing json constant
                        guard let parsedJSON = json else {
                            MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            return
                        }
                        
                        // uploaded successfully
                        if parsedJSON["status"] as! String == "200" {
                            
                            MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            // saving upaded user related information (e.g. ava's path, cover's path)
                            /*
                            currentUser = parsedJSON.mutableCopy() as? NSMutableDictionary
                            UserDefaults.standard.set(currentUser, forKey: "currentUser")
                            UserDefaults.standard.synchronize()
                             */
                            let avaImgURL = parsedJSON["ava"] as! String
                            
                            UserTwo.ava = avaImgURL
                            
                             let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
                            
                            let values = ["email": UserTwo.email, "firstName": UserTwo.firstName, "ava": UserTwo.ava, "token": token]
                            
                            Database.database(url: "https://datingapp-80400-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("users").child(UserTwo.uid).updateChildValues(values) { error, ref in
                            
                            //Database.database().reference().child("users").child(uid).updateChildValues(values) { error, ref in
                                
                                print("and here")
                                
                                if let error = error {
                                    
                                    print("firebase error here \(error.localizedDescription)")
                                        return
                                      }
                                
                                let vc = HomeTabBarController()//HomeViewController() //your view controller
                                
                                UIApplication.shared.windows.first?.rootViewController = vc
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                                
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true, completion: nil)
                                                           
                                                           print("why aren't we moving from here2")
                                                           
                                
                            }
                            
                            print("why aren't we moving from here")
                            
                           
                        // error while uploading
                        } else {
                            
                            // show the error message in AlertView
                            if parsedJSON["message"] != nil {
                                MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                                UIApplication.shared.endIgnoringInteractionEvents()
                                let message = parsedJSON["message"] as! String
                                Helper().showAlert(title: "Error", message: message, from: self)
                            }
                            
                        }
                        
                    } catch {
                        MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                        UIApplication.shared.endIgnoringInteractionEvents()
                        Helper().showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
                    }
                    
                }
            }.resume()
            
            
        }
    
    
       
        
        @objc func registerAction() {
            
            let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
                spinningActivity.label.text = "Loading.  Please wait."
            spinningActivity.detailsLabel.text = "Registering..."
            
            if (self.view.frame.width > 414) {
                
                //spinningActivity.frame = CGRect(x: self.view.frame.width/2 - 100, y: 300, width: 200, height: 250)
                spinningActivity.minSize = CGSize(width:200, height: 250);
                
                spinningActivity.label.font = UIFont(name: "Helvetica", size:20)
                
                spinningActivity.detailsLabel.font = UIFont(name: "Helvetica", size:18)//label.font = UIFont(name: "Helvetica", size:18)
                
                
            }else{
                
                
                
                
            }
            
            let joined = interestsArr.joined(separator: ";")
                
            UserTwo.interests = joined
            
            var emptyString = "default"
            
                //STEP 1. Declaring URL of the request; declaring the body to the url; declaring request with the safest methid - POST, that no one can grab our info.
             
                let url:URL = URL(string: "https://netlaga.net/register2.php")!
                let session = URLSession.shared
                
                let request = NSMutableURLRequest(url: url)
                request.httpMethod = "POST"
                request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
                
           
            
            let paramString: String = "uid=\(UserTwo.uid)&email=\(UserTwo.email)&firstName=\(UserTwo.firstName)&phoneNumber=\(UserTwo.phone)&birthday=\(UserTwo.birthday)&gender=\(UserTwo.gender)&Interested_In=\(UserTwo.matching)&Interests=\(joined)&Looking_For=\(UserTwo.lookingFor)&Facebook_link=\(UserTwo.Facebook_link)&cover=\(emptyString)&ava=\(emptyString)"
            
            
            print("param stuff \(paramString) \(UserTwo.lookingFor)  \(UserTwo.interests)  \(UserTwo.gender)  \(UserTwo.matching)  \(UserTwo.firstName)  \(UserTwo.birthday)")
              
                request.httpBody = paramString.data(using: String.Encoding.utf8)
                
                
                //STEP 2.  Execute created above request.
                let task = session.dataTask(with: request as URLRequest, completionHandler: {
                    (data, response, error) in
                    let helper = Helper()
                    
                    guard let _:Data = data, let _:URLResponse = response  , error == nil
                        
                        else {
                            //print("error")
                            if error != nil {
                                
                                MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                helper.showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                            }
                            return
                    }
                    
                    let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("YOU THERE ESSAY3? \(dataString)")
                    
                    DispatchQueue.main.async
                        {
                            
                            
                            
                            do {
                                
                                guard let data = data else {
                                    MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                                    UIApplication.shared.endIgnoringInteractionEvents()
                                    
                                   // helper.showAlert(title: "Data Error", message: error!.localizedDescription, from: self)
                                    
                                    let alert = UIAlertController(title: "Data Error.  Something went wrong in sign up.  Please try again.", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                                    // add an action (button)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                                        print("Handle Ok logic here")
                                        
                                        let user = Auth.auth().currentUser

                                        user?.delete { error in
                                          if let error = error {
                                            // An error happened.
                                          } else {
                                            // Account deleted.
                                              
                                              let vc = LogInViewController() //your view controller
                                              vc.modalPresentationStyle = .overFullScreen
                                              self.present(vc, animated: true, completion: nil)
                                          }
                                        }
                                      
                                        }))

                                    // show the alert
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    return
                                    
                                     }
                          
                                
                                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                                
                                // save method of accessing json constant
                                guard let parsedJSON = json else {
                                    return
                                }
                                
                                // uploaded successfully
                                if parsedJSON["status"] as! String == "200" {
                                    
                                    // saving upaded user related information (e.g. ava's path, cover's path)
                                    let email = parsedJSON["email"] as! String
                                    let id =    parsedJSON["id"] as! String
                                    let firstName = parsedJSON["firstName"] as! String
                                    let uid = parsedJSON["uid"] as! String
                                    
                                    UserTwo.email = email
                                    
                                    UserTwo.uid = uid
                                    
                                    UserTwo.id = id
                                    
                                    print("need to check that you go here")
                                    
                                  
                                    
                                    self.uploadImage(id: id)
                                    
                                    
                                    print("email stuff \(email)")
                                    
                                // error while uploading
                                } else {
                                    
                                    // show the error message in AlertView
                                    if parsedJSON["message"] != nil {
                                        MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                                        UIApplication.shared.endIgnoringInteractionEvents()
                                        
                                        let message = parsedJSON["message"] as! String
                                        
                                        //helper.showAlert(title: "JSON Error", message: message, from: self)
                                        
                                        
                                        let alert = UIAlertController(title: "JSON Error.  Something went wrong in sign up.  Please try again.", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                                        // add an action (button)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                                            print("Handle Ok logic here")
                                            
                                            let user = Auth.auth().currentUser

                                            user?.delete { error in
                                              if let error = error {
                                                // An error happened.
                                              } else {
                                                // Account deleted.
                                                  
                                                  let vc = LogInViewController() //your view controller
                                                  vc.modalPresentationStyle = .overFullScreen
                                                  self.present(vc, animated: true, completion: nil)
                                              }
                                            }
                                          
                                            }))

                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                                
                            }
                            catch
                            {
                            
                            MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            helper.showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
                                //print(error)
                            }
                    }
                    
                    
                    
                })
                    
                    .resume()
            
            
            
        }
    
    @objc func gamingAction() {
        
        if gamingBool == false {
            
            gamingBool = true
            
            gamingButton.setTitleColor(.red, for: .normal)
            
            interestsArr.append((gamingButton.titleLabel?.text)!)
            
        } else {
            
            gamingBool = false
            
        
            for i in 0...interestsArr.count - 1 {
                
                if interestsArr[i] == gamingButton.titleLabel?.text{
                    
                    interestsArr.remove(at: i)
                    
                }
                
            }
            
            gamingButton.setTitleColor(.black, for: .normal)
            
        }
        
    
    }
    
    @objc func moviesAction() {
        
        if moviesBool == false {
            
            moviesBool = true
            
            moviesButton.setTitleColor(.red, for: .normal)
            
            interestsArr.append((moviesButton.titleLabel?.text)!)
            
        } else {
            
            moviesBool = false
            
            for i in 0...interestsArr.count - 1 {
                
                if interestsArr[i] == moviesButton.titleLabel?.text{
                    
                    interestsArr.remove(at: i)
                    
                }
                
            }
            
            moviesButton.setTitleColor(.black, for: .normal)
            
        }
        
    
    }
  
    
    @objc func foodsAction() {
        
        if foodsBool == false {
            
            foodsBool = true
            
            foodsButton.setTitleColor(.red, for: .normal)
            
            interestsArr.append((foodsButton.titleLabel?.text)!)
            
        } else {
            
            foodsBool = false
            
            for i in 0...interestsArr.count - 1 {
                
                if interestsArr[i] == foodsButton.titleLabel?.text{
                    
                    interestsArr.remove(at: i)
                    
                }
                
            }
            
            foodsButton.setTitleColor(.black, for: .normal)
            
        }
        
    
    }
    
    @objc func sportsAction() {
        
       
        if sportsBool == false {
            
            sportsBool = true
            
            sportsButton.setTitleColor(.red, for: .normal)
            
            interestsArr.append((sportsButton.titleLabel?.text)!)
            
        } else {
            
            sportsBool = false
            
            for i in 0...interestsArr.count - 1 {
                
                if interestsArr[i] == sportsButton.titleLabel?.text{
                    
                    interestsArr.remove(at: i)
                    
                }
                
            }
            
            sportsButton.setTitleColor(.black, for: .normal)
            
        }
       
    }
    
    @objc func partyingAction() {
        
        if partyingBool == false {
            
            partyingBool = true
            
            partyingButton.setTitleColor(.red, for: .normal)
            
            interestsArr.append((partyingButton.titleLabel?.text)!)
            
        } else {
            
            partyingBool = false
            
            for i in 0...interestsArr.count - 1 {
                
                if interestsArr[i] == partyingButton.titleLabel?.text{
                    
                    interestsArr.remove(at: i)
                    
                }
                
            }
            
            partyingButton.setTitleColor(.black, for: .normal)
            
        }
    }
    

    @objc func backAction() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func generateCurrentTimeStamp () -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
            return (formatter.string(from: Date()) as NSString) as String
        }

}


    
    
  
