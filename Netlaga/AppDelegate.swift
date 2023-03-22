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
//import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        /*
        GMSServices.provideAPIKey("YOUR_API_KEY")
        GMSPlacesClient.provideAPIKey("YOUR_API_KEY")
         */
        
        GMSServices.provideAPIKey("AIzaSyAVAEwf8eLJ8yMZtX1NndYSuBWeqrEvEco")
       // GMSPlacesClient.provideAPIKey("AIzaSyAVAEwf8eLJ8yMZtX1NndYSuBWeqrEvEco") //needed if we return to places API
        
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

