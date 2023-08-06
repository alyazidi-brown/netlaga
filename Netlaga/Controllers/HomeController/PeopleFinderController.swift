//
//  PeopleFinderController.swift
//  Netlaga
//
//  Created by Scott Brown on 09/06/2023.
//

import UIKit
import Foundation
import FirebaseAuth
import Firebase
import CoreLocation
import GeoFire
import Kingfisher
import Alamofire

protocol OriginalDelegate: AnyObject {
    
    func defaultSettings()
    
    
}


class PeopleFinderController: UIViewController, UITableViewDelegate, UITableViewDataSource, RejectDelegate, RequestDelegate {
    
    

    weak var delegate: OriginalDelegate?
    
    private let headerId = "headerId"
        private let footerId = "footerId"
        private let cellId = "PeopleFinderCell"
     var cardModels = [DiscoveryStruct]()
    
    var users = [NSDictionary]()
    
    var locationName : String = ""
    var locationAddress : String = ""
    
   

        lazy var tableView: UITableView = {

            let tv = UITableView(frame: .zero, style: .plain)
            tv.translatesAutoresizingMaskIntoConstraints = false
            tv.backgroundColor = .white
            tv.delegate = self
            tv.dataSource = self
            /*tv.register(CustomTableViewHeader.self, forHeaderFooterViewReuseIdentifier: self.headerId)
            tv.register(CustomTableViewFooter.self, forHeaderFooterViewReuseIdentifier: self.footerId)*/
            tv.register(PeopleFinderCell.self, forCellReuseIdentifier: self.cellId)
            return tv
        }()
    
    private let dismissButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
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
    
    var changeLocationButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Change Location", for: .normal)
        
        
        
        button.tintColor = UIColor.blue
        
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

       
        //
        // MARK :- CELL
        //
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if cardModels.count == 0 {
            self.tableView.setEmptyMessage("No cool people around here.... You can try another location.")
            } else {
            self.tableView.restore()
            }

            return self.cardModels.count
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return 150
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PeopleFinderCell
            
            cell.delegatereject = self
            
            cell.delegaterequest = self
            
            let model = cardModels[indexPath.row]
            
            cell.backgroundColor = .white//gray
            print ("person \(model.ava) \(model.firstName) \(model.place)")
            
            let imageUrl = URL(string: model.ava)
            
            cell.profileImageView.kf.setImage(with: imageUrl)
            
           
            //cell.profileImageView.kf.setImage(with: imageUrl)
            
            cell.nameLabel.text = model.firstName
            
            cell.jobTitleDetailedLabel.text = model.place
            
            cell.xButton.setImage(UIImage(named: "xcross")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            let image = UIImage(named: "tick")?.withRenderingMode(.alwaysOriginal)
            //cell.countryImageView.image = image
            cell.tickButton.setImage(image, for: .normal)
            
           // cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2
            
            //cell.profileImageView.clipsToBounds = true
            
            if indexPath.row == 0 {
                
                cell.isUserInteractionEnabled = true
                
                if let url = URL(string: model.ava) {
                    cell.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "user.png"))
                }
                
                /*
                AF.request(model.ava,method: .get).response{ response in

                   switch response.result {
                       
                       
                    case .success(let responseData):
                       
                       print("ava 3")
                       
                      // DispatchQueue.main.async {
                       cell.profileImageView.image = UIImage(data: responseData!, scale:0.25)
                       //}

                    case .failure(let error):
                       
                       cell.profileImageView.image = UIImage(named: "user.png")
                        print("error--->",error)
                    }
                }
                 */
                
                cell.nameLabel.isEnabled = true
                
                cell.countryImageView.isUserInteractionEnabled = true
                
                cell.countryImageView.isOpaque = false
                
                //cell.profileImageView.isUserInteractionEnabled = false
                
               // cell.profileImageView.isOpaque = true
                
                cell.jobTitleDetailedLabel.isEnabled = true
                
                cell.tickButton.isEnabled = true
                
