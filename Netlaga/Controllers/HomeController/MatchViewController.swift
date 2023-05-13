//
//  MatchViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 11/28/22.
//

import Foundation
import UIKit



class MatchViewController: UIViewController {
    
    var userId: String = ""
    
    var users = [NSDictionary]()
    
    var matchInfo = DiscoveryStruct(firstName: "", email: "", ava: "", uid: "", place: "", token: "")
    
    @IBOutlet weak var matchImage: UIImageView!
    
    
    @IBOutlet weak var nameAgeLabel: UILabel!
    
    
    @IBOutlet weak var msgButton: UIButton!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
        
         }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchUsers(uid: userId)
        
        friendRequest(status: "reject", friend_id: userId, user_id: User.uid) { status in
            self.friendRequest(status: "reject", friend_id: User.uid, user_id: self.userId)
        }
      
    }
    
    @IBAction func msgAction(_ sender: Any) {
        
        
        let vc = ChatViewController(recipientId: matchInfo.uid, recipientName: matchInfo.firstName)//(discoverySetUp: matchInfo)//ChatController(discoverySetUp: matchInfo) //your view controller
        vc.discoverySetUp = matchInfo
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated:true, completion: nil)
       // vc.modalPresentationStyle = .overFullScreen
        //self.present(vc, animated: true, completion: nil)
         
        
    }
    
    
        // searchUsers
    func searchUsers(uid: String) {
            
            let url:URL = URL(string: "https://netlaga.net/friends.php")!
            let session = URLSession.shared
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
        
            
            let paramString: String = "action=specific&id=\(uid)"
            
           
                
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
                                    guard let users = json["users"] as? NSDictionary else {
                                       
                                        print("if you go here you are in trouble")
                                        return
                                    }
                                
                                print("users \(users)")
                                    
                                    // save accessed json (users) in our array
                                    //self.users = users
                                
                                //for user in users {
                                    
                                    let name = users["firstName"] as? String
                                    let birthday = users["birthday"] as? String
                                    let email = users["email"] as? String
                                    let ava = users["ava"] as? String
                                    let uid = users["uid"] as? String
                                    //let token = users["token"] as? String ?? ""
                                    //let place = users["place"] as? String
                                    
                                    print("name & birthday \(name) \(birthday)")
                                
                                let imageUrl = URL(string: ava!)
                                
                                self.matchImage.kf.setImage(with: imageUrl)
                                
                        
                                
                                var dateString3 : String = ""
                                
                                var dateString4 : String = ""
                                

                                
                                dateString3 = birthday!
                                
                               
                                
                                
                                var dateArr2: [String] = [String]()
                                
                                let stringAdd = " 00:00:00"
                                
                                dateArr2 =  dateString3.components(separatedBy: " ")
                                
                                dateString4 = dateArr2[0] + stringAdd
                                
                               print("date stuff \(dateArr2) \(dateString3) \(dateString4)")
                                
                                let dateFormatterGet2 = DateFormatter()
                                dateFormatterGet2.dateFormat = "dd-MM-yy HH:mm:ss"
                                
                                let date2 = dateFormatterGet2.date(from: dateString4)
                                
                                print("date nil \(date2)")
                                
                                let dateToday = Date()
                                
                                let formatter: DateFormatter = DateFormatter()
                                formatter.dateFormat = "dd-MM-yy HH:mm:ss"
                                
                                let result = formatter.string(from: dateToday)
                                
                                let dateToday2 = dateFormatterGet2.date(from: result)
                                
                                
                                if date2 != nil {
                                    
                                    
                                let age = self.yearsBetweenDate(startDate: date2!, endDate: dateToday2!)
                                    
                                print("the name and age \(name) \(age)")
                                                                   
                                self.nameAgeLabel.text = "\(name!) / \(age)"
                                       
                             
                                    }
                                
                               
                                self.matchInfo = DiscoveryStruct(firstName: name!, email: email!, ava: ava!, uid: uid!, place: "", token: "")
                                //}
                                
                                //let discovery = DiscoveryStruct(firstName: firstName, email: email, ava: ava, uid: uid, place: place)
                                    
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
    
    func yearsBetweenDate(startDate: Date, endDate: Date) -> Int {

        let calendar = Calendar.current

        let components = calendar.dateComponents([.year], from: startDate, to: endDate)

        return components.year!
    }
    
    func friendRequest(status: String, friend_id: String, user_id: String, completion: @escaping(String) -> Void) {
        
        let url:URL = URL(string: "https://netlaga.net/friends.php")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
    
        
        let paramString: String = "action=\(status)&user_id=\(user_id)&friend_id=\(friend_id)"
        
       
            
         
        
        
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
                            
                            completion("success")
                            
                          
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
    
    func friendRequest(status: String, friend_id: String, user_id: String) {
        
        let url:URL = URL(string: "https://netlaga.net/friends.php")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
    
        
        let paramString: String = "action=\(status)&user_id=\(user_id)&friend_id=\(friend_id)"
        
       
            
         
        
        
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



}
