//
//  EmailScreen2.swift
//  Netlaga
//
//  Created by Scott Brown on 25/05/2023.
//https://stackoverflow.com/questions/55738109/firebase-passwordless-email-authentication-doesnt-open-app-on-ios
//https://firebase.google.com/docs/auth/ios/account-linking

import SwiftUI
import FirebaseAuth
import MessageUI
import FirebaseDynamicLinks
import Alamofire

var hostingController: (UIHostingController<ContentView>)? = nil
/// Main view where user can login in using Email Link Authentication.
struct ContentView: View {
  @State private var email: String = ""
  @State private var isPresentingSheet = false
    @State var signUp: Bool = false
    @State var showAlert = false
    //@State var forcedSignUp = false
    @State var signInAlert = false
    @State var isLoading = false
    
    
    var dismiss: (() -> Void)?
    
    var dismissAction: (() -> Void)
    
    @EnvironmentObject private var signUpTwo: NameScreenData

  /// This property will cause an alert view to display when it has a non-null value.
  @State private var alertItem: AlertItem? = nil

  var body: some View {
    NavigationView {
        VStack(alignment: .center) {
            Text("Authenticate users with only their email, no password required!")
                .padding(.bottom, 60)
            
            CustomStyledTextField(
                text: $email, placeholder: "Email", symbolName: "person.circle.fill"
            )
            
           
            
            CustomStyledButton(title: "Send Sign In Link", action: {
                
                isLoading = true
                
                emailTest(email: email) { uid in
                    
                    authTest(uidString: uid) { phoneNumber in
                        
                        print("phone and uid \(phoneNumber) \(uid) \(signUp)")
                        
                        print("forced sign up1 \(signUpTwo.forcedSignUp)")
                        
                        if phoneNumber == "" && signUp == false {
                            
                            isLoading = false
                            
                            signInAlert = true
                           
                            
                        } else {
                            
                            isLoading = false
                            
                       
                            sendSignInLink()
                            
                        }
                    }
                }
                
            })
            

            .disabled(email.isEmpty)
            
            BackButton(title: "Go Back", action: dismissAction)
            
            if isLoading {
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                    .frame(width: 120, height: 120, alignment: .center)
                    .scaleEffect(3)
                
            }
          
            Spacer()
            
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Easy frictionless sign up with email!"), message: Text("Instructions: Enter e-mail in textfield.  Press 'Send Sign In Link'.  You will be redirected to email app.  Check inbox, spam, or junk then press the link in the email"))
                }
            
        }
    
        .onAppear{
                  showAlert = true
                }
      .padding()
      .navigationBarTitle("Passwordless Login")
      
    }.onReceive(NotificationCenter.default.publisher(for: Notification.Name("Success"))) { notificationInfo in

        
        if let userInfo = notificationInfo.userInfo {
            if let link = userInfo["link"] as? String {
                
              
                            
                            print("the link \(link)")
                            if Auth.auth().isSignIn(withEmailLink: link) {
                                print("the link 2 \(link)")
                                passwordlessSignIn(email: email, link: link) { result in
                                    switch result {
                                    case let .success(user):
                                        print("the link 3 \(link)")
                                        UserTwo.email = email
                                        isPresentingSheet = user?.isEmailVerified ?? false
                                    case let .failure(error):
                                        isPresentingSheet = false
                                        alertItem = AlertItem(
                                            title: "An authentication error occurred.",
                                            message: error.localizedDescription
                                        )
                                    }
                                }
                            }
                            
                         
            }
        }
    }
    
    
    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Error"))) { _ in
        //do something with error
        alertItem = AlertItem(
          title: "Can't authenticate.",
          message: "Error"//error.localizedDescription
        )
    }.fullScreenCover(isPresented: $isPresentingSheet) {
        //SuccessView(email: email)
        //print("2nd sign up \(signUp)")
        
        
        
        //emailTest(email: email)
        
        if signUpTwo.forcedSignUp == false {
            
            if signUpTwo.signUp == true {
                
                MyView(signUp: signUpTwo.signUp)
                
            } else {
                
                
                OtherView(signUp: signUpTwo.signUp)
                
                
            }
            
        } else {
            
            LogInView()
            
        }
        
        
      }
      
    .alert("User does not exist", isPresented: $signInAlert, actions: { // 2
        
        Button("Go To Log In Page?", role: .destructive, action: {
            alertStuff()
        })

        // 3
        Button("Cancel", role: .cancel, action: {})

    }, message: {
        // 4
        Text("Please sign up.")

    })
    
      
    //.onAppear{ startFakeNetworkCall() }
     
     
  }
    
    private func dismissFunc() {
        
        print("dismiss email")
        
        hostingController?.dismiss(animated: true)
    }
    
    func alertStuff() {
     
        signUpTwo.forcedSignUp = true
        
        print("forced sign up2 \(signUpTwo.forcedSignUp)")
        
        isPresentingSheet = true
        
    }

  // MARK: - Firebase 🔥

  private func sendSignInLink() {
        
                  let actionCodeSettings = ActionCodeSettings()
                  actionCodeSettings.url = URL(string: "https://datingappnew.page.link/open2")
                  actionCodeSettings.handleCodeInApp = true
                  actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
                  
                  let mailURL = URL(string: "message://")!
                  if UIApplication.shared.canOpenURL(mailURL) {
                      UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
                  }
                  
                  Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
                      if let error = error {
                          alertItem = AlertItem(
                            title: "The sign in link could not be sent.",
                            message: error.localizedDescription
                          )
                      }
                  }
        
  }
    
    func sendSignLink(email: String) async {//async throws {
            
        do {
                let actionCodeSettings = ActionCodeSettings()
                actionCodeSettings.url = URL(string: "https://datingappnew.page.link/open2")
                actionCodeSettings.handleCodeInApp = true
                actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
                
                try await Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
                UserDefaults.standard.set(email, forKey: "email")
            
            let mailURL = URL(string: "message://")!
               if UIApplication.shared.canOpenURL(mailURL) {
                   UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
                }
            }
            catch {
                //throw error
            }
            
        }
    

  private func passwordlessSignIn(email: String, link: String,
                                  completion: @escaping (Result<User?, Error>) -> Void) {
    Auth.auth().signIn(withEmail: email, link: link) { result, error in
      if let error = error {
        print("ⓧ Authentication error: \(error.localizedDescription).")
        completion(.failure(error))
      } else {
        print("✔ Authentication was successful.")
        completion(.success(result?.user))
      }
    }
  }
    
    
    
    func signInWithEmail(email: String, link: String) async throws {
        
        do {
            let email = UserDefaults.standard.value(forKey: "email")
            try await Auth.auth().signIn(withEmail: email as! String, link: link)
        }
        catch {
            throw error
        }
        
    }
    
    func startFakeNetworkCall() {
        
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            
            isLoading = false
        }
        
        
    }
    
    func emailTest (email: String, completion: @escaping(String) -> Void) {
        
        let parameters: [String:Any] = ["email": email]
        
        let url = "https://us-central1-datingapp-80400.cloudfunctions.net/emailExists"
                
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
                    
            
               //print("response \(response)")
                    switch response.result {
                        
                        
                        case .success(let dict):
                        
                        
                        let successDict: [String: Any?] = dict as? [String: Any?] ?? [:]
                        
                        
                        let email = successDict["email"] as? String ?? ""
                        let emailVerified = successDict["emailVerified"] as? Int ?? 0
                        let uid = successDict["uid"] as? String ?? ""
                        
                        completion(uid)
                            
                        print("email emailverified uid \(email) \(emailVerified) \(uid)")
                       
                           
                        case .failure(let error):
                        //print("delete here7 \(error.localizedDescription)")
                        completion("")
                           
                        print(error.localizedDescription)
                            //completion(nil, error.localizedDescription)
                    }
                }
    }
    
    func authTest (uidString: String, completion: @escaping(String) -> Void){
        
        print("auth uid \(uidString)")
        
        let parameters: [String:Any] = ["uid": uidString]
        
        let url = "https://us-central1-datingapp-80400.cloudfunctions.net/authExists"
                
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
                    
            
               print("response \(response)")
            switch response.result {
                
                
            case .success(let dict):
                
                
                let successDict: [String: Any?] = dict as? [String: Any?] ?? [:]
                
                
                let email = successDict["email"] as? String ?? ""
                let emailVerified = successDict["emailVerified"] as? Int ?? 0
                let uid = successDict["uid"] as? String ?? ""
                let phoneNumber = successDict["phoneNumber"] as? String ?? ""
                
                
              completion(phoneNumber)
                            
                        print("dict \(dict)")
                       
                           
                        case .failure(let error):
                        print("delete here5 \(error.localizedDescription)")
                
                            completion("")
                           
                            print(error.localizedDescription)
                            //completion(nil, error.localizedDescription)
                    }
                }
    }
}

