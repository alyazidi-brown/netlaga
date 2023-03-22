///
/// MIT License
///
/// Copyright (c) 2020 Mac Gallagher
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///

import UIKit
import Kingfisher
import FirebaseAuth
import Firebase
import GeoFire
import MapKit
import CoreLocation
import PopBounceButton
import Shuffle_iOS

class TinderViewController: UIViewController, CLLocationManagerDelegate, ButtonStackViewDelegate, SwipeCardStackDataSource, SwipeCardStackDelegate {
    
    var users = [NSDictionary]()
    
    var locationName : String = ""
    var locationAddress : String = ""
    
    var newPostsQuery = GFCircleQuery()
    
    
    var locationManager : CLLocationManager = CLLocationManager()
   
    let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
    
    var likeObject = LikedObject()

  private let cardStack = SwipeCardStack()

  private let buttonStackView = ButtonStackView()
    
    

  private var cardModels = [DiscoveryStruct]() /*[
    TinderCardModel(name: "Michelle",
                    age: 26,
                    occupation: "Graphic Designer",
                    image: UIImage(named: "michelle")),
    TinderCardModel(name: "Joshua",
                    age: 27,
                    occupation: "Business Services Sales Representative",
                    image: UIImage(named: "joshua")),
    TinderCardModel(name: "Daiane",
                    age: 23,
                    occupation: "Graduate Student",
                    image: UIImage(named: "daiane")),
    TinderCardModel(name: "Julian",
                    age: 25,
                    occupation: "Model/Photographer",
                    image: UIImage(named: "julian")),
    TinderCardModel(name: "Andrew",
                    age: 26,
                    occupation: nil,
                    image: UIImage(named: "andrew")),
    TinderCardModel(name: "Bailey",
                    age: 25,
                    occupation: "Software Engineer",
                    image: UIImage(named: "bailey")),
    TinderCardModel(name: "Rachel",
                    age: 27,
                    occupation: "Interior Designer",
                    image: UIImage(named: "rachel"))
  ]
                            */

  override func viewDidLoad() {
    super.viewDidLoad()
    cardStack.delegate = self
    cardStack.dataSource = self
    buttonStackView.delegate = self
      checkLikes()
      
    
      
    downloadMatches()
      
     

    configureNavigationBar()
    layoutButtonStackView()
    layoutCardStackView()
    configureBackgroundGradient()
  }

  private func configureNavigationBar() {
    let backButton = UIBarButtonItem(title: "Back",
                                     style: .plain,
                                     target: self,
                                     action: #selector(handleShift))
    backButton.tag = 1
    backButton.tintColor = .lightGray
    navigationItem.leftBarButtonItem = backButton

    let forwardButton = UIBarButtonItem(title: "Forward",
                                        style: .plain,
                                        target: self,
                                        action: #selector(handleShift))
    forwardButton.tag = 2
    forwardButton.tintColor = .lightGray
    navigationItem.rightBarButtonItem = forwardButton

    navigationController?.navigationBar.layer.zPosition = -1
  }

  private func configureBackgroundGradient() {
    let backgroundGray = UIColor(red: 244 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1)
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.white.cgColor, backgroundGray.cgColor]
    gradientLayer.frame = view.bounds
    view.layer.insertSublayer(gradientLayer, at: 0)
  }

  private func layoutButtonStackView() {
    view.addSubview(buttonStackView)
    buttonStackView.anchor(left: view.safeAreaLayoutGuide.leftAnchor,
                           bottom: view.safeAreaLayoutGuide.bottomAnchor,
                           right: view.safeAreaLayoutGuide.rightAnchor,
                           paddingLeft: 24,
                           paddingBottom: 12,
                           paddingRight: 24)
  }

  private func layoutCardStackView() {
      
    view.addSubview(cardStack)
    cardStack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                     left: view.safeAreaLayoutGuide.leftAnchor,
                     bottom: buttonStackView.topAnchor,
                     right: view.safeAreaLayoutGuide.rightAnchor,
                     paddingTop: 80)
  }

  @objc
  private func handleShift(_ sender: UIButton) {
    cardStack.shift(withDistance: sender.tag == 1 ? -1 : 1, animated: true)
  }
    
        //MARK: - Download
        private func downloadMatches() {
            
            UserService.downloadUserMatches { (matchedUserIds) in
                
              
            }
        }
    
    private func showMatchView(userId: String) {
        
        let matchView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "matchView") as! MatchViewController
                
        matchView.userId = userId
       