                cell.xButton.isEnabled = true
                
            } else {
               
                cell.isUserInteractionEnabled = false
                
                if let url = URL(string: model.ava) {
                    
        
                    
                    KingfisherManager.shared.retrieveImage(with: url) { result in
                        let image = try? result.get().image
                        if let image = image {
                           
                            cell.profileImageView.image = image.noir
                            
                        } else {
                            
                            cell.profileImageView.image = UIImage(named: "user.png")?.noir
                            
                        }
                    }
                    
                }
                
                /*
                if let url = URL(string: model.ava) {
                    cell.profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "user.png"))
                }
                 */
                
                /*
                AF.request(model.ava,method: .get).response{ response in

                   switch response.result {
                       
                       
                    case .success(let responseData):
                       
                       print("ava 3")
                       
                       cell.profileImageView.image = UIImage(data: responseData!, scale:0.25)?.noir

                    case .failure(let error):
                       
                       cell.profileImageView.image = UIImage(named: "user.png")
                        print("error--->",error)
                    }
                }
                 */
                
                cell.nameLabel.isEnabled = false
                
                cell.countryImageView.isUserInteractionEnabled = false
                
                cell.countryImageView.isOpaque = true
                
                //cell.profileImageView.isUserInteractionEnabled = false
                
               // cell.profileImageView.isOpaque = true
                
                cell.jobTitleDetailedLabel.isEnabled = false
                
                cell.tickButton.isEnabled = false
                
                cell.xButton.isEnabled = false 
                
            }
            
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = cardModels[indexPath.row]
        
        let vc = ProfileController() //your view controller
        vc.person = model
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       let favouriteaction = UIContextualAction(style: .normal, title: "Add") { [weak self] (action, view, completionHandler) in
           self?.requestPerson()
          completionHandler(true)
       }
       favouriteaction.backgroundColor = .systemBlue
        
       
       return UISwipeActionsConfiguration(actions: [favouriteaction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
       let deleteaction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
          self?.rejectPerson()
          completionHandler(true)
       }
        deleteaction.backgroundColor = .red
       return UISwipeActionsConfiguration(actions: [deleteaction])
    }

        override func viewDidLoad() {
            super.viewDidLoad()

            //title = "TableView Demo"
            view.backgroundColor = .white
            view.addSubview(tableView)
            //view.addSubview(dismissButton)
            
            setupAutoLayout()
            
            
            checkLikes()
              
            
              
            downloadMatches()
            
            
            
        }
    
    func rejectPerson() {
        
        cardModels.remove(at: 0)
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        UIView.animate(
          withDuration: 0.2,
          animations: {
            self.tableView.deleteRows(at: [indexPath], with: .none)
          },
          completion: { _ in
            self.tableView.reloadData()
          })
    }
    
    func requestPerson() {
        
        let discoverySetUp = cardModels[0]
            
           checkForLikesWith(userId: discoverySetUp.uid)
           
        
    }

        func setupAutoLayout() {
            
            view.addSubview(changeLocationButton)
            
            changeLocationButton.translatesAutoresizingMaskIntoConstraints = false
            
            changeLocationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
            changeLocationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
            changeLocationButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
            changeLocationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            let changeLocationAction = UIAction { action in
                    
                    print("reaches the dismiss")
                /*
                self.dismiss(animated: false) {
                    let vc = HomeTabBarController()//your view controller
                    vc.modalPresentationStyle = .overFullScreen
                  self.present(vc, animated: true, completion: nil)
                }*/
                //self.dismiss(animated: false) {
                    
                    self.delegate?.defaultSettings()
                    
                //}
              
              }
            
            changeLocationButton.addAction(changeLocationAction, for: .touchUpInside)

            tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            tableView.topAnchor.constraint(equalTo: changeLocationButton.bottomAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true//(equalTo: view.bottomAnchor).isActive = true
            /*
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            dismissButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            dismissButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 5).isActive = true
            dismissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
             */
        }
    
    @objc func dismissAction() {
       
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - Download
 private func downloadMatches() {
        
    UserService.downloadUserMatches { (matchedUserIds) in
          
        }
    }

func friendNotification(title: String, body: String, topic: String) {
    
    
    
    let parameters: [String:Any] = ["title": title, "body": body, "topic": topic]
    
   
            
            let url = "https://us-central1-touchroad-543e4.cloudfunctions.net/notificationRequest"
            
    AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
              
                
                switch response.result {
                    case .success(let dict):
                        
                       
                        
                        print(dict)
                        let successDict: [String: Any?] = dict as? [String: Any?] ?? [:]
                        let body = successDict["body"] as? [String: Any?] ?? [:]
                        let success = body["success"] as? [String: Any?] ?? [:]
                       
                      
                        print("body results \(successDict) \(success)") //body\(body) success\(success)")
                        
                     
                        //completion(link, nil)
                    case .failure(let error):
                        
                        
                           
                            
                            self.presentAlertController(withTitle: "Error", message: "\(error.localizedDescription)")
                           
                        
                        print(error.localizedDescription)
                        //completion(nil, error.localizedDescription)
                }
            }
    }

private func showMatchView(userId: String) {
    
    let matchView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "matchView") as! MatchViewController
    
          
    matchView.userId = userId
    matchView.modalPresentationStyle = .fullScreen
   
    self.present(matchView, animated: true, completion: nil)
}

