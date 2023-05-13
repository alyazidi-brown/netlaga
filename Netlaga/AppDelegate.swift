//
//  AppDelegate.swift
//  Netlaga
//
//  Created by Scott Brown on 3/22/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FBSDKCoreKit
import GoogleMaps
import FirebaseMessaging
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_ID"
    
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        /*
        GMSServices.provideAPIKey("YOUR_API_KEY")
        GMSPlacesClient.provideAPIKey("YOUR_API_KEY")
         */
        
        GMSServices.provideAPIKey("AIzaSyAVAEwf8eLJ8yMZtX1NndYSuBWeqrEvEco")
        GMSPlacesClient.provideAPIKey("AIzaSyAVAEwf8eLJ8yMZtX1NndYSuBWeqrEvEco") //needed if we return to places API
        
        if #available(iOS 13, *) {
                        // do only pure app launch stuff, not interface stuff
                    } else {
                        
                        self.window = UIWindow()
                        
                        let vc =  LogInViewController()//HomeTabBarController()//EmailViewController()//InputViewController()//RegistrationViewController()//InputViewController()
                        vc.view.backgroundColor = .white
                        self.window!.rootViewController = vc
                        self.window!.makeKeyAndVisible()
                                        
                    }
        
      
        FirebaseApp.configure()
        
        //Push Notifications
        
        
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = 0
        return true
    }
    
   
    
    
    

          
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }



    
    
   
     
    
    func handlePasswordlessSignIn(_ withURL: URL) -> Bool {
        
        let link = withURL.absoluteString
        
        if Auth.auth().isSignIn(withEmailLink: link) {
            
            guard let email = UserDefaults.standard.value(forKey: "Email") as? String else { return false}
            
            Auth.auth().signIn(withEmail: email, link: link) { result, error in
                if let error = error {
                    
                    let alert = UIAlertController(title: "My Title", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    return
                }
                
                guard let result = result else {return}
                let uid = result.user.uid
                
                let data = ["uid": uid, "email": email, "timestamp": FieldValue.serverTimestamp()] as [String : Any]
            
            
            Firestore.firestore().collection("users").document(uid).setData(data, completion: { error in
                if let error = error {
                    
                    let alert = UIAlertController(title: "My Title", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                    // show the alert
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    
                    return
                }
                
                
                let alert = UIAlertController(title: "Success", message: "Successfully Signed In", preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            })
        }
            
            return true
        }
        return false
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            // If you are receiving a notification message while your app is in the background,
            // this callback will not be fired till the user taps on the notification launching the application.
            // TODO: Handle data of notification

            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)
        print("in background")
            // Print message ID.
            if let messageID = userInfo[gcmMessageIDKey] {
              print("Message ID: \(messageID)")
            }
        
        if let notification = userInfo["message"] as? String,
                    let jsonData = notification.data(using: .utf8),
                    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary {
                    //This is the point where we need to save push notification
                   // savePushNotification(payloadDict: dict ?? [:])
                    print("APS PAYLOAD DICTIONARY \(dict)")
            
                    let service_request_id = dict["service_request_id"] as? String ?? ""
            
               
                // Write/Set Value
                userDefaults.set(true, forKey: "\(service_request_id)")
            let myNotificationKey = "notificationKey"
                            
            NotificationCenter.default.post(name: Notification.Name(rawValue: myNotificationKey), object: self)
            
            
               
                }
        
        
        
        let state = application.applicationState
            switch state {
                
            case .inactive:
                print("Inactive")
                
            case .background:
                print("Background")
                // update badge count here
                application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
                
            case .active:
                print("Active")

            
            }
        
       // UIApplication.shared.applicationIconBadgeNumber = badgeCount

            // Print full message.
            print(userInfo)
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        let content = notification.request.content
        
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        
        print("here is the content \(content)")
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("userinfo 5 \(userInfo)")//*
        
        let type = userInfo["type"] as? String
        
        print("type \(type!)")
        
        if let notification = userInfo["message"] as? String,
                    let jsonData = notification.data(using: .utf8),
                    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary {
                    //This is the point where we need to save push notification
                   // savePushNotification(payloadDict: dict ?? [:])
                    print("APS PAYLOAD DICTIONARY \(dict)")
            
                    let service_request_id = dict["service_request_id"] as? String ?? ""
            
                // Write/Set Value
                userDefaults.set(true, forKey: "\(service_request_id)")
            
            let myNotificationKey = "notificationKey"
                            
            NotificationCenter.default.post(name: Notification.Name(rawValue: myNotificationKey), object: self)
                    
            
               
                }
        
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")//*
        }
        // Print full message.
        print("userinfo2 \(userInfo)")//*
        
        let content = response.notification.request.content
        
        print("here is the content \(content)")
        
        if let notification = userInfo["message"] as? String,
                    let jsonData = notification.data(using: .utf8),
                    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary {
                    //This is the point where we need to save push notification
                   // savePushNotification(payloadDict: dict ?? [:])
                    print("APS PAYLOAD DICTIONARY \(dict)")
              
                    let service_request_id = dict["service_request_id"] as? String ?? ""
            
                // Write/Set Value
                userDefaults.set(true, forKey: "\(service_request_id)")
            
            let myNotificationKey = "notificationKey"
                            
            NotificationCenter.default.post(name: Notification.Name(rawValue: myNotificationKey), object: self)
            
           
               
                }
        
        //let badgeCount = content.badge as! Int
        
        //UIApplication.shared.applicationIconBadgeNumber = 1//badgeCount
        
        completionHandler()
    }
    
   

}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
        
        UserDefaults.standard.set(fcmToken, forKey: "token")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    

                                                                  
}