        self.present(matchView, animated: true, completion: nil)
    }
    
    //Enter php friend request here
    private func checkForLikesWith(userId: String) {
        
        print("you here check userid \(userId) \(LikedObject.likedIdArray.contains(userId))")
               
  
        if LikedObject.likedIdArray.contains(userId) == false {
            
            friendRequest(status: "add", friend_id: userId, user_id: User.uid) { status in
                if status == "success" {
            
            
            LikedObject.likedIdArray.append(userId)
            LikedObject.dateArray.append(Timestamp(date: Date()))
            print("so you should enter here")
            
            UserService.saveUserToFireStore(to: LikedObject.likedIdArray, dates: LikedObject.dateArray)
                    
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
                        
                        self.friendRequest(status: "confirm", friend_id: userId, user_id: User.uid) { status in
                            
                            
                            if status == "success" {
                            
                            self.showMatchView(userId: userId)
                                
                            }
                            
                            
                        }
                        
                        
                        
                    }
                
                            
                      //  }
                        
                  //  }
                
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
         
        
        fetchDrivers(location: User.location) { (driver) in
        
                   
                 let firstName = driver.firstName
                     
                 let email = driver.email
                     
                 let uid = driver.uid
                     
                 let ava = driver.ava
                 
                 let place = driver.place
                 
                 print("here is driver stuff \(driver) \(place) \(uid) \(currentUid)")
                 
                 
                 if currentUid != uid {//&& place == User.place {
                     
                     let discovery = DiscoveryStruct(firstName: firstName, email: email, ava: ava, uid: uid, place: place)
                     
                     print("you should be empty at some point\(self.cardModels) \(uid) \(LikedObject.likedIdArray)")
                     
                
                     
                     if  self.cardModels.contains{ $0.uid == uid } || LikedObject.likedIdArray.contains(uid) {
                         
                         
                     } else {
                
                     
                 self.cardModels.append(discovery)
                         
                     }
                     
                     print("discovery array \(discovery) \(self.cardModels)")
                     
                 DispatchQueue.main.async {

                 self.cardStack.reloadData()
                                     
                                     
                                         
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
     
    
    func fetchUsers(location: CLLocation, completion: @escaping(String, CLLocation) -> Void) {
        let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
        
        print("first section 2")
        
        REF_USER_LOCATIONS.observe(.value) { (snapshot) in
            
            print("second section 3 \(location) \(snapshot)")
            
            geofire.query(at: location, withRadius: 5).observe(.keyEntered, with: { (uid, location) in
            
           
          
           
                print("third section 2 \((uid, location))")
                
                completion(uid, location)
               
                
                print("fifth section 2")
            })
            
            print("sixth section 2")
        }
        
        print("seventh section 2")
    }
    
    
    func distanceCalculator(location: CLLocation) -> Double {
        
            //My location
        let myLocation = User.location//CLLocation(latitude: 59.244696, longitude: 17.813868)

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
     
//}

// MARK: Data Source + Delegates

//extension TinderViewController: ButtonStackViewDelegate, SwipeCardStackDataSource, SwipeCardStackDelegate {

  func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
    let card = SwipeCard()
    card.footerHeight = 80
    card.swipeDirections = [.left, .up, .right]
    for direction in card.swipeDirections {
      card.setOverlay(TinderCardOverlay(direction: direction), forDirection: direction)
    }

    let model = cardModels[index]
      
    let imageUrl = URL(string: model.ava)
      
      DispatchQueue.global().async {
          let data = try? Data(contentsOf: imageUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
          DispatchQueue.main.async {
              
              card.content = TinderCardContentView(withImage: UIImage(data: data!))
              
          }
      }
      
    
      card.footer = TinderCardFooterView(withTitle: "\(model.firstName)", subtitle: model.place)

    return card
  }

  func numberOfCards(in cardStack: SwipeCardStack) -> Int {
    return cardModels.count
  }

  func didSwipeAllCards(_ cardStack: SwipeCardStack) {
    print("Swiped all cards!")
  }

  func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
    print("Undo \(direction) swipe on \(cardModels[index].firstName)")
  }

  func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
    print("Swiped2 \(direction) on \(cardModels[index].firstName)")
      
      let discoverySetUp = cardModels[index]
      
      //LikedObject.likedIdArray.append(cardModels[index].uid)
      
      if direction  == .right || direction == .up {
          
         checkForLikesWith(userId: discoverySetUp.uid)
         
      }
  }

  func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
    print("Card tapped")
  }

  func didTapButton(button: TinderButton) {
    switch button.tag {
    case 1:
      cardStack.undoLastSwipe(animated: true)
    case 2:
      cardStack.swipe(.left, animated: true)
    case 3:
      cardStack.swipe(.up, animated: true)
    case 4:
      cardStack.swipe(.right, animated: true)
    case 5:
      cardStack.reloadData()
    default:
      break
    }
  }
}

