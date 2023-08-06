//
//  HomeViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/29/22.
//https://stackoverflow.com/questions/41154784/how-to-resize-uiimageview-based-on-uiimages-size-ratio-in-swift-3

import Foundation
import UIKit
import Firebase
import GeoFire
import CoreLocation
import Alamofire
import FirebaseAuth
import FirebaseFirestore
import Kingfisher
import Photos


class HomeViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
   
    var dataFetched: Bool = false
    
    
    var manager: CLLocationManager? = nil
    
    
    private let profileImageButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "user.png"), for: .normal)
        
        button.addTarget(self, action: #selector(profileSelection), for: .touchUpInside)
        
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
    
    let profilePhotoImageView: UIImageView = {
     
        let imageView = UIImageView()
        
        
        if #available(iOS 13.0, *) {
            imageView.image = UIImage(named: "user.png")
        }else{
            let image = UIImage(named: "user.png")?.withRenderingMode(.alwaysTemplate)
            imageView.image = image
            imageView.tintColor = UIColor.white
        }
        
            return imageView
    }()
    
    
    private let firstnameLabel: UILabel = {
        let label = UILabel()
        label.text = "firstname"
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age"
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.text = "likes"
        label.font = UIFont(name: "Avenir-Light", size: 14)
        label.textColor = .red
        return label
    }()
    
    private let interestsLabel: UILabel = {
        let label = UILabel()
        //label.text = "likes"
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
    
    var interestsArray : [InterestsStruct] = []
    
    var myCollectionView:UICollectionView?
    
    let imagePickerController = UIImagePickerController()
    
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
        
        imagePickerController.delegate = self
        
        configureUI()
        
        findMe()
        
        celebrityTest()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.size.width / 2
    }
    
    @objc func profileSelection() {
        
        print("profile button selected")
        
        let alert = UIAlertController(title: "Profile Picture", message: "Would you like to change your profile picture?", preferredStyle: UIAlertController.Style.alert)

      
        
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            
             self.ImageAction()
             
            }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))
         

        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func ImageAction() {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            
            self.openCameraButton()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func openCameraButton() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera;
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have image access", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            var newImage = self.imageOrientation(imagePicked)
            
            uploadImage(id: UserTwo.id, imageChosen: newImage)
            
        }
        
        picker.dismiss(animated: true) {
            
            
            print("Picker Dismissed...")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imageOrientation(_ src:UIImage)->UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        }

        switch src.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        }

        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        ctx.concatenate(transform)

        switch src.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }

        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)

        return img
    }
    
    func uploadImage(id: String, imageChosen: UIImage) {
            
            var imageViewTapped = "ava"
            
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
        
        UserTwo.avaImgData = imageChosen.jpegData(compressionQuality: 0.8)!
        
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
                            
                            print("But I get the token here? \(token)")
                            
                            let values = ["email": UserTwo.email, "firstName": UserTwo.firstName, "ava": UserTwo.ava, "token": token]
                            
                            Database.database(url: "https://datingapp-80400-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("users").child(UserTwo.uid).updateChildValues(values) { [self] error, ref in
                            
                            //Database.database().reference().child("users").child(uid).updateChildValues(values) { error, ref in
                                
                                print("and here")
                                
                                if let error = error {
                                    
                                    print("firebase error here \(error.localizedDescription)")
                                        return
                                      }
                                
                                self.profileImageButton.setImage(imageOrientation(imageChosen), for: .normal)
                                
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
    
    func generateCurrentTimeStamp () -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
            return (formatter.string(from: Date()) as NSString) as String
        }

    
    @objc func signOut() {
        print("not signing out?")
        do {
            try Auth.auth().signOut()
            print("not signing out2?")
            presentLoginController()
        } catch {
            print("not signing out3?")
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
    
    func celebrityTest() {
        
        print ("celebrity here")
        let name = "Michael Jordan".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://api.api-ninjas.com/v1/celebrity?name="+name!)!
        var request = URLRequest(url: url)
        request.setValue("0jSyFoBCDR+TdjxVC0UgMA==WIgk2B2ltNdrEGWB", forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
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
                            let Interests = json["Interests"] as! String
                            let Facebook_link = json["Facebook_link"] as! String
                            let ava = json["ava"] as! String
                            
                            UserTwo.uid = uid
                            UserTwo.email = email
                            UserTwo.firstName = firstName
                            UserTwo.ava = ava
                            UserTwo.id = id
                            
                            
                            print("interests here \(Interested_In)")
                            
                            let userModel = UserModel(status: status, uid: uid, email: email, firstName: firstName, phoneNumber: phoneNumber, birthday: birthday, gender: gender, Interested_In: Interested_In, Facebook_link: Facebook_link, id: id, ava: ava)
                            
                            let str = Interests
                            let replaced = str.replacingOccurrences(of: ";", with: ", ")
                            var myArr1 = str.components(separatedBy: ";")
                            
                            
                            self.populateUI(ava: ava, firstName: firstName, interests: replaced, birthDate: birthday, interestsArr: myArr1)
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
        
        if dataFetched == false {
            
            dataFetched = true
            
            fetchUserData(location: myLocation3)
            
        }
        
        
        
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
    
    
    
    func downloadImage(urlString : String , imageCompletionHandler: @escaping (UIImage?) -> Void){
            guard let url = URL.init(string: urlString) else {
                return  imageCompletionHandler(nil)
            }
            let resource = ImageResource(downloadURL: url)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    imageCompletionHandler(value.image)
                case .failure:
                    imageCompletionHandler(nil)
                }
            }
        }
    
    
    ////UI configuration
    func populateUI(ava: String, firstName: String, interests: String, birthDate: String, interestsArr: [String]) {
        
       
        let imageUrl = URL(string: ava)
        
        print("ava image \(ava)")
        //profilePhotoImageView.kf.setImage(with: imageUrl)
        /*
        downloadImage(urlString : ava){image in
             guard let image  = image else { return}
            
            //let newImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .down)
            
            var newImage = UIImage()
            
            let orientation = image.imageOrientation
            
            print("image orientation \(orientation)")
            if orientation.rawValue != 0 {
                
                print("where do you go \(orientation)")
             
            newImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .up)
                
            } else {
               
                print("where do you go 2 \(orientation)")
                
                newImage = image
                
            }
            
            //DispatchQueue.main.async {
                
                //self.profilePhotoImageView.image = newImage
                self.profileImageButton.setImage(newImage, for: .normal)
                
            //}
              // do what you need with the returned image.
         }
         */
        /*
        AF.request(ava,method: .get).response{ response in

           switch response.result {
            case .success(let responseData):
               
               DispatchQueue.main.async {
                   self.profileImageButton.setImage(UIImage(data: responseData!, scale:1), for: .normal)
               }

            case .failure(let error):
                print("error--->",error)
            }
        }
         */
        
        let modifier = AnyImageModifier { return $0.withRenderingMode(.alwaysOriginal) }
        
        if let url = URL(string: ava) {
            
            
            self.profileImageButton.kf.setImage(with: url, for: .normal, placeholder: UIImage(named: "user.png"), options: [.imageModifier(modifier)], progressBlock: nil, completionHandler: nil)
            
        }
        
        firstnameLabel.text = firstName
        
        interestsLabel.text = interests
        
        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        dateFormatter.dateFormat = "dd-MM-yy"
        //dateFormater.dateStyle = .long

        let startDate = dateFormatter.date(from: birthDate)!
        
        let toDate = Date()
        
        let delta = Calendar.current.dateComponents([.year], from: startDate, to: toDate).year//toDate.timeIntervalSince(startDate)
        
        if delta != nil {
            
            ageLabel.text = "\(delta!)"
            
        } else {
            
            ageLabel.text = "Age Unavailable"
        }
        
        print("here are the array of interests \(interestsArr)")
        
        for interest in interestsArr {
            
            let interestModel = InterestsStruct(interest: interest)
            
            self.interestsArray.append(interestModel)
        }
        
        DispatchQueue.main.async {
            self.myCollectionView?.reloadData()
            
        }
        
    }
    
    func configureUI() {
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        /*
        profilePhotoImageView.frame = CGRect(x: (view.frame.width/2) - 50, y: 50, width: 100, height: 100)
        profilePhotoImageView.layer.borderWidth = 1
        profilePhotoImageView.layer.masksToBounds = false
        profilePhotoImageView.layer.borderColor = UIColor.blue.cgColor
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.height/2
        profilePhotoImageView.clipsToBounds = true
        
        view.addSubview(profilePhotoImageView)
         */

        /*
        profilePhotoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profilePhotoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profilePhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
         */
        
        view.addSubview(profileImageButton)
        profileImageButton.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 400)
        
        view.addSubview(firstnameLabel)
        firstnameLabel.anchor(top: profileImageButton.bottomAnchor, paddingTop: 10, width: 250, height: 50)
        
        firstnameLabel.centerX(inView: view)
        
        view.addSubview(ageLabel)
        ageLabel.anchor(top: firstnameLabel.bottomAnchor, paddingTop: 10, width: 250, height: 50)
        
        ageLabel.centerX(inView: view)
        
        /*
        view.addSubview(likesLabel)
        likesLabel.anchor(top: ageLabel.bottomAnchor, left: view.leftAnchor,  paddingTop: 50, paddingLeft: 20, width: 250, height: 50)
         
        
        view.addSubview(interestsLabel)
        interestsLabel.anchor(top: ageLabel.bottomAnchor, left: view.leftAnchor,  paddingTop: 10, paddingLeft: 20, width: 250, height: 50)
         */
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        myCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSizeMake(100, 50)
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        myCollectionView?.register(InterestsCell.self, forCellWithReuseIdentifier: "InterestsCell")
        
        myCollectionView?.backgroundColor = UIColor.white
        view.addSubview(myCollectionView ?? UICollectionView())
        
        myCollectionView?.anchor(top: ageLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingRight: 0, height: 70)
        
        view.addSubview(logoutButtonAuthButton)
        logoutButtonAuthButton.anchor(top: myCollectionView?.bottomAnchor, left: view.leftAnchor,  paddingTop: 30, paddingLeft: 20, width: 250, height: 50)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interestsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView?.dequeueReusableCell(withReuseIdentifier: "InterestsCell", for: indexPath as IndexPath) as! InterestsCell
        
        let interestModel = interestsArray[indexPath.row]
        
        cell.interestLabel.text = interestModel.interest
        
        cell.interestLabel.backgroundColor = UIColor(red:255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1.0)
        
        /*
        cell.interestLabel.layer.masksToBounds = true
        cell.interestLabel.layer.cornerRadius = 6
        cell.interestLabel.layer.borderWidth = 2
         */
        
        cell.interestLabel.layer.cornerRadius = cell.interestLabel.frame.height/2
        cell.interestLabel.clipsToBounds = true
        
        return cell
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

extension UIImageView {
    func roundedImage() {
        self.layer.cornerRadius = (self.frame.size.width) / 2;
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.white.cgColor
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
