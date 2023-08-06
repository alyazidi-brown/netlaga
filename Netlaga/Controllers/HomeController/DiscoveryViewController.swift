//
//  DiscoveryViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 9/12/22.
//

import UIKit
import Kingfisher
import FirebaseAuth
import GeoFire
import MapKit
import CoreLocation
import Alamofire




class DiscoveryViewController: UITableViewController, CLLocationManagerDelegate, friendDelegate {
    
    
    var users = [NSDictionary]()
    
    var locationName : String = ""
    var locationAddress : String = ""
    
    //var discoveryArray : [DiscoveryStruct] = []
    static let shared = DiscoveryViewController()
    
    var userMessageObject = UserMessageObject()
    
    var discoveryArray = [DiscoveryStruct]()
    
    var newPostsQuery = GFCircleQuery()
    
    //var locationManager: CLLocationManager? = nil
    var locationManager : CLLocationManager = CLLocationManager()
    //internal let refreshControl = UIRefreshControl()
    
    let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)

override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(TableCell.self, forCellReuseIdentifier: "cell")
    
    tableView.delaysContentTouches = false
    
    //tableview cell selection disabled
    //tableView.allowsSelection = false
    
    self.locationManager.requestAlwaysAuthorization()
      self.locationManager.delegate = self
    
    discoveryData()
    
    listRequests()
    
   // searchUsers()
    
    if #available(iOS 10.0, *) {
        tableView.refreshControl = refreshControl
    } else {
        tableView.addSubview(refreshControl!)
    }
   
    
}
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationSaver()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    if discoveryArray.count == 0 {
    self.tableView.setEmptyMessage("No cool places around here.")//("No cool people around here.... Don't worry check Feature tab to match you with someone cool.")
    } else {
    self.tableView.restore()
    }

    return discoveryArray.count

}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell
        
        cell.delegateFriend = self
        
       // cell.selectionStyle = .none
        
        cell.contentView.addSubview(cell.profilePhotoImageView)
        cell.contentView.addSubview(cell.nameLabel)
        cell.contentView.addSubview(cell.locationLabel)
        cell.contentView.addSubview(cell.friendButton)
        
        cell.profilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            cell.profilePhotoImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            cell.profilePhotoImageView.heightAnchor.constraint(equalToConstant: 50),
            cell.profilePhotoImageView.widthAnchor.constraint(equalToConstant: 50),
            cell.profilePhotoImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20)
            
            
            ])
        
        cell.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            cell.nameLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
            cell.nameLabel.heightAnchor.constraint(equalToConstant: 50),
            cell.nameLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -100),
            cell.nameLabel.leadingAnchor.constraint(equalTo: cell.profilePhotoImageView.trailingAnchor, constant: 20)
            
            
            ])
        
        cell.locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            cell.locationLabel.topAnchor.constraint(equalTo: cell.nameLabel.bottomAnchor, constant: 0),
            cell.locationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0),
            cell.locationLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -100),
            cell.locationLabel.leadingAnchor.constraint(equalTo: cell.profilePhotoImageView.trailingAnchor, constant: 20)
            
            
            ])
         
         
        cell.friendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            cell.friendButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            cell.friendButton.heightAnchor.constraint(equalToConstant: 50),
            cell.friendButton.widthAnchor.constraint(equalToConstant: 50),
            cell.friendButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20)
            
            
            ])
        
        
            
        cell.contentView.isUserInteractionEnabled = true
         
         
        
    let discoverySetUp = discoveryArray[indexPath.row]
        
        
        let imageUrl = URL(string: discoverySetUp.ava)
        
        
        
        
        cell.profilePhotoImageView.kf.setImage(with: imageUrl)
        
        
        cell.friend_id = discoverySetUp.uid
        
        
        cell.profilePhotoImageView.tag = indexPath.row
        
        cell.profilePhotoImageView.layer.cornerRadius = cell.profilePhotoImageView.frame.size.width/2
        
        cell.profilePhotoImageView.layer.masksToBounds = true
        
        cell.profilePhotoImageView.clipsToBounds = true
        
        cell.friendButton.isUserInteractionEnabled = true
        
        
    cell.nameLabel.text = discoverySetUp.firstName//"TableViewCell programtically"
    cell.nameLabel.textAlignment = .center
    cell.nameLabel.textColor  = .black
        
    cell.locationLabel.text = discoverySetUp.place
    cell.nameLabel.textAlignment = .center
    cell.nameLabel.textColor  = .red
        
    return cell
}
    

    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = .lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = .orange
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = .blue
        
        return [share, favorite, more]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
}
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let discoverySetUp = discoveryArray[indexPath.row]
        
        //deleteMessages(discoveryStruct: discoverySetUp)
        
        deleteImage(discoveryStruct: discoverySetUp)
    
        //navigationController?.pushViewController(vc, animated: true)
        
        //delegate?.controller(self, wantsToStartChatWith: discoverySetUp)
    }
    
    func deleteMessages(discoveryStruct: DiscoveryStruct) {
       
   
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        
        let parameters: [String:Any] = ["userId": currentUid, "messengerId": discoveryStruct.uid]
        
                let url = "https://us-central1-datingapp-80400.cloudfunctions.net/scrape"
                
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
                    
            
                    
                    switch response.result {
                        case .success(let dict):
                            
                       
                        let successDict: [String: Any?] = dict as? [String: Any?] ?? [:]
                        
                        var refreshAlert = UIAlertController(title: "Chat", message: "Would you like to chat with this user?", preferredStyle: UIAlertController.Style.alert)

                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                          
                            
                            let vc = ChatViewController(recipientId: discoveryStruct.uid, recipientName: discoveryStruct.firstName)//ChatController(discoverySetUp: matchInfo) //your view controller
                            vc.discoverySetUp = discoveryStruct
                            //let navController = UINavigationController(rootViewController: vc)
                            //self.present(navController, animated:true, completion: nil)
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true, completion: nil)
                            
                          }))

                        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                          print("Handle Cancel Logic here")
                            
                            
                          }))

                        self.present(refreshAlert, animated: true, completion: nil)
                           
                        case .failure(let error):
                        print("delete here5 \(error.localizedDescription)")
                           
                            print(error.localizedDescription)
                            //completion(nil, error.localizedDescription)
                    }
                }
        
        
    }
    
    func deleteImage(discoveryStruct: DiscoveryStruct) {
       
      
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        
        let parameters: [String:Any] = ["userId": currentUid, "messengerId": discoveryStruct.uid]
        
       
                
                let url = "https://us-central1-datingapp-80400.cloudfunctions.net/deleteImage"
                
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
                    
            print("delete here3 \(parameters) \(response)")
                    
                    switch response.result {
                        case .success(let dict):
                            
                            
                           
                            let successDict: [String: Any?] = dict as? [String: Any?] ?? [:]
                            
                         
                           
                        case .failure(let error):
                            
                           
                        self.presentAlertController(withTitle: "Error", message: error.localizedDescription)
                            print(error.localizedDescription)
                            //completion(nil, error.localizedDescription)
                    }
                }
        
        
    }
     
    
    
    func friendRequest(status: String, friend_id: String) {
        
        let url:URL = URL(string: "https://netlaga.net/friends.php")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
    
        
        let paramString: String = "action=\(status)&user_id=\(UserTwo.uid)&friend_id=\(friend_id)"
        
       
        
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        print("paramString2 \(paramString)")
        
        
        //STEP 2.  Execute created above request.
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil
                
                else {
                    //print("error")
                    if error != nil {
                        self.presentAlertController(withTitle: "Error", message: error!.localizedDescription)
                        
                    }
                    return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            
            DispatchQueue.main.async
                {
               
                    
                    
                    do {
                        
                     
                     
                      
                        
                        let datadata = dataString!.data(using: String.Encoding.utf8.rawValue)
                        
                        if let json = try JSONSerialization.jsonObject(with: datadata!, options: []) as? [String : Any] {

                       
                      

                        
                        // uploaded successfully
                        if json["status"] as! String == "200" {
                            
                         
                            
                            if status == "add" {
                            
                            self.presentAlertController(withTitle: "Success!", message: "Your friend request has been sent successfully.")
                                
                            } else {
                                
                                self.presentAlertController(withTitle: "Success!", message: "Your friend request has been successfully cancelled.")
                            }
                            
                            
                        // error while uploading
                        } else {
                            
                         
                            
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
            
           
            
            
            //STEP 2.  Execute created above request.
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
               
                
                guard let _:Data = data, let _:URLResponse = response  , error == nil
                    
                    else {
                        //print("error")
                        if error != nil {
                            self.presentAlertController(withTitle: "Error", message: error!.localizedDescription)
                            
                        }
                        return
                }
                
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                
                DispatchQueue.main.async
                    {
                    
                        
                        
                        do {
                            
                         
                         
                            
                            
                            let datadata = dataString!.data(using: String.Encoding.utf8.rawValue)
                            
                            if let json = try JSONSerialization.jsonObject(with: datadata!, options: []) as? [String : Any] {

                           
                           

                            
                            // uploaded successfully
                            if json["status"] as! String == "200" {
                                
                                
                                
                                
                                    // safe mode of accessing json
                                    guard let users = json["users"] as? [NSDictionary] else {
                                       
                                        return
                                    }
                                    
                                    // save accessed json (users) in our array
                                    self.users = users
                                    //self.presentAlertController(withTitle: "Success!", message: "Your friend request has been successfully cancelled.")
                                
                                
                                
                            // error while uploading
                            } else {
                                
                               
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
    
    func listRequests() {
            
            let url:URL = URL(string: "https://netlaga.net/friends.php")!
            let session = URLSession.shared
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
        
            
            let paramString: String = "action=listRequests&user_id=\(UserTwo.uid)"
            
           
         
            
            
            request.httpBody = paramString.data(using: String.Encoding.utf8)
            
            print("paramString2 \(paramString)")
            
            
            //STEP 2.  Execute created above request.
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
               
                guard let _:Data = data, let _:URLResponse = response  , error == nil
                    
                    else {
                        //print("error")
                        if error != nil {
                            
                            self.presentAlertController(withTitle: "Error", message: error!.localizedDescription)
                        }
                        return
                }
                
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
              
                
                DispatchQueue.main.async
                    {
                    
                        
                        
                        do {
                            
                         
                         
                           
                            
                            let datadata = dataString!.data(using: String.Encoding.utf8.rawValue)
                            
                            if let json = try JSONSerialization.jsonObject(with: datadata!, options: []) as? [String : Any] {

                           
                            
                            // uploaded successfully
                            if json["status"] as! String == "200" {
                                
                             
                                
                                
                                    // safe mode of accessing json
                                    guard let users = json["users"] as? [NSDictionary] else {
                                       
                                        return
                                    }
                                    
                                    // save accessed json (users) in our array
                                    self.users = users
                                    //self.presentAlertController(withTitle: "Success!", message: "Your friend request has been successfully cancelled.")
                                
                                
                                
                            // error while uploading
                            } else {
                                
                               
                                
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
            
         
        
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        print("paramString2 \(paramString)")
        
        
        //STEP 2.  Execute created above request.
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
           
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil
                
                else {
                    //print("error")
                    if error != nil {
                        self.presentAlertController(withTitle: "Error", message: error!.localizedDescription)
                        
                    }
                    return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            
            DispatchQueue.main.async
                {
               
                    
                    
                    do {
                        
                        
                        let datadata = dataString!.data(using: String.Encoding.utf8.rawValue)
                        
                        if let json = try JSONSerialization.jsonObject(with: datadata!, options: []) as? [String : Any] {

                     
                        // uploaded successfully
                        if json["status"] as! String == "200" {
                            
                           
                            self.presentAlertController(withTitle: "Thanks!", message: "Survey contribution successful.")
                            
                            
                        // error while uploading
                        } else {
                            
                         
                            
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
                     
                     print("you should be empty at some point\(self.discoveryArray)")
                     
                
                     
                     if  self.discoveryArray.contains{ $0.uid == uid } {
                         
                         
                     } else {
                
                     
                 self.discoveryArray.append(discovery)
                         
                     }
                     
                     print("discovery array \(discovery) \(self.discoveryArray)")
                     
                 DispatchQueue.main.async {

                 self.tableView.reloadData()
                                     
                                     
                                         
                 }
                 
                 } else {
                     
                     
                     
                 }
                 
                 
             }
        
        
     
        
                     print("now I go here")
        
     }
    
    
    
    
   
    
    func setCustomRegion(coordinates: CLLocationCoordinate2D) {
        let region = CLCircularRegion(center: coordinates, radius: 25, identifier: "")
        locationManager.startMonitoring(for: region)
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
    
    
    
    
    func fetchDrivers(location: CLLocation, completion: @escaping(UserFirebase) -> Void) {
        
        
        let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
        
        print("first section")
        
        REF_USER_LOCATIONS.observe(.value) { (snapshot) in
            
          
            self.discoveryArray.removeAll()
            
          
            
          geofire.query(at: location, withRadius: 5).observe(.keyEntered, with: { (uid, location) in
                
           
               
       
              if self.distanceCalculator(location: location) <= 10.0 {
                
                    self.fetchUserData(uid: uid, completion: { (user) in
                    
                 
                    let driver = user
                   
                    
                    completion(driver)
                })
                    
                }
                
                 
                
               
            })
            
        }
        
   
    }
     
    
    func fetchUsers(location: CLLocation, completion: @escaping(String, CLLocation) -> Void) {
        let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
        
       
        
        REF_USER_LOCATIONS.observe(.value) { (snapshot) in
            
            
            
            geofire.query(at: location, withRadius: 5).observe(.keyEntered, with: { (uid, location) in
            
           
          
                
                completion(uid, location)
               
             
            })
            
         
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



extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message//"No cool people around here.... Don't worry check Feature tab to match you with someone cool."
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


extension UIView {

    func setEmptyMessageView(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: self.bounds.size.height/2 - 25, width: self.bounds.size.width, height: 50))
        messageLabel.text = message//"No cool people around here.... Don't worry check Feature tab to match you with someone cool."
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.addSubview(messageLabel)
       
    }

    
}






