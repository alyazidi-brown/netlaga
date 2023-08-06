//
//  EventController.swift
//  Netlaga
//
//  Created by Scott Brown on 08/07/2023.
//



import EventKit
import EventKitUI
import UIKit


protocol chatResetDelegate: AnyObject {
    func chatReset(discoverySetUp: DiscoveryStruct, event: Bool)
}


class EventViewController: EKEventViewController, EKEventViewDelegate {
  
    
    weak var chatDelegate: chatResetDelegate?
    var isServicePay = false
    var isDirectlyPay = false
    var overallDate = Date()
    let datetimeFormatter = DateFormatter()
    
    var inviteDateString : String = ""
    var inviteTimeString : String = ""
    var inviteTitle: String = ""
    
    var discoverySetUp = DiscoveryStruct(firstName: "", email: "", ava: "", uid: "", place: "", token: "")
   
    
   let store = EKEventStore()
    
    var calendars: [EKCalendar]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //didTappAdd()
        
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
            spinningActivity.label.text = "Loading.  Please wait."
        spinningActivity.detailsLabel.text = ""
        
            if (self.view.frame.width > 414) {
                
                //spinningActivity.frame = CGRect(x: self.view.frame.width/2 - 100, y: 300, width: 200, height: 250)
                spinningActivity.minSize = CGSize(width:200, height: 250);
                
                spinningActivity.label.font = UIFont(name: "Helvetica", size:20)
                
                spinningActivity.detailsLabel.font = UIFont(name: "Helvetica", size:18)//label.font = UIFont(name: "Helvetica", size:18)
                
                
            }else{
                
                
                
                
            }
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (nil) in
                // Your code here
            
            //NavigationManager.goToMainStoryboard()
            
