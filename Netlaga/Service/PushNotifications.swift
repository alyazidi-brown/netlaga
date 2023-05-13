//
//  PushNotifications.swift
//  Netlaga
//
//  Created by Scott Brown on 4/7/23.
//

    //
    //  PushNotifications.swift
    //  Vedoc
    //
    //  Created by Scott Brown on 3/12/23.
    //  Copyright © 2023 Fruktorum. All rights reserved.
    //

    import Foundation
    import Firebase


struct PushNotificationService {
        

        
        static let shared = PushNotificationService()
        
    static let kSERVERKEY = "AAAAAi-d4K0:APA91bHfsxo7zJxYqPguiiSMUbzxEriBFUeZYF-CRofbbgySlZdbcQMJYNAcEZUql6wTQ4ji8GRL5YRAw0Dj2uWt5SdVznZwvoT78OY78G9-dGcxujGj9sDr26Xmp95La6VYrU0X7Mm6"
        
        private init() { }
        
        
    
       static func sendMessageToUser(sender: String, chatRoomId: String, to token: String, title: String, body: String) {
            
            let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
            
            let paramString : [String : Any] = ["to" : token,
                                                "content_available": false,
                                                "notification" : [
                                                    "title" : title,
                                                    "body" : body,
                                                    "badge" : "1",
                                                    "sound" : "default"
                                                ]
            ]
            
            print("param notification \(paramString)")
            
            
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: paramString, options: [.prettyPrinted])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("key=\(kSERVERKEY)", forHTTPHeaderField: "Authorization")
            
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                (data, response, error) in
                
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("data string chat \(dataString)")
                
            }
            
            
        
            

            task.resume()
        }
        
    }


