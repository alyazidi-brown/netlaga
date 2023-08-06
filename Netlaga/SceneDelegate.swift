//
//  SceneDelegate.swift
//  Netlaga
//
//  Created by Scott Brown on 3/22/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FirebaseDynamicLinks
     
    

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        if let urlContext = connectionOptions.urlContexts.first {

               let sendingAppID = urlContext.options.sourceApplication
               let url = urlContext.url
               print("source application = \(sendingAppID ?? "Unknown")")
               print("url = \(url)")

               // Process the URL similarly to the UIApplicationDelegate example.
           }
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemPurple
        //window.makeKeyAndVisible()
        
        
        
        let vc = NotificationsController()//LocationServicesController()//RegistrationViewController()//InputViewController()
        
        window.rootViewController = vc
        
       /*
        if Auth.auth().currentUser != nil {//&& Auth.auth().currentUser!.isEmailVerified {
            
            let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
            
            ref.observeSingleEvent(of: .value, with: { snapshot in
                
                
                if snapshot.exists() {
                   
                    let vc = HomeTabBarController()//RegistrationViewController()//InputViewController()
                    vc.view.backgroundColor = .white
                    
                    window.rootViewController = vc
                    
                } else {
                    
                    let user = Auth.auth().currentUser

                    user?.delete { error in
                      if let error = error {
                        // An error happened.
                      } else {
                        // Account deleted.
                          
                          print("you should hit the login")
                                      
                          let vc = LogInViewController()//RegistrationViewController()//InputViewController()
                          vc.view.backgroundColor = .white
                          window.rootViewController = vc
                      }
                    }
                    
                }
                
                    })
        
            
       // if Auth.auth().currentUser == nil{
        
        } else {
            
            print("you should hit the login")
                        
            let vc = LogInViewController()//RegistrationViewController()//InputViewController()
            vc.view.backgroundColor = .white
            window.rootViewController = vc
            
            
        }
       
        */
        
        
        
        
        /*
        let vc = LogInViewController()//HomeTabBarController()//EmailViewController()//PhoneViewController()//RegistrationViewController()//InputViewController()
        vc.view.backgroundColor = .white
        window.rootViewController = vc
        
       
        if Auth.auth().currentUser == nil{
        
        let vc = PhoneViewController()//RegistrationViewController()//InputViewController()
        vc.view.backgroundColor = .white
        window.rootViewController = vc
            
            
        } else {
            
            window.rootViewController = AccountViewController()
        }
        
        
         
         */
        

        window.makeKeyAndVisible()
        self.window = window

    }
        
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
                    
            if let incomingURL = userActivity.webpageURL {
                
                print("\n \nIncoming URL is \(incomingURL)")
                
                _ = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                    
                    guard error == nil else {
                        print("\n \nError with handling incoming URL: \(error!.localizedDescription)")
                        return
                    }
                    
                    if let dynamicLink = dynamicLink {
                        
                        guard let url = dynamicLink.url else {
                            print("\n \nDynamic link object has no url")
                            return
                        }
                        
                        print("\n \nIncoming link parameter is \(url.absoluteString)")
                        
                        let link = url.absoluteString
                        
                        if Auth.auth().isSignIn(withEmailLink: link) {
                            
                            // Send notification to trigger the rest of the sign in sequence
                            NotificationCenter.default.post(name: Notification.Name("Success"), object: nil, userInfo: ["link": link])
                            
                        } else {
                            
                            // Send error notification
                            NotificationCenter.default.post(name: Notification.Name("Error"), object: nil, userInfo: nil)
                            
                        }
                        
                    }
                    
                }
            }
        }

    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

@available(iOS 13.0, *)
extension SceneDelegate {
    static var shared: SceneDelegate {
        return UIApplication.shared.delegate as! SceneDelegate
    }
    
    var rootViewController: InputViewController {
        return window!.rootViewController as! InputViewController
    }
}


