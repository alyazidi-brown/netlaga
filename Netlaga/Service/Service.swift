//
//  Service.swift
//  DatingApp
//
//  Created by Scott Brown on 9/18/22.
//

import Firebase
import CoreLocation
import GeoFire
import FirebaseAuth
import FirebaseFirestore
import MessageKit
import AVKit

// MARK: - DatabaseRefs

let DB_REF : DatabaseReference = Database.database().reference()
let auth = Auth.auth()
let db = Firestore.firestore()
var userListener : ListenerRegistration? = nil
var favsListener : ListenerRegistration? = nil

//let DB_REF  = Database.database().reference()
let REF_CONST = DB_REF.child("Constant")
let REF_PROC = DB_REF.child("Processing")
let REF_RATE = DB_REF.child("Rate")
let REF_USERS = DB_REF.child("users")
let REF_USER_LOCATIONS = DB_REF.child("user-locations")
//private var refHandle: DatabaseHandle!
let REF_TRIPS = DB_REF.child("trips")
let REF_DRIVER_TRANSIT = DB_REF.child("driver-transit")
let COLLECTION_MESSAGES = Firestore.firestore().collection("message")
let COLLECTION_MESSAGE_USERS = Firestore.firestore().collection("message_users")
let LIKED_LIST = Firestore.firestore().collection("liked-list")

var userArray: [UserFirebase] = []



struct UserService {
    static let shared = UserService()
    
    