//Enter php friend request here
    private func checkForLikesWith(userId: String) {
    
    print("you here check userid \(userId) \(LikedObject.likedIdArray.contains(userId))")
           

    if LikedObject.likedIdArray.contains(userId) == false {
        
        friendRequest(status: "add", friend_id: userId, user_id: UserTwo.uid) { status in
            if status == "success" {
        
        
        LikedObject.likedIdArray.append(userId)
        LikedObject.dateArray.append(Timestamp(date: Date()))
        print("so you should enter here")
        
        UserService.saveUserToFireStore(to: LikedObject.likedIdArray, dates: LikedObject.dateArray)
                
        
                self.cardModels.remove(at: 0)
                
                let indexPath = IndexPath(item: 0, section: 0)
                
                UIView.animate(
                  withDuration: 0.2,
                  animations: {
                    self.tableView.deleteRows(at: [indexPath], with: .none)
                  },
                  completion: { _ in
                    self.tableView.reloadData()
                  })
                
            }
        
        }
        
    }
    
    //fetch likes
    UserService.checkIfUserLikedUs(userId: userId) { (didLike) in
        
        print("did like \(didLike)")
        if didLike {
            
            UserService.deleteFromLikedList(userId: userId) { matchedUserIds in
                
                //self.friendRequest(status: "reject", friend_id: userId, user_id: User.uid) { status in
                //self.friendRequest(status: "reject", friend_id: User.uid, user_id: userId) { status in
                   // if status == "success" {
             
                UserService.saveMatch(userId: userId) {
                    
                    /*self.friendRequest(status: "confirm", friend_id: userId, user_id: UserTwo.uid) { status in
                        
                        
                        if status == "success" {*/
                        
                        self.showMatchView(userId: userId)
                       
                    /*
                        }
                        
                        
                    }*/
                    
                    
                    
                }
            
          
            
            }

        }
    }
        
    
     
}

func checkLikes() {
  
    UserService.downloadCurrentUserLikedListFromFirebase{ (likedArray) in
        
        print("checking discovery data?")
        self.discoveryData()
        
    }
    
}

func didLikeUserWith(userId: String) -> Bool {
    
    print("user id \(userId) \(LikedObject.likedIdArray.contains(userId))")
    
    return LikedObject.likedIdArray.contains(userId) ?? false//FUser.currentUser()?.likedIdArray?.contains(userId) ?? false
}

