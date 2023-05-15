//
//  HomeViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/29/22.
//

import Foundation
import UIKit
//import Firebase
import GeoFire
import CoreLocation
import Alamofire
import FirebaseAuth
import FirebaseFirestore
import Kingfisher


class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager: CLLocationManager? = nil
    
    

    let profilePhotoImageView: UIImageView = {
        let theImageView = UIImageView()
        
        if #available(iOS 13.0, *) {
        theImageView.image = UIImage(named: "user.png")
        }else{
        let image = UIImage(named: "user.png")?.withRenderingMode(.alwaysTemplate)
        theImageView.image = image
        theImageView.tintColor = UIColor.white
        }
           
           
           theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
        
        let idiomHeight = UIScreen.main.bounds.height
        if idiomHeight  < 736.0 {
            
            theImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            
        } else {
            
            theImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true

        }
        
        
           return theImageView
        }()
    
    
    private let firstnameLabel: UILabel = {
        let label = UILabel()
        label.text = "firstname"
        label.font = UIFont(name: "Avenir-Light", size: 14)
        label.textColor = .red
        return label
    }()
    
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.text = "likes"
        label.font = UIFont(name: "Avenir-Light", size: 14)
        label.textColor = .red
        return label
    }()
    
    private let logoutButtonAuthButton: AuthButton = {
      let button = AuthButton(type: .system)
      button.setTitle("Log Out", for: .normal)
      
      button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
      
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
        super.viewDidAppear(animated)
        
        //findMe()
        
         }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
       // fetchUserData()
        
        //try! Auth.auth().signOut()
        
        findMe()
        
        
        /*
        configureUI()
        
        
        let url = URL(string: User.ava)!
        downloadImage(from: url)
        
        firstnameLabel.text = User.firstName
        
        likesLabel.text = User.interests
        */
        
        //view.backgroundColor = .systemGreen
    }
    
    @objc func signOut() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            
            presentAlertController(withTitle: "Error", message: "Error signing out")
            print("DEBUG: Error signing out")
        }
    }
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LogInViewController())
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func deleteImage() {
       
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
            spinningActivity.label.text = "Loading.  Please wait."
        spinningActivity.detailsLabel.text = "Deleting User Data"
        
            if (self.view.frame.width > 414) {
                
                //spinningActivity.frame = CGRect(x: self.view.frame.width/2 - 100, y: 300, width: 200, height: 250)
                spinningActivity.minSize = CGSize(width:200, height: 250);
                
                spinningActivity.label.font = UIFont(name: "Helvetica", size:20)
                
                spinningActivity.detailsLabel.font = UIFont(name: "Helvetica", size:18)//label.font = UIFont(name: "Helvetica", size:18)
                
                
            }else{
                
                
                
                
            }
        
        var imageName : String = ""
        
        imageName = "MediaMessages/Photo/wkabil5XLNamZaxVdw2iF7D9J2K2/_22Jan2023193504jpg"
        
        
        let parameters: [String:Any] = ["fileName": imageName]
        
       
                
                let url = "https://us-central1-datingapp-80400.cloudfunctions.net/deleteImage"
                
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
                    
            print("delete here3 \(parameters) \(response)")
                    
                    switch response.result {
                        case .success(let dict):
                            
                            
                           
                            let successDict: [String: Any?] = dict as? [String: Any?] ?? [:]
                            
                            
                            
                           
                        case .failure(let error):
                            
                            MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            print(error.localizedDescription)
                            //completion(nil, error.localizedDescription)
                    }
                }
        
        
    }
    
    func fetchUserData(location: CLLocation) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }


        //let url:URL = URL(string: "http://localhost/Dating_App2/login.php")!
        let url:URL = URL(string: "https://netlaga.net/login.php")!
        let session = URLSession.shared

        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData




        let paramString: String = "uid=\(currentUid)"


        print("param stuff \(paramString)")

        request.httpBody = paramString.data(using: String.Encoding.utf8)


    //STEP 2.  Execute created above request.
    let task = session.dataTask(with: request as URLRequest, completionHandler: {
        (data, response, error) in
        let helper = Helper()
        
        guard let _:Data = data, let _:URLResponse = response  , error == nil
            
            else {
                //print("error")
                if error != nil {
                    
                    helper.showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                }
                return
        }
        
       let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
       // var dataString = NSString(data: data!, encoding: CFStringConvertEncodingToNSStringEncoding(0x0422))
                
        print("YOU THERE ESSAY3? \(dataString)")
        
        DispatchQueue.main.async
            {
            print("YOU THERE ESSAY4? ")
                
                
                do {
                    
                    print("YOU THERE ESSAY5? ")
                    
                   // guard let data = data else {
                     //   helper.showAlert(title: "Data Error", message: error!.localizedDescription, from: self)
                     //   return
                  //  }
              
                    print("YOU THERE ESSAY12? ")

                 
                    print("YOU THERE ESSAY13? ")
                    
                    let datadata = dataString!.data(using: String.Encoding.utf8.rawValue)
                    
                    if let json = try JSONSerialization.jsonObject(with: datadata!, options: []) as? [String : Any] {

                   // if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                   
                    print("YOU THERE ESSAY14? ")

                    
                    // uploaded successfully
                    if json["status"] as! String == "200" {
                        
                        //self.deleteImage()
                        
                        print("YOU THERE ESSAY6? \(dataString)")
                        
                        // saving upaded user related information (e.g. ava's path, cover's path)
                        let status = json["status"] as! String
                        let email = json["email"] as! String
                        let id =    json["id"] as! String
                        let firstName = json["firstName"] as! String
                        let uid = json["uid"] as! String
                        let phoneNumber = json["phoneNumber"] as! String
                        let birthday = json["birthday"] as! String
                        let gender = json["gender"] as! String
                        let Interested_In = json["Interested_In"] as! String
                        let Facebook_link = json["Facebook_link"] as! String
                        let ava = json["ava"] as! String
                        
                        UserTwo.uid = uid
                        UserTwo.email = email
                        UserTwo.firstName = firstName
                        UserTwo.ava = ava
                        
                        let userModel = UserModel(status: status, uid: uid, email: email, firstName: firstName, phoneNumber: phoneNumber, birthday: birthday, gender: gender, Interested_In: Interested_In, Facebook_link: Facebook_link, id: id, ava: ava)
                        
                        self.configureUI(ava: ava, firstName: firstName)
                        /*
                        var imageHolder : String = ""
                        
                       
                        imageHolder = User.ava.replacingOccurrences(of: "\\", with: "")
                        
                        let url = URL(string: imageHolder)!
                        self.downloadImage(from: url)
                        
                        self.firstnameLabel.text = User.firstName
                        
                        self.likesLabel.text = User.interests
                        
                        self.configureUI()
                         */
                        
                        print("the user model \(userModel)")
            
                        let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
                        
                       
                        geofire.setLocation(location, forKey: uid, withCompletionBlock: { (error) in
                            
                            print("strange that you don't make it here")
                            
                            if (error != nil) {
                                self.presentAlertController(withTitle: "Error", message: "\(error!.localizedDescription)")
                                
                                
                              } else {
                                
                              }
                            
                        })
                        
                    // error while uploading
                    } else {
                        
                        print("YOU THERE ESSAY7?")
                        
                        // show the error message in AlertView
                        if json["message"] != nil {
                            let message = json["message"] as! String
                            
                            helper.showAlert(title: "JSON Error", message: message, from: self)
                        }
                    }
                        
                    }
                    
                }
                catch
                {
                
                print("YOU THERE ESSAY8?")
                
                helper.showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
                    //print(error)
                }
        }
        
        
    })
        
        .resume()

    }
    
    
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.profilePhotoImageView.image = UIImage(data: data)
            }
        }
    }
    
    func findMe() {
            // IMPORTANT 1. Add this to plist to allow tracking: NSLocationWhenInUseUsageDescription
            // IMPORTANT 2. Reset Simulator, then select Debug > Location > City Bycle Ride to trigger tracking (otherwise no locations)
        manager = CLLocationManager()
        manager!.delegate = self
        manager!.desiredAccuracy = kCLLocationAccuracyBest
        manager!.requestWhenInUseAuthorization()
        manager!.startUpdatingLocation()
            
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
               // self.locationTextField.text = "Navigation Tracking Not Authorized!"
            } else {
                print("LocationManager Authorized")
            }
            
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
        let myLocation : CLLocation = locations[0]
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let myLocation2 = manager.location!
        print("locations = \(locValue.latitude) \(locValue.longitude) \(myLocation) \(myLocation2)")
        
        let longitude1 = locValue.longitude.roundToDecimal(10)
        
        let latitude1 = locValue.latitude.roundToDecimal(10)
        
        let myLocation3 = CLLocation(latitude: latitude1, longitude: longitude1)
        
        
        UserTwo.location = myLocation3
        
        print("my location 3 user location \(myLocation3) \(UserTwo.location)")
        
        fetchUserData(location: myLocation3)
        
        
        
            manager.stopUpdatingLocation()  // use this line only if 1 location is needed.
            
            CLGeocoder().reverseGeocodeLocation(myLocation, completionHandler:{(placemarks, error) in
                
                if ((error) != nil)  { print("Error: \(String(describing: error))") }
                else {
                    
                    let p = CLPlacemark(placemark: (placemarks?[0] as CLPlacemark?)!)
                    
                    var subThoroughfare:String = ""
                    var thoroughfare:String = ""
                    var subLocality:String = ""
                    var subAdministrativeArea:String = ""
                    var postalCode:String = ""
                    var country:String = ""
                    
                        // Use a series of ifs, or nil coalescing operators ??s, as per your coding preference.
                        
                    if ((p.subThoroughfare) != nil) {
                        subThoroughfare = (p.subThoroughfare)!
                    }
                    if ((p.thoroughfare) != nil) {
                        thoroughfare = p.thoroughfare!
                    }
                    if ((p.subLocality) != nil) {
                        subLocality = p.subLocality!
                    }
                    if ((p.subAdministrativeArea) != nil) {
                        subAdministrativeArea = p.subAdministrativeArea!
                    }
                    if ((p.postalCode) != nil) {
                        postalCode = p.postalCode!
                    }
                    
                    if ((p.country) != nil) {
                        country = p.country!
                    }
                    //self.locationTextField.text =  "\(subThoroughfare) \(thoroughfare)\n\(subLocality) \(subAdministrativeArea) \(postalCode)\n\(country)"
                }   // end else no error
              }       // end CLGeocoder reverseGeocodeLocation
            )       // end CLGeocoder
        }   // end of locationManager function

    
    

    
    ////UI configuration
    func configureUI(ava: String, firstName: String) {
        
        
            
            for view in self.view.subviews {
                view.removeFromSuperview()
            }
            
           
            
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.size.width/2
           
        profilePhotoImageView.layer.masksToBounds = true
            
            
            view.addSubview(profilePhotoImageView)
            profilePhotoImageView.centerX(inView: view)
            profilePhotoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor)
           
            
            view.addSubview(firstnameLabel)
            firstnameLabel.anchor(top: profilePhotoImageView.bottomAnchor, left: view.leftAnchor,  paddingTop: 50, paddingLeft: 20, width: 250, height: 50)
            
            view.addSubview(likesLabel)
            likesLabel.anchor(top: firstnameLabel.bottomAnchor, left: view.leftAnchor,  paddingTop: 50, paddingLeft: 20, width: 250, height: 50)
        
        view.addSubview(logoutButtonAuthButton)
        logoutButtonAuthButton.anchor(top: likesLabel.bottomAnchor, left: view.leftAnchor,  paddingTop: 50, paddingLeft: 20, width: 250, height: 50)
        
        let imageUrl = URL(string: ava)
        
        
        profilePhotoImageView.kf.setImage(with: imageUrl)
        
        firstnameLabel.text = firstName
            
        }

}


  

    ///Did this to have a buffer and cut down on image sizes without iterations since this is not a heavy image dependent app.  So profile images are scaled down to improve performance.
    extension UIImage {
       
      
        ///Proportionally resizes and compresses image
        func resized() -> UIImage? {
            
             var maxWidth:CGFloat = 0.0
             
             let actualHeight:CGFloat = self.size.height
             let actualWidth:CGFloat = self.size.width
             let imgRatio:CGFloat = actualWidth/actualHeight
            
            ///Adapted max width depending on device type.
             if UIDevice.current.userInterfaceIdiom == .pad {
                 // Available Idioms - .pad, .phone, .tv, .carPlay, .unspecified
                 // Implement your logic here
                  maxWidth = 1024.0
             }else{
                 
                 maxWidth = 414.0
             }
             
             let resizedHeight:CGFloat = maxWidth/imgRatio
             let compressionQuality:CGFloat = 0.5
      
            
            let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
            UIGraphicsBeginImageContext(rect.size)
            self.draw(in: rect)
            let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            let imageData2:Data = img.jpegData(compressionQuality: compressionQuality)!
            UIGraphicsEndImageContext()

            return UIImage(data: imageData2)!
            
            
        }
     
        ///Image size greatly reduced with minimal reduction in quality.
        func resizedMB() -> UIImage? {
            let resizingImage = self
            return resizingImage.resized()
        }
        
        
        
     
        
    }






extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}







/*

func fetchUserData(location: CLLocation) {
guard let currentUid = Auth.auth().currentUser?.uid else { return }

// let values = ["email" : ]

// Database.database().reference().child("users").child(currentUid).updateChildValues([AnyHashable : Any])

// print("the current id \(currentUid)")

let url:URL = URL(string: "http://localhost/Dating_App2/login.php")!
let session = URLSession.shared

let request = NSMutableURLRequest(url: url)
request.httpMethod = "POST"
request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData



//let paramString: String = "email=\(User.email)&firstName=\(User.firstName)&phoneNumber=\(User.phone)&birthday=\(User.birthday)&gender=\(User.gender)&Interested_In=\(User.matching)&Interests=\(User.interests)&Looking_For=\(User.lookingFor)&Facebook_link=\(User.Facebook_link)"

let paramString: String = "uid=\(currentUid)"


print("param stuff \(paramString)")

request.httpBody = paramString.data(using: String.Encoding.utf8)


//STEP 2.  Execute created above request.
let task = session.dataTask(with: request as URLRequest, completionHandler: {
    (data, response, error) in
    let helper = Helper()
    
    guard let _:Data = data, let _:URLResponse = response  , error == nil
        
        else {
            //print("error")
            if error != nil {
                
                helper.showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
            }
            return
    }
    
    let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
    print("YOU THERE ESSAY3? \(dataString)")
    
    DispatchQueue.main.async
        {
        print("YOU THERE ESSAY4? ")
            
            
            do {
                
                print("YOU THERE ESSAY5? ")
                
                guard let data = data else {
                    helper.showAlert(title: "Data Error", message: error!.localizedDescription, from: self)
                    return
                }
          
                print("YOU THERE ESSAY12? ")

                
               // let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                
                print("YOU THERE ESSAY13? ")

                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                // save method of accessing json constant
               // guard let parsedJSON = json else {
                 //   return
                //}
                print("YOU THERE ESSAY14? ")

                
                // uploaded successfully
                if json["status"] as! String == "200" {
                    
                    print("YOU THERE ESSAY6? \(dataString)")
                    
                    // saving upaded user related information (e.g. ava's path, cover's path)
                    let status = json["status"] as! String
                    let email = json["email"] as! String
                    let id =    json["id"] as! String
                    let firstName = json["firstName"] as! String
                    let uid = json["uid"] as! String
                    let phoneNumber = json["phoneNumber"] as! String
                    let birthday = json["birthday"] as! String
                    let gender = json["gender"] as! String
                    let Interested_In = json["Interested_In"] as! String
                    let Facebook_link = json["Facebook_link"] as! String
                    
                    
                    let userModel = UserModel(status: status, uid: uid, email: email, firstName: firstName, phoneNumber: phoneNumber, birthday: birthday, gender: gender, Interested_In: Interested_In, Facebook_link: Facebook_link, id: id)
                    
                    print("the user model \(userModel)")
        
                    let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
                    
                   
                    geofire.setLocation(location, forKey: uid, withCompletionBlock: { (error) in
                        
                        print("strange that you don't make it here")
                        
                        if (error != nil) {
                            self.presentAlertController(withTitle: "Error", message: "\(error!.localizedDescription)")
                            
                            
                          } else {
                            
                          }
                        
                       
                       
                    })
                    
                  
                    
                // error while uploading
                } else {
                    
                    print("YOU THERE ESSAY7?")
                    
                    // show the error message in AlertView
                    if json["message"] != nil {
                        let message = json["message"] as! String
                        
                        helper.showAlert(title: "JSON Error", message: message, from: self)
                    }
                }
                    
                }
                
            }
            catch
            {
            
            print("YOU THERE ESSAY8?")
            
            helper.showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
                //print(error)
            }
    }
    
    
    
    
    
    
})
    
    .resume()

}
*/


    
/*
     
 func fetchUserData(location: CLLocation) {
     
     guard let currentUid = Auth.auth().currentUser?.uid else { return }
     
     let parameters: [String:Any] = ["uid": currentUid]
     
    
             
             let url = "http://localhost/Dating_App2/login.php"
             
    // AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: [:]).responseJSON { response in
         
     AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).validate(statusCode: 200..<600).responseJSON { response in
     
                 
         print("delete here3 \(parameters) \(response)")
                 
                 switch response.result {
                     case .success(let dict):
                         
                         
                        
                     let successDict: [String: Any?] = dict as? [String: Any?] ?? [:]
                     
                     
                     let status = successDict["status"] as! String
                     let email = successDict["email"] as! String
                     let id =    successDict["id"] as! String
                     let firstName = successDict["firstName"] as! String
                     let uid = successDict["uid"] as! String
                     let phoneNumber = successDict["phoneNumber"] as! String
                     let birthday = successDict["birthday"] as! String
                     let gender = successDict["gender"] as! String
                     let Interested_In = successDict["Interested_In"] as! String
                     let Facebook_link = successDict["Facebook_link"] as! String
                         
                     let userModel = UserModel(status: status, uid: uid, email: email, firstName: firstName, phoneNumber: phoneNumber, birthday: birthday, gender: gender, Interested_In: Interested_In, Facebook_link: Facebook_link, id: id)
                     
                     print("the user model \(userModel)")
         
                     let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
                     
                    
                     geofire.setLocation(location, forKey: uid, withCompletionBlock: { (error) in
                         
                         print("strange that you don't make it here")
                         
                         if (error != nil) {
                             self.presentAlertController(withTitle: "Error", message: "\(error!.localizedDescription)")
                             
                             
                           } else {
                             
                           }
                         
                        
                        
                     })
                         
                        
                     case .failure(let error):
                         
                         
                         
                         print(error.localizedDescription)
                         //completion(nil, error.localizedDescription)
                 }
             }
     
     
     
 }
     
*/
