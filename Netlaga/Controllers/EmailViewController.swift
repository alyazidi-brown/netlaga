//
//  EmailViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/2/22.
//

import UIKit
import Firebase
import FirebaseAuth
import MessageUI
import SwiftUI


class EmailViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    private let emailField: UITextField = {
        
      let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "Email"
        field.returnKeyType = .continue
        field.textAlignment = .center
        return field
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white//.systemBackground
        
        let circleView = ContentView()
                let controller = UIHostingController(rootView: circleView)
                addChild(controller)
                controller.view.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(controller.view)
                controller.didMove(toParent: self)

                NSLayoutConstraint.activate([
                    controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                    controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                    controller.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                    controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
                ])
        /*
        view.addSubview(emailField)
        emailField.frame = CGRect(x:0, y:0, width: 220, height: 50)
        emailField.center = view.center
        emailField.delegate = self
         */
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            
            let number = text
            
            User.email = number
            
            let actionCodeSettings = ActionCodeSettings()
            actionCodeSettings.url = URL(string: "https://datingappnew.page.link/open2")
            // The sign-in operation has to always be completed in the app.
            actionCodeSettings.handleCodeInApp = true
            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
            actionCodeSettings.setAndroidPackageName("com.example.android",
                                                     installIfNotAvailable: false, minimumVersion: "12")
            
            
            Auth.auth().sendSignInLink(toEmail: number,
                                       actionCodeSettings: actionCodeSettings) { error in
                
                print("action code settings \(actionCodeSettings)")
              // ...
                if let error = error {
                  //self.showMessagePrompt(error.localizedDescription)
                  // create the alert
                          let alert = UIAlertController(title: "My Title", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                          // add an action (button)
                          alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                              print("Handle Ok logic here")
                            
                              }))

                          // show the alert
                          self.present(alert, animated: true, completion: nil)
                  return
                }
                // The link was successfully sent. Inform the user.
                // Save the email locally so you don't need to ask the user for it again
                // if they open the link on the same device.
                UserDefaults.standard.set(number, forKey: "Email")
                    //self.showMessagePrompt("Check your email for link")
                let alert = UIAlertController(title: "Check your email for link", message: number, preferredStyle: UIAlertController.Style.alert)

              
                
                 alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                    
                    
                    let recipientEmail = number
                                let subject = "Multi client email support"
                                let body = "This code supports sending email via multiple different email apps on iOS! :)"
                                
                                // Show default mail composer
                                if MFMailComposeViewController.canSendMail() {
                                    let mail = MFMailComposeViewController()
                                    mail.mailComposeDelegate = self
                                    mail.setToRecipients([recipientEmail])
                                    mail.setSubject(subject)
                                    mail.setMessageBody(body, isHTML: false)
                                    
                                    self.present(mail, animated: true)
                                
                                // Show third party email composer if default Mail app is not present
                                } else if let emailUrl = self.createEmailUrl(to: recipientEmail, subject: subject, body: body) {
                                    UIApplication.shared.open(emailUrl)
                                }
                    
                     
                    }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                      print("Handle Cancel Logic here")
                }))
                 

                // show the alert
                self.present(alert, animated: true, completion: nil)
                // ...
            }
            
        }
        return true
        
        /*
         if Auth.auth().isSignIn(withEmailLink: link) {
         AppDelegate.swift

                 Auth.auth().signIn(withEmail: email, link: self.link) { user, error in
                   // ...
                 }
         PasswordlessViewController.swift

         }
         */
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
                let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                
                let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
                let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
                let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
                let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
                let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
                
                if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
                    return gmailUrl
                } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
                    return outlookUrl
                } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
                    return yahooMail
                } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
                    return sparkUrl
                }
                
                return defaultUrl
            }
            
            func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                controller.dismiss(animated: true)
            }


}

