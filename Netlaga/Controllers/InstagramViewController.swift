//
//  InstagramViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/6/22.
//

import UIKit
import WebKit
class InstagramViewController: UIViewController, WKUIDelegate {
 
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [API.INSTAGRAM_AUTHURL,API.INSTAGRAM_CLIENT_ID,API.INSTAGRAM_REDIRECT_URI, API.INSTAGRAM_SCOPE])
        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
    
        //webView.delegate = self
        webView.load(urlRequest)
    }
    
    func setupUI() {
            self.view.backgroundColor = .white
            self.view.addSubview(webView)
            
            NSLayoutConstraint.activate([
                webView.topAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                webView.leftAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                webView.bottomAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                webView.rightAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
            ])
        }
 
    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }
 
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(API.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    func handleAuth(authToken: String) {
        API.INSTAGRAM_ACCESS_TOKEN = authToken
        print("Instagram authentication token ==", authToken)
        getUserInfo(){(data) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
           
        }
    }
    func getUserInfo(completion: @escaping ((_ data: Bool) -> Void)){
        let url = String(format: "%@%@", arguments: [API.INSTAGRAM_USER_INFO,API.INSTAGRAM_ACCESS_TOKEN])
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard error == nil else {
                 completion(false)
                //failure
                return
            }
            // make sure we got data
            guard let responseData = data else {
                completion(false)
                 //Error: did not receive data
                return
            }
            do {
                guard let dataResponse = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: AnyObject] else {
                        completion(false)
                        //Error: did not receive data
                        return
                }
                completion(true)
                // success (dataResponse) dataResponse: contains the Instagram data
            } catch let err {
                completion(false)
                //failure
            }
        })
        task.resume()
    }
}
 
extension InstagramViewController: UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
}
extension InstagramViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if checkRequestForCallbackURL(request: navigationAction.request){
            decisionHandler(.allow)
        }else{
            decisionHandler(.cancel)
        }
    }
}
 
struct API{
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_USER_INFO = "https://api.instagram.com/v1/users/self/?access_token="
    static let INSTAGRAM_CLIENT_ID = "389559919771217"
    static let INSTAGRAM_CLIENTSERCRET = "c390f1b252e9f3465818cc38a97dda90"
    static let INSTAGRAM_REDIRECT_URI = ""//"https://XXXXX"
    static var INSTAGRAM_ACCESS_TOKEN = "IGQVJXbllMMVVicXU2emxtM2p1WkFZAd2hab3ZARSXVvM25vRVhWMDJoQUx5N2hRNEZAVT1JqcFFBXzlLMUFWLXVFMEpvRFR4V3c4WjM4R3drdmtkeXpzY3FrbnhFSWVsRzk5RUYxcUgzekhpem9TSWZAIMAZDZD"
    static let INSTAGRAM_SCOPE = "follower_list+public_content" /* add whatever scope you need https://www.instagram.com/developer/authorization/ */
}