func friendRequest(status: String, friend_id: String, user_id: String, completion: @escaping(String) -> Void) {
    
    let url:URL = URL(string: "https://netlaga.net/friends.php")!
    let session = URLSession.shared
    
    let request = NSMutableURLRequest(url: url)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    

    
    let paramString: String = "action=\(status)&user_id=\(user_id)&friend_id=\(friend_id)"
    
   
        
      print("paramString \(paramString) & status  \(status)")
    
    
    request.httpBody = paramString.data(using: String.Encoding.utf8)
    
    print("paramString2 \(paramString)")
    
    
    //STEP 2.  Execute created above request.
    let task = session.dataTask(with: request as URLRequest, completionHandler: {
        (data, response, error) in
        
        print("paramString3 \(paramString)")
        
        guard let _:Data = data, let _:URLResponse = response  , error == nil
            
            else {
                //print("error")
                if error != nil {
                    self.presentAlertController(withTitle: "Error", message: error!.localizedDescription)
                    
                }
                return
        }
        
        let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("YOU THERE ESSAY3? \(dataString)")
        
        DispatchQueue.main.async
            {
            print("YOU THERE ESSAY4? ")
                
                
                do {
                    
                 
                 
                    print("YOU THERE ESSAY13? ")
                    
                    let datadata = dataString!.data(using: String.Encoding.utf8.rawValue)
                    
                    if let json = try JSONSerialization.jsonObject(with: datadata!, options: []) as? [String : Any] {

                   
                    print("YOU THERE ESSAY14? ")

                    
                    // uploaded successfully
                    if json["status"] as! String == "200" {
                        
                        completion("success")
                        
                        print("YOU THERE ESSAY6? \(dataString) \(status)")
                        /*
                        if status == "add" {
                        
                       // self.presentAlertController(withTitle: "Success!", message: "Your friend request has been sent successfully.")
                            
                        } else {
                            
                            //self.presentAlertController(withTitle: "Success!", message: "Your friend request has been successfully cancelled.")
                        }
                      */
                        
                    // error while uploading
                    } else {
                        
                        completion("fail")
                        
                        print("YOU THERE ESSAY7?")
                        
                        // show the error message in AlertView
                        if json["message"] != nil {
                            let message = json["message"] as! String
                            
                            self.presentAlertController(withTitle: "JSON Error", message: message)
                            
                          
                        }
                    }
                        
                    }
                    
                }
                catch
                {
                
                completion("fail")
                
                self.presentAlertController(withTitle: "JSON Error", message: error.localizedDescription)
                
               
                    
                }
        }
      
        
    })
        
        .resume()
    
}


    // searchUsers
func searchUsers(uid: String, name: String) {
        
        let url:URL = URL(string: "https://netlaga.net/friends.php")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
    
        
        let paramString: String = "action=search&id=\(uid)&name=\(name)&limit=15&offset=1"
        
       
            
          print("paramString \(paramString)")
        
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        print("paramString2 \(paramString)")
        
        
        //STEP 2.  Execute created above request.
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            print("paramString3 \(paramString)")
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil
                
                else {
                    //print("error")
                    if error != nil {
                        self.presentAlertController(withTitle: "Error", message: error!.localizedDescription)
                        
                    }
                    return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("YOU THERE ESSAY6? \(dataString)")
            
            DispatchQueue.main.async
                {
                print("YOU THERE ESSAY4? ")
                    
                    
                    do {
                        
                     
                     
                        print("YOU THERE ESSAY13? ")
                        
                        let datadata = dataString!.data(using: String.Encoding.utf8.rawValue)
                        
                        if let json = try JSONSerialization.jsonObject(with: datadata!, options: []) as? [String : Any] {

                       
                        print("YOU THERE ESSAY14? ")

                        
                        // uploaded successfully
                        if json["status"] as! String == "200" {
                            
                            print("YOU THERE ESSAY6? \(dataString)")
                            
                            
                                // safe mode of accessing json
                                guard let users = json["users"] as? [NSDictionary] else {
                                   
                                    return
                                }
                                
                                // save accessed json (users) in our array
                                self.users = users
                                //self.presentAlertController(withTitle: "Success!", message: "Your friend request has been successfully cancelled.")
                            
                            
                            
                        // error while uploading
                        } else {
                            
                            print("YOU THERE ESSAY7?")
                            
                            // show the error message in AlertView
                            if json["message"] != nil {
                                let message = json["message"] as! String
                                
                                self.presentAlertController(withTitle: "JSON Error", message: message)
                                
                              
                            }
                        }
                            
                        }
                        
                    }
                    catch
                    {
                    
                    self.presentAlertController(withTitle: "JSON Error", message: error.localizedDescription)
                    
                   
                        
                    }
            }
          
            
        })
            
            .resume()
    }