/// Model object for an `Alert` view.
struct AlertItem: Identifiable {
  var id = UUID()
  var title: String
  var message: String
}

struct AlertItemTwo: Identifiable {
  var id = UUID()
  var title: String
  var message: String
}


/// A custom styled TextField with an SF symbol icon.
struct CustomStyledTextField: View {
  @Binding var text: String
  let placeholder: String
  let symbolName: String

  var body: some View {
    HStack {
      Image(systemName: symbolName)
        .imageScale(.large)
        .padding(.leading)

      TextField(placeholder, text: $text)
        .padding(.vertical)
        .accentColor(.orange)
        .autocapitalization(.none)
    }
    .background(
      RoundedRectangle(cornerRadius: 16.0, style: .circular)
        .foregroundColor(Color(.secondarySystemFill))
    )
  }
}

/// A custom styled button with a custom title and action.
struct CustomStyledButton: View {
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      /// Embed in an HStack to display a wide button with centered text.
      HStack {
        Spacer()
        Text(title)
          .padding()
          .accentColor(.white)
          .foregroundColor(.blue)
        Spacer()
      }
    }
    .background(Color.orange)
    .cornerRadius(16.0)
  }
}

struct BackButton: View {
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      /// Embed in an HStack to display a wide button with centered text.
      HStack {
        Spacer()
        Text(title)
          .padding()
          .accentColor(.white)
          .foregroundColor(.blue)
        Spacer()
      }
    }
    .background(Color.orange)
    .cornerRadius(16.0)
  }
}