    static func fetchUserData(uid: String, completion: @escaping(UserFirebase) -> Void) {
        
        //REF_USERS.child(uid).observe(of: .value) { (snapshot) in
            
       // }
       
        
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
            
            print("what's in the array \(DiscoveryViewController.shared.discoveryArray)")
            
            DiscoveryViewController.shared.discoveryArray.removeAll()
            
            print("what's in the array 2\(DiscoveryViewController.shared.discoveryArray)")
            
            print("second section \(location) \(snapshot)")
            //geofire.query(with: <#T##MKCoordinateRegion#>)
            
            geofire.query(at: location, withRadius: 5).observe(.keyEntered, with: { (uid, location) in
                
                
           
                print("third section \((uid, location))")
       
                if distanceCalculator(location: location) <= 100.0 {
                
                    UserService.fetchUserData(uid: uid, completion: { (user) in
                    
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
    
    static func fetchMessages(forUser user: DiscoveryStruct, completion: @escaping([Message]) -> Void) {
        
        
        var messages = [Message]()
        
        var messagesTwo = [MKMessage]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            print("the count")
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    
                    var dictionary = change.document.data()
                    
                    
                    guard let stamp = dictionary["timestamp"] as? Timestamp else {
                                return
                            }
                    guard let type = dictionary["type"] as? String else {
                                return
                            }
                    
                    guard let mediaURL = dictionary["mediaURL"] as? String else {
                                return
                            }
                    guard let mediaURLTwo = dictionary["mediaURLTwo"] as? String else {
                                return
                            }
                    
                    let photoItem = PhotoMessage(path: mediaURL)
                    
                    print("photoitem 1st \(photoItem)")
                    
                    dictionary.updateValue(photoItem, forKey: "photoItem")
                    
                    print("dictionary message \(dictionary) new \(dictionary["timestamp"])")

                    let date = stamp.dateValue()
                    
                    let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: date, to: Date())
                    let hours = diffComponents.hour
                    let minutes = diffComponents.minute
                    
                    print("and here it is in date format \(date) \(hours) \(minutes)")
                    
                    if minutes! < 2 {
                        
                        if type == "picture" {

                          

                        }
                        
                      messages.append(Message(dictionary: dictionary)) 
                        
                        
                        
                    }
                    completion(messages)
                }
            })
        }
    }
    
    static func fetchMessagesThree(forUser user: DiscoveryStruct, completion: @escaping([MKMessage]) -> Void) {//([Message]) -> Void) { IN CASE WE NEED TO REVERT
        
        
        var messages = [Message]()
        
        var messagesTwo = [MKMessage]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    
                    var dictionary = change.document.data()
                    print("dictionary message \(dictionary) new \(dictionary["timestamp"])")
                    
                    guard let stamp = dictionary["timestamp"] as? Timestamp else {
                                return
                            }
                    guard let type = dictionary["type"] as? String else {
                                return
                            }
                    
                    guard let mediaURL = dictionary["mediaURL"] as? String else {
                                return
                            }
                    
                    guard let mediaURLTwo = dictionary["mediaURLTwo"] as? String else {
                                return
                            }
                    
                    guard let text = dictionary["text"] as? String else {
                                return
                            }
                    
                    
                    
                    if let url = URL(string: "\(mediaURL)") {
                        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                            guard let data = data, error == nil else { return }
                            
                            DispatchQueue.main.async { /// execute on main thread
                                                       
                                let photoItem = PhotoMessage(path: mediaURL)
                                photoItem.image = UIImage(data: data)
                                
                                print("photoitem 1st \(photoItem)")
                                
                            
                                dictionary.updateValue(photoItem, forKey: "photoItem")
                                
                               

                                
                                print("dictionary message \(dictionary) new \(dictionary["timestamp"])")
                                
                                let date = stamp.dateValue()
                                
                                let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: date, to: Date())
                                let hours = diffComponents.hour
                                let minutes = diffComponents.minute
                                
                                print("and here it is in date format \(date) \(hours) \(minutes)")
                                
                                if minutes! < 2 {
                                    
                                    if type == "picture" {
                                        
                                        

                                        let messageKind = MessageKind.photo(photoItem)
                                        
                                        dictionary.updateValue(messageKind, forKey: "kind")
                                        

                                    } else {
                                        
                                        let messageKind = MessageKind.text(text)
                                        
                                        dictionary.updateValue(messageKind, forKey: "kind")
                                        
                                    }
                                    
                                    print("next dictionary message \(dictionary) ")
                                    
                                    let message = Message(dictionary: dictionary)
                                                            
                                    let mkMessage = MKMessage(message: message)
                                    
                                    messagesTwo.append(mkMessage)
                            
                                    
                                    
                                }
                                completion(messagesTwo)
                                
                                print("ensure the timing is right")
                            }
                            
                            print("ensure the timing is right2")
                        }
                        
                        task.resume()
                    }
                    
                    
                }
            })
        }
    }
    
    static func duration(for resource: String) -> Double {
        let asset = AVURLAsset(url: URL(string: resource)!)//AVURLAsset(url: URL(fileURLWithPath: resource))
        
        print("asset \(asset), duration \(asset.duration) and double \(Double(CMTimeGetSeconds(asset.duration)))")
        
        return Double(CMTimeGetSeconds(asset.duration))
    }
    
    static func durationURL(for resource: String) -> Double {
        
        do
            {
            let avAudioPlayer = try AVAudioPlayer (contentsOf: URL(string: resource)!)
            let duration = avAudioPlayer.duration
            
            print("duration new \(duration) and double \(duration)")
            
            return Double(duration)
                
            }
            catch{
                return 0.0
            }
        
        
    }
    
    static func fetchMessagesTwo(forUser user: DiscoveryStruct, completion: @escaping([MKMessage]) -> Void) {
        
        
        var messages = [Message]()
        
        var messagesTwo = [MKMessage]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    
                    var dictionary = change.document.data()
                    
                    guard let stamp = dictionary["timestamp"] as? Timestamp else {
                                return
                            }
                    guard let inviteLatitude = dictionary["latitude"] as? String else {
                                return
                            }
                    
                    guard let inviteLongitude = dictionary["longitude"] as? String else {
                                return
                            }
                    
                    guard let type = dictionary["type"] as? String else {
                                return
                            }
                    
                    guard let mediaURL = dictionary["mediaURL"] as? String else {
                                return
                            }
                   
                    
                    guard let text = dictionary["text"] as? String else {
                                return
                            }
                    
                    print("the type \(type)")
                    let date = stamp.dateValue()
                    
                    let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: date, to: Date())
                    let hours = diffComponents.hour
                    
                    
                    if hours! < 24 {
                        
                        if type == "picture" {
                            
                            print("presumably you're entering here")
                            
                            UserService.timeThePhoto(media: mediaURL) { thePhotoItem in
                            
                            dictionary.updateValue(thePhotoItem, forKey: "photoItem")
                            
                            let messageKind = MessageKind.photo(thePhotoItem)
                            
                            dictionary.updateValue(messageKind, forKey: "kind")
                            
                            let audioItem = AudioItem.self//Audio(url: URL, duration: 0, size: CGSize(width: 0, height: 0))//PhotoMessage(path: mediaURL)

                                dictionary.updateValue(audioItem, forKey: "audioItem")

                                let locationItem = LocationItem.self
                                
                                dictionary.updateValue(locationItem, forKey: "locationItem")
                                
                                let message = Message(dictionary: dictionary)
                                                        
                                let mkMessage = MKMessage(message: message)
                                
                                messagesTwo.append(mkMessage)
                            
                                completion(messagesTwo)
                                
                            }

                        } else if type == "audio"{
                            
                           
                            
                            var audioDuration: Double = 0.0
                            
                           let audioUrl = URL(string: "\(mediaURL)")
                            
                            audioDuration = self.duration(for: "\(mediaURL)")
                                    
                            print("presumably you're entering here \(Float(audioDuration))")
                            
                            let photoItem = PhotoMessage(path: "")
                                       
                            dictionary.updateValue(photoItem, forKey: "photoItem")
                            
                            let locationItem = LocationItem.self
                            
                            dictionary.updateValue(locationItem, forKey: "locationItem")
                                        
                            let audioItem = Audio(url: audioUrl!, duration: Float(audioDuration), size: CGSize(width: 200, height: 30))//PhotoMessage(path: mediaURL)
                            
                            
                                        dictionary.updateValue(audioItem, forKey: "audioItem")
                                        
                                    
                                        let messageKind = MessageKind.audio(audioItem)
                                        
                            
                                        dictionary.updateValue(messageKind, forKey: "kind")
                                        
                                        let message = Message(dictionary: dictionary)
                                                                
                                        let mkMessage = MKMessage(message: message)
                            
                                        
                                        messagesTwo.append(mkMessage)
                                        
                                        completion(messagesTwo)
                                        
                            
                            
                            
                        } else if type == "location"{
                            
                            
                            var inviteLocation = CLLocation()
                            
                            
                            
                            inviteLocation = CLLocation(latitude: Double(inviteLatitude) ?? 0.0, longitude: Double(inviteLongitude) ?? 0.0)
                           
                            
                            let photoItem = PhotoMessage(path: "")
                                       
                            dictionary.updateValue(photoItem, forKey: "photoItem")
                                        
                            let audioItem = AudioItem.self
                            
                            
                            
                            let locationItem = Location(location: inviteLocation, size: CGSize(width: 200, height: 200))
                            
                            dictionary.updateValue(locationItem, forKey: "locationItem")
                            
                                        dictionary.updateValue(audioItem, forKey: "audioItem")
                                        
                                    
                                        let messageKind = MessageKind.location(locationItem)
                            
                            
                                        
                            
                                        dictionary.updateValue(messageKind, forKey: "kind")
                                        
                                        let message = Message(dictionary: dictionary)
                                                                
                                        let mkMessage = MKMessage(message: message)
                            
                                        
                                        messagesTwo.append(mkMessage)
                                        
                                        completion(messagesTwo)
                                        
                            
                            
                            
                        }else {
                            
                            let audioItem = AudioItem.self//Audio(url: URL(string: "")!, duration: 0, size: CGSize(width: 0, height: 0))//PhotoMessage(path: mediaURL)
                            
                            let locationItem = LocationItem.self
                            
                            dictionary.updateValue(locationItem, forKey: "locationItem")
                          
                            dictionary.updateValue(audioItem, forKey: "audioItem")
                            
                            let photoItem = PhotoMessage(path: "")
                           
                            dictionary.updateValue(photoItem, forKey: "photoItem")
                            
                            let messageKind = MessageKind.text(text)
                            
                            dictionary.updateValue(messageKind, forKey: "kind")
                            
                            let message = Message(dictionary: dictionary)
                                                    
                            let mkMessage = MKMessage(message: message)
                            
                            messagesTwo.append(mkMessage)
                            
                            completion(messagesTwo)
                        }
                        
                        
                    }
                    
                    //completion(messagesTwo)
                
                }
            })
        }
    }
    
    static func timeThePhoto(media: String, completion: @escaping(PhotoMessage) -> Void) {
        print("pic order")
        if let url = URL(string: "\(media)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                print("pic order1")
                DispatchQueue.main.async { /// execute on main thread
                    print("pic order2")
                    let photoItem = PhotoMessage(path: media)
                    photoItem.image = UIImage(data: data)
                    print("pic order3")
                    completion(photoItem)
                    
                }
                
                print("pic order4")
            }
            print("pic order5")
            task.resume()
            print("pic order6")
        }
        print("pic order7")
    }
    
    static func fetchMessageUsers(completion: @escaping([String]) -> Void) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_MESSAGE_USERS.document(currentUid).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
           
            
            if snapshot.exists {
                
                UserMessageObject.uIds = snapshot.get("uIds") as! [String]
                
                completion(UserMessageObject.uIds)

                
            } else {
               
                
                completion(UserMessageObject.uIds)
                
            }
        }
    }
    
    //static func uploadMessageUser(to user: DiscoveryStruct, completion: ((Error?) -> Void)?) {
        
    static func uploadMessageUser(to user: DiscoveryStruct, completion: @escaping(String) -> Void) {
    
        
        print("message user1")
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        print("message user2")
        
        if UserMessageObject.uIds.contains(user.uid) {
            
        } else {
            
            UserMessageObject.uIds.append(user.uid)
            
        }
        
        print("message user3")
        
        let data = ["uIds": UserMessageObject.uIds] as [String : Any]
        
        let docRef = COLLECTION_MESSAGE_USERS.document(currentUid)
       
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                print("message user4")
                
                COLLECTION_MESSAGE_USERS.document(currentUid).updateData(data) {_ in
                    
                    completion("string")
                
                    print("message user5")
                }
                
               
            } else {
                
                print("message user6")
                
                COLLECTION_MESSAGE_USERS.document(currentUid).setData(data) { (error) in
                    
                    print("message user7")
                    
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                    
                    completion("string")
                }
                
             
            }
        }
      
    }
    
    //static func uploadPhoto(_ message: UIImage?, to user: DiscoveryStruct, completion: ((Error?) -> Void)?) {
    //static func uploadPhoto(_ message: UIImage?, to user: DiscoveryStruct, completion: @escaping (String, Error?) -> Void) {
    
    static func uploadPhoto(_ message: UIImage?, to user: DiscoveryStruct, completion: @escaping(String) -> Void) {
    
    guard let currentUid = Auth.auth().currentUser?.uid else {return}
    
    let fileName = Date().stringDate()
    let fileDirectory = "\(currentUid)_\(fileName)jpg"
        
    print("well 1st off are you here? \(fileDirectory)")
    
        FileStorage.saveImageLocally(imageData: message!.jpegData(compressionQuality: 0.6)! as NSData, fileName: fileName)
        print("well 1st off are you here2?")
   
    FileStorage.uploadImage(message!, directory: fileDirectory) { (imageURL) in
        
        print("well 1st off are you here3?")
        
        if imageURL != nil {
          
            UserService.uploadMessageUser(to: user) { upload in//error in
                
                
            UserService.uploadMessage(mediaURL: imageURL, mediaURLTwo: fileDirectory, type: "picture", to: user) { error in
                
            
                if let error = error {
                    
                    print("DEBUG: failed")
                    
                    return
                    
                    
                }
                
                //completion(imageURL ?? "")
                
               
                    
                    /*
                    if let error = error {
                        
                        print("DEBUG: failed")
                        
                        return
                        
                        //inputView.clearMessagingText()//.messageInputTextView.text = nil
                        
                    }
                     */
                    
                    completion(upload)
                    
                    print("here is your imageurl \(imageURL ?? "")")
                    //completion(imageURL ?? "")
                    
                    //completion(imageURL ?? "", error )
                }
            
         
        }
    }
        
    }
    
        
    }
    
    static func uploadAudio(_ message: UIImage?, to user: DiscoveryStruct, completion: ((Error?) -> Void)?) {
        
   
        
    }
    
    static func uploadMessage(_ message: String? = "", mediaURL: String? = "", mediaURLTwo: String? = "", inviteLatitude: String? = "", inviteLongitude: String? = "", type: String, to user: DiscoveryStruct, completion: ((Error?) -> Void)?) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        
        let data = ["text": message, "fromId": currentUid, "toId": user.uid, "timestamp": Timestamp(date: Date()), "type": type, "mediaURL": mediaURL, "mediaURLTwo": mediaURLTwo, "latitude": inviteLatitude, "longitude": inviteLongitude] as [String : Any]
        
        print("is my data here? \(data)")
        
        COLLECTION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) {_ in
            
            print("is my data here2?")
            
            COLLECTION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            
            
            print("is my data here3?")
            
        }
    }
    
    static func testUploadMessage(_ message: String, to user: DiscoveryStruct, completion: ((Error?) -> Void)?) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let data = ["text": message, "fromId": currentUid, "toId": user.uid, "timestamp": Timestamp(date: Date()), "type": "text", "mediaURL": ""] as [String : Any]
        
        COLLECTION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) {_ in
            
            COLLECTION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
        }
    }
    
    static func downloadCurrentUserLikedListFromFirebase(completion: @escaping([String]) -> Void) {
        
        print("Document does not exist2")
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        print("Document does not exist3")
        
        LIKED_LIST.document(currentUid).getDocument { (snapshot, error) in
            
            print("Document does not exist4")
            
            guard let snapshot = snapshot else { return }
            
            print("Document does not exist5")
            
            if snapshot.exists {
                
                print("Document does not exist6")
                
                //LikedObject.init(likedIdArray: snapshot.get("likedIdArray") as! [String])
                
                LikedObject.likedIdArray = snapshot.get("likedIdArray") as! [String]
                
                LikedObject.dateArray = snapshot.get("dateArray") as! [Timestamp]
                
               
            
                
                
                print("liked id array \(LikedObject.likedIdArray) \(currentUid)")
                
                //let user = FUser(_dictionary: snapshot.data() as! NSDictionary)
               
                
                completion(LikedObject.likedIdArray)

                
            } else {
                //first login
                
                completion(LikedObject.likedIdArray)
                
            }
        }
    }
    
    static func deleteFromLikedList(userId: String, completion: @escaping (_ matchedUserIds: [String]) -> Void) {
        
        var indexStorer: Int = 0
        
        if LikedObject.likedIdArray.count > 0 {
        
        for i in 0...LikedObject.likedIdArray.count - 1 {
            
            if LikedObject.likedIdArray[i] == userId {
                
                indexStorer = i
                
            }
            
        }
            
       
        
        LikedObject.likedIdArray.remove(at: indexStorer)
        
        LikedObject.dateArray.remove(at: indexStorer)
        
        saveUserToFireStore(to: LikedObject.likedIdArray, dates: LikedObject.dateArray)
            
            
        }
        
        completion(LikedObject.likedIdArray)

    }
    
    static func saveUserToFireStore(to users: [String], dates: [Timestamp]) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let data = ["likedIdArray": users, "dateArray": dates] as [String : Any]
        
        let docRef = LIKED_LIST.document(currentUid)//db.collection("cities").document("SF")
       


        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                LIKED_LIST.document(currentUid).updateData(data) {_ in
                
               // currentUser.updateCurrentUserInFireStore(withValues: data) { (error) in
                    
                    //print("updated current user with error ", error?.localizedDescription)
                }
                
                //print("Document data: \(dataDescription)")
            } else {
                
                LIKED_LIST.document(currentUid).setData(data) { (error) in
                    
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                }
                
                print("Document does not exist")
            }
        }
                
      
    }
    
    
   static func checkIfUserLikedUs(userId: String, completion: @escaping (_ didLike: Bool) -> Void) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
       
       
        /*
        FirebaseReference(.Like).whereField("likedUserId", isEqualTo: currentUid).whereField("uid", isEqualTo: userId).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            completion(!snapshot.isEmpty)
        }
         */
       
       LIKED_LIST.document(userId).getDocument { (snapshot, error) in
           
           guard let snapshot = snapshot else { return }
           
           
           if snapshot.exists {
               
              let arrayHolder = snapshot.get("likedIdArray") as! [String]
               
               if arrayHolder.contains(currentUid) {
                   
                   completion(true)
                   
               } else {
                   
                   completion(false)
               }
               
           } else {
               //first login
               completion(false)
              
           }
       }
    }
    
    
        //MARK: - Match
       static func downloadUserMatches(completion: @escaping (_ matchedUserIds: [String]) -> Void) {
            
            let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
            
            guard let currentUid = Auth.auth().currentUser?.uid else {return}
            
           // FirebaseReference(.Match).whereField("memberIds", arrayContains: currentUid).whereField("date", isGreaterThan: lastMonth).order(by: "date", descending: true).getDocuments { (snapshot, error) in
           
           FirebaseReference(.Match).whereField("uIds", arrayContains: currentUid).getDocuments { (snapshot, error) in
               
               print("the snapshot \(snapshot)")
                
                var allMatchedIds: [String] = []
                
                guard let snapshot = snapshot else { return }
                
                if !snapshot.isEmpty {
                    
                    for matchDictionary in snapshot.documents {
                        
                        print("match dictionary \(matchDictionary["uIds"])")
                        
                        allMatchedIds += matchDictionary["uIds"] as? [String] ?? [""]
                        
                        print("match dictionary 2 \(allMatchedIds)")
                    }
                    
                    completion(removeCurrentUserIdFrom(userIds: allMatchedIds))
                    
                } else {
                    print("No Matches found")
                    completion(allMatchedIds)
                }
            }
        }
    
    /*
    func downloadUsersFromFirebase(withIds: [String], completion: @escaping (_ users: [UserFirebase]) -> Void) {
        
        var usersArray: [UserFirebase] = []
        var counter = 0
        
        for userId in withIds {
            
            FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else { return }
                
                if snapshot.exists {
                    
                    
                    
                    usersArray.append(DiscoveryStruct(_dictionary: snapshot.data()! as NSDictionary))
                    counter += 1
                    
                    if counter == withIds.count {
                        
                        completion(usersArray)
                    }
                    
                } else {
                    completion(usersArray)
                }
            }
        }
    }
     */
    
    static func removeCurrentUserIdFrom(userIds: [String]) -> [String] {
        
       print("all ids \(userIds)")
        
        var allIds = userIds
        
        var allIdsTwo : [String] = []

        for id in allIds {
            
            if allIdsTwo.contains(id) {
                
                
            } else {
                
                if id != Auth.auth().currentUser?.uid {
                
                allIdsTwo.append(id)
                    
                }
            }
            
            
            
                /*
            if id == Auth.auth().currentUser?.uid {
                allIds.remove(at: allIds.firstIndex(of: id)!)
            }
                 */
        }
        
        print("all ids \(allIds) \(allIdsTwo)")

        return allIdsTwo//allIds
    }

        
        
    static func saveMatch(userId: String, completion: @escaping() -> Void) {
            
            guard let currentUid = Auth.auth().currentUser?.uid else {return}
            
            let match = MatchObject(uid: UUID().uuidString, uIds: [currentUid, userId], date: Date())
            match.saveToFireStore()
        
            completion()
        }

    
    
}






/*
func fetchDrivers(location: CLLocation, completion: @escaping(UserFirebase) -> Void) {
    let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
    
    print("first section")
    
    //let center = CLLocation(latitude: 37.7832889, longitude: -122.4056973)
    // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
    var circleQuery = geofire.query(at: location, withRadius: 5)//geoFire.queryAtLocation(center, withRadius: 0.6)

    // Query location by region
    //let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    //let region = MKCoordinateRegion(location.coordinate, span)
   // var regionQuery = geoFire.queryWithRegion(region)
    
    REF_USER_LOCATIONS.observe(.value) { (snapshot) in
        
        print("second section \(location) \(snapshot)")
        
        
        
        circleQuery.observe(.keyEntered, with: { (uid, location) in
        
       
            print("third section \((uid, location))")
            
           
            
            fetchUserData(uid: uid, completion: { (user) in
                
                print("fourth section \(user)")
                let driver = user
               
                
                completion(driver)
            })
            
             
            
            print("fifth section")
        })
        
        print("sixth section")
    }
    
    print("seventh section")
}
 */