            DispatchQueue.main.async {
                
                
                MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

                UIApplication.shared.endIgnoringInteractionEvents()
                
                
            }
            
            
            self.generateEvent()
            
            }
      
        
        
    }
    
    
    
    
        func generateEvent() {
            let status = EKEventStore.authorizationStatus(for: EKEntityType.event)

            switch (status)
            {
            case EKAuthorizationStatus.notDetermined:
                // This happens on first-run
                requestAccessToCalendar()
            case EKAuthorizationStatus.authorized:
                // User has access
                print("User has access to calendar")
            let alertController = UIAlertController(title: "Invite Event", message: "Would you like to save the invite date in the calendar?", preferredStyle: .alert)

                    // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                
                var myToken : String = ""
                
                print("what!?5")
                
                if UserDefaults.standard.value(forKey: "token") != nil {
                    
                    print("what!?6")
                 
                    myToken = UserDefaults.standard.value(forKey: "token") as! String
                    
                    print("what!?7")
                    
                    print("my token is \(myToken)")
                    
                    UserService.uploadInvite(discoverySetUp: self.discoverySetUp, body: "\(self.discoverySetUp.firstName)'s invite to \(self.inviteTitle) on \(self.inviteDateString) at \(self.inviteTimeString)", title: "Invitation Reminder", token: myToken, date: self.inviteDateString, time: self.inviteTimeString) { status in
                        
                        if status == "sent" {
                            
                            self.addAppleEvents()
                            
                            
                        }
                    }
                    
                }
        
                    }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                        UIAlertAction in
                
                self.view.window?.rootViewController?.dismiss(animated: true) {
                    
                    print("invite 1")
                    self.chatDelegate?.chatReset(discoverySetUp: self.discoverySetUp, event: true)
                    
                }
                        
                //self.view.removeFromSuperview()
                //NavigationManager.goToMainStoryboard()
                    }

                    // Add the actions
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)

                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
            
            case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
                // We need to help them give us permission
                noPermission()
            @unknown default:
                print("error")
            }
        }
    
    
    func noPermission()
        {
            print("User has to change settings...go to settings to view access")
        
        let alertController = UIAlertController(title: "Event not saved to calendar.", message: "You've decided not to save the event to the calendar", preferredStyle: .alert)

                // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
            
            //NavigationManager.goToMainStoryboard()
    
                }

                // Add the actions
                alertController.addAction(okAction)
                

                // Present the controller
                self.present(alertController, animated: true, completion: nil)
        }
    
    
    
    
        func requestAccessToCalendar() {
            self.store.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    DispatchQueue.main.async {
                        print("User has access to calendar")
                            // Create the alert controller
                            let alertController = UIAlertController(title: "Invite Event", message: "Would you like to save the invite date in the calendar?", preferredStyle: .alert)

                                    // Create the actions
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                        UIAlertAction in
                                        NSLog("OK Pressed")
                                
                                var myToken : String = ""
                                
                                print("what!?5")
                                
                                if UserDefaults.standard.value(forKey: "token") != nil {
                                    
                                    print("what!?6")
                                 
                                    myToken = UserDefaults.standard.value(forKey: "token") as! String
                                    
                                    print("what!?7")
                                    
                                    print("my token is \(myToken)")
                                    
                                    UserService.uploadInvite(discoverySetUp: self.discoverySetUp, body: "\(self.discoverySetUp.firstName)'s invite to \(self.inviteTitle) on \(self.inviteDateString) at \(self.inviteTimeString)", title: "Invitation Reminder", token: myToken, date: self.inviteDateString, time: self.inviteTimeString) { status in
                                        
                                        if status == "sent" {
                                            
                                            self.addAppleEvents()
                                            
                                            
                                        }
                                    }
                                    
                                }
                                
                                
                        
                                    }
                            let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                                        UIAlertAction in
                                
                                self.view.window?.rootViewController?.dismiss(animated: true) {
                                    
                                    print("invite 1")
                                    self.chatDelegate?.chatReset(discoverySetUp: self.discoverySetUp, event: true)
                                    
                                }
                                        
                                //self.view.removeFromSuperview()
                                //NavigationManager.goToMainStoryboard()
                                    }

                                    // Add the actions
                                    alertController.addAction(okAction)
                                    alertController.addAction(cancelAction)

                                    // Present the controller
                                    self.present(alertController, animated: true, completion: nil)
                        
                    }
                } else {
                    DispatchQueue.main.async{
                        self.noPermission()
                    }
                }
            })
        }
    
    
        func addAppleEvents()
        {
            let event:EKEvent = EKEvent(eventStore: self.store)
        
        print("Saved Event - 1")
        
        let dateString = "\(inviteDateString) \(inviteTimeString)"
        
        print("Saved Event -2 \(dateString)")
        
      
        
        self.datetimeFormatter.dateFormat = "dd MMM yyyy h:mm a"//"MM/dd/yyyy HH:mm"//"MMM dd, yyyy h:mm a"
            
           // self.datetimeFormatter.locale = NSLocale.system
        
        print("Saved Event - 3")
        
        
        let dateHolder = self.datetimeFormatter.date(from: dateString)
        
        print("Saved Event - 4")
        
        
        if dateHolder != nil {
            
            print("Saved Event - 5")
        
            event.startDate = dateHolder!
            
           event.endDate = dateHolder!
            
            
        }
         
            event.title = "\(discoverySetUp.firstName)'s Invite"//EventStruct.serviceTitle
        
        print("Saved Event - 6")
    
        event.notes = "\(discoverySetUp.firstName)'s invite to \(inviteTitle)"
    
    event.calendar = self.store.defaultCalendarForNewEvents

            do {
                print("Saved Event - 7")
                try self.store.save(event, span: .thisEvent)
                //self.presentAlertController(withTitle: "Success!", message: "Event successfully saved to calendar")
                
                let alert = UIAlertController(title: "Success!", message: "Event successfully saved to calendar", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                    let vc = EKEventViewController()
                    vc.delegate = self
                    vc.event = event
                                                                   
                       let navVC = UINavigationController(rootViewController: vc)
                                                                  
                    self.present(navVC, animated: true)
                   
                    }
                }))
                self.present(alert, animated: true, completion: nil)
                print("events added with dates:")
            } catch let e as NSError {
                self.presentAlertController(withTitle: "Error occured while trying to save to calendar", message: "\(e.description)")
                print(e.description)
                return
            }
            print("Saved Event")
        
        //NavigationManager.goToMainStoryboard()
        
        /*
         DispatchQueue.main.async {
         let vc = EKEventViewController()
         vc.delegate = self
         vc.event = event
                                                        
            let navVC = UINavigationController(rootViewController: vc)
                                                       
         self.present(navVC, animated: true)
        
         }
         */
         
        }
    
    
    
    
    
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
       
        //self.dismiss(animated: true){
        
        self.view.window?.rootViewController?.dismiss(animated: true) {
            
            //self.navigationController?.popToRootViewController(animated: true)
            
            print("invite 1")
            self.chatDelegate?.chatReset(discoverySetUp: self.discoverySetUp, event: true)
            
        }
            
        //}
        
        /*
        if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            scene.rootViewController
        }
         */
        
        //self.navigationController?.popViewController(animated: true)
                
                
            
        //self.dismiss(animated: true)
        
        //Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (nil) in
                // Your code here
            
            //NavigationManager.goToMainStoryboard()
          
            
           // }
        /*
        let vc = ChatViewController(recipientId: discoverySetUp.uid, recipientName: discoverySetUp.firstName)//ChatController(discoverySetUp: matchInfo) //your view controller
        vc.discoverySetUp = discoverySetUp
        //vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .overFullScreen
        
        
        
        self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.show(vc, sender: self)
         
         */
         
        
    }
    
    
   
        
}