struct MyView: UIViewControllerRepresentable {
    let signUp: Bool
    
    typealias UIViewControllerType = PhoneViewController//InputViewController
    
    func makeUIViewController(context: Context) -> PhoneViewController {
        
            let vc = PhoneViewController()//InputViewController()
            print("3rd sign up \(signUp)")
            vc.signUp = signUp
            vc.modalPresentationStyle = .overFullScreen
            //vc.modalTransitionStyle = .coverVertical
            // Do some configurations here if needed.
            return vc
            
        
    }
    
    func updateUIViewController(_ uiViewController: PhoneViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}

struct OtherView: UIViewControllerRepresentable {
    let signUp: Bool
    
    typealias UIViewControllerType = HomeTabBarController//InputViewController
    
    func makeUIViewController(context: Context) -> HomeTabBarController {
        
            let vc = HomeTabBarController()//InputViewController()
            print("3rd sign up \(signUp)")
        
           // UIApplication.shared.windows.first?.rootViewController = vc
            //UIApplication.shared.windows.first?.makeKeyAndVisible()
    
            vc.modalPresentationStyle = .overFullScreen
            
            return vc
            
        
    }
    
    func updateUIViewController(_ uiViewController: HomeTabBarController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}

struct LogInView: UIViewControllerRepresentable {
    //let signUp: Bool
    
    typealias UIViewControllerType = LogInViewController//InputViewController
    
    func makeUIViewController(context: Context) -> LogInViewController {
        
            let vc = LogInViewController()//InputViewController()
            //print("3rd sign up \(signUp)")
        
           
    
            vc.modalPresentationStyle = .overFullScreen
            
            return vc
            
        
    }
    
    func updateUIViewController(_ uiViewController: LogInViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}



/// Displayed when a user successfuly logs in.
struct SuccessView: View {
  let email: String

  var body: some View {
    /// The first view in this `ZStack` is a `Color` view that expands
    /// to set the background color of the `SucessView`.
    ZStack {
      Color.orange
        .edgesIgnoringSafeArea(.all)

      VStack(alignment: .leading) {
        Group {
          Text("Welcome")
            .font(.largeTitle)
            .fontWeight(.semibold)

          Text(email.lowercased())
            .font(.title3)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
        }
        .padding(.leading)

        Image(systemName: "checkmark.circle")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .scaleEffect(0.5)
      }
      .foregroundColor(.white)
    }
  }
}



/*
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView(dismissAction: {self.dismiss( animated: true, completion: nil )})
  }
}
 */

class NameScreenData: ObservableObject {
    
    @Published var signUp: Bool = false
    @Published var forcedSignUp: Bool = false
}