func locationSaver() {
 
    DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
        
        var refreshAlert = UIAlertController(title: "We want to know where is popping!", message: "Can we save this location?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Ok logic here")
            
            self.saveLocation()
            
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
            
            
          }))

        self.present(refreshAlert, animated: true, completion: nil)
        
        
        print("Timer fired!")
        
        
    }

    
    
}

func saveLocation() {
    
    let url:URL = URL(string: "https://netlaga.net/locationEntry.php")!
    let session = URLSession.shared
    
    let request = NSMutableURLRequest(url: url)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    
    
    
    let paramString: String = "locationName=\(locationName)&locationAddress=\(locationAddress)"
        
      print("paramString \(paramString)")
    
    
    request.httpBody = paramString.data(using: String.Encoding.utf8)
    
    print("paramString2 \(paramString)")
    
    
    //STEP 2.  Execute created above request.
    let task = session.dataTask(with: request as URLRequest, completionHandler: {
        (data, response, error) in
        
        print("paramString3 \(paramString)")
        
        guard let _:Data = data, let _:URLResponse = response  , error == nil
            
            else {
                //print("error")
                if error != nil {
                    self.presentAlertController(withTitle: "Error", message: error!.localizedDescription)
                    
                }
                return
        }
        
        let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("YOU THERE ESSAY3? \(dataString)")
        
        DispatchQueue.main.async
            {
            print("YOU THERE ESSAY4? ")
                
                
                do {
                    
                 
                 
                    print("YOU THERE ESSAY13? ")
                    
                    let datadata = dataString!.data(using: String.Encoding.utf8.rawValue)
                    
                    if let json = try JSONSerialization.jsonObject(with: datadata!, options: []) as? [String : Any] {

                   
                    print("YOU THERE ESSAY14? ")

                    
                    // uploaded successfully
                    if json["status"] as! String == "200" {
                        
                        print("YOU THERE ESSAY6? \(dataString)")
                        
                        self.presentAlertController(withTitle: "Thanks!", message: "Survey contribution successful.")
                        
                        
                    // error while uploading
                    } else {
                        
                        print("YOU THERE ESSAY7?")
                        
                        // show the error message in AlertView
                        if json["message"] != nil {
                            let message = json["message"] as! String
                            
                            self.presentAlertController(withTitle: "JSON Error", message: message)
                            
                          
                        }
                    }
                        
                    }
                    
                }
                catch
                {
                
                self.presentAlertController(withTitle: "JSON Error", message: error.localizedDescription)
                
               
                    
                }
        }
      
        
    })
        
        .resume()
    
    
    
}

    
    func discoveryData() {
        
        print("you here")
        
          
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
         
        
        fetchDrivers(location: UserTwo.location) { (driver) in
        
                   
                 let firstName = driver.firstName
                     
                 let email = driver.email
                     
                 let uid = driver.uid
                     
                 let ava = driver.ava
                 
                 let place = driver.place
            
                let token = driver.token
                 
                 print("here is driver stuff \(driver) \(place) \(uid) \(currentUid)")
                 
                 
                 if currentUid != uid {//&& place == User.place {
                     
                     let discovery = DiscoveryStruct(firstName: firstName, email: email, ava: ava, uid: uid, place: place, token: token)
                     
                     print("you should be empty at some point\(self.cardModels) \(uid) \(LikedObject.likedIdArray)")
                     
                     if  self.cardModels.contains(where: { $0.uid == uid }) || LikedObject.likedIdArray.contains(uid) {
                         
                         
                     } else {
                
                  self.cardModels.append(discovery)
                         
                     }
                     
                     print("discovery array \(discovery) \(self.cardModels)")
                     
                 DispatchQueue.main.async {

                 self.tableView.reloadData()
                                     
                                     
                                         
                 }
                 
                 } else {
                     
                     
                     
                 }
                 
                 
             }
        
        
     
        
                     print("now I go here")
        
     }
    
    func fetchDrivers(location: CLLocation, completion: @escaping(UserFirebase) -> Void) {
        
        
        let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
        
        print("first section")
        
        REF_USER_LOCATIONS.observe(.value) { (snapshot) in
            
            print("what's in the array \(self.cardModels)")
            
            self.cardModels.removeAll()
            
            print("what's in the array 2\(self.cardModels)")
            
            print("second section \(location) \(snapshot)")
           
            
          geofire.query(at: location, withRadius: 5).observe(.keyEntered, with: { (uid, location) in
                
           
                print("third section \((uid, location))")
       
              if self.distanceCalculator(location: location) <= 15.0 {
                
                    self.fetchUserData(uid: uid, completion: { (user) in
                    
                    print("fourth section \(user)")
                    let driver = user
                   
                    
                    completion(driver)
                })
                    
                }
                
                 
                
                print("fifth section")
            })
            
            print("sixth section")
        }
        
        print("seventh section")
    }
    
    func fetchUserData(uid: String, completion: @escaping(UserFirebase) -> Void) {
        
      
       
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            let full = snapshot.children.allObjects
            
            print("full \(full)")
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            print("uid stuff \(uid) snap \(snapshot) dictionary \(dictionary)")
            let user = UserFirebase(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func distanceCalculator(location: CLLocation) -> Double {
        
            //My location
        let myLocation = UserTwo.location//CLLocation(latitude: 59.244696, longitude: 17.813868)

            //My buddy's location
            let myBuddysLocation = location//CLLocation(latitude: 59.326354, longitude: 18.072310)

            //Measuring my distance to my buddy's (in km)
        let distance = myLocation.distance(from: myBuddysLocation)//myLocation.distance(from: myBuddysLocation) / 1000

            //Display the result in km
            //print(String(format: "The distance to my buddy is %.01fkm", distance))
        
            //Display the result in m
            print("The distance to my buddy is \(distance)m")
        
        return distance
    }
    
    

}

extension UIImage {
    /*
    var grayed: (CIColor) -> UIImage {
        {
            guard let ciImage = CIImage(image: self) else { return self }
            let filterParameters = [ kCIInputColorKey: $0, kCIInputIntensityKey: 1.0 ] as [String: Any]
            let grayscale = ciImage.applyingFilter("CIColorMonochrome", parameters: filterParameters)
            return UIImage(ciImage: grayscale)
        }
    }
     */

    var withGrayscale: UIImage {
            guard let ciImage = CIImage(image: self, options: nil) else { return self }
        let paramsColor: [String: AnyObject] = [kCIInputBrightnessKey: NSNumber(value: 0.0), kCIInputContrastKey: NSNumber(value: 0.5), kCIInputSaturationKey: NSNumber(value: 0.0)]
            let grayscale = ciImage.applyingFilter("CIColorControls", parameters: paramsColor)
            guard let processedCGImage = CIContext().createCGImage(grayscale, from: grayscale.extent) else { return self }
            return UIImage(cgImage: processedCGImage, scale: scale, orientation: imageOrientation)
        }
    
    func grayscaled(brightness: Double = 0.0, contrast: Double = 1.0) -> UIImage? {
        guard let ciImage = CoreImage.CIImage(image: self, options: nil) else { return nil }
        let paramsColor: [String : AnyObject] = [ kCIInputBrightnessKey: NSNumber(value: brightness),
                                                  kCIInputContrastKey:   NSNumber(value: contrast),
                                                  kCIInputSaturationKey: NSNumber(value: 0.0) ]
        let grayscale = ciImage.applyingFilter("CIColorControls", parameters: paramsColor)
        
        guard let processedCGImage = CIContext().createCGImage(grayscale, from: grayscale.extent) else { return nil }
        return UIImage(cgImage: processedCGImage, scale: self.scale, orientation: self.imageOrientation)
    }
    
    var noir: UIImage? {
            let context = CIContext(options: nil)
            guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
            currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
            if let output = currentFilter.outputImage,
                let cgImage = context.createCGImage(output, from: output.extent) {
                return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
            }
            return nil
        }
}
