//
//  CommentViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 3/10/23.
//

import Foundation


import UIKit
import Alamofire
import FirebaseAuth


class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {


   
    
    var commentsArray : [CommentsModel] = []
    
    private var myTableView: UITableView!
    
    var txtView = UITextView()
    
    private let dismissButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        // 2. check the idiom
        switch (deviceIdiom) {

        case .pad:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
            //print("iPad style UI")
        case .phone:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
           // print("iPhone and iPod touch style UI")
       // case .tv:
           // print("tvOS style UI")
        default:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
           // print("Unspecified UI idiom")
        }
        
        return button
    }()
    
    var post_id : Int = 0
    
    var commentButton = UIButton()

override func viewDidLoad() {
    super.viewDidLoad()
    print("how far comment1")
    
    txtView.textColor = .black//lightGray
    txtView.text = "Comment here..."
    txtView.autocapitalizationType = .words
    txtView.isScrollEnabled = false
    
    view.backgroundColor = UIColor.black.withAlphaComponent(0.6)//UIColor.black.withAlphaComponent(0.6)
    
    let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
    let displayWidth: CGFloat = self.view.frame.width
    let displayHeight: CGFloat = self.view.frame.height
    
    txtView = UITextView(frame: CGRect(x: 20, y: 100, width: displayWidth - 40, height: 100))
    
    self.view.addSubview(txtView)
    
    txtView.backgroundColor = .white
    
    //commentButton = UIButton(frame: CGRect(x: displayWidth - 80, y: 205, width: 40, height: 40))
    self.view.addSubview(commentButton)
    commentButton.setTitleColor(UIColor.green, for: .normal)
    commentButton.translatesAutoresizingMaskIntoConstraints = false
    commentButton.setTitle("Button Clicked", for: .normal)
    commentButton.backgroundColor = UIColor.brown
    commentButton.addTarget(self, action: #selector(loadPost), for: .touchUpInside)
    
    commentButton.rightAnchor.constraint(equalTo: txtView.rightAnchor).isActive = true
    commentButton.topAnchor.constraint(equalTo: txtView.bottomAnchor).isActive = true
    commentButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    commentButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    

    myTableView = UITableView(frame: CGRect(x: 20, y: 250, width: displayWidth - 40, height: displayHeight - 450))
    myTableView.register(TimeLineCell.self, forCellReuseIdentifier: "TimeLineCell")
    myTableView.dataSource = self
    myTableView.delegate = self
    self.view.addSubview(myTableView)
    
    myTableView.backgroundColor = .white
    
    /*
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
    self.view.addGestureRecognizer(panGestureRecognizer)
     */
    
    view.addSubview(dismissButton)
    dismissButton.anchor(left: txtView.leftAnchor, bottom: txtView.topAnchor, paddingLeft: 0, paddingBottom: 10, width: 0.5*view.frame.width, height: 50)
    
    
    loadComments()
    
}
    
    @objc func backAction() {
        
        print("dismiss comment")
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if txtView.textColor == UIColor.darkGray && txtView.isFirstResponder {
            txtView.text = nil
            txtView.textColor = .black//white
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if txtView.text.isEmpty || txtView.text == "" {
            txtView.textColor = .darkGray
            txtView.text = "Comment here..."
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("how far comment2")
        
        if let touch = touches.first {
            let position :CGPoint = touch.location(in: view)
            print("the position \(position)")
            if position.y < txtView.bounds.origin.y || position.y > txtView.bounds.origin.y + myTableView.bounds.height + txtView.bounds.height + commentButton.bounds.height + 10 || position.x < myTableView.bounds.origin.x || position.x > myTableView.bounds.origin.x + myTableView.bounds.width {
                
                print("how far comment3")
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    
    @objc func panGestureRecognizerAction(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        
        
        view.frame.origin  = translation
        
        if gesture.state == .ended {
            
            let velocity = gesture.velocity(in: view)
            
            if velocity.y >= 1500 {
                print("how far comment4")
                self.dismiss(animated: true, completion: nil)
                
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame.origin = CGPoint(x:0, y:0)
                })
                
            }
            
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Num: \(indexPath.row)")
            print("Value: \(commentsArray[indexPath.row])")
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return commentsArray.count
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0;//Choose your custom row height
    }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell", for: indexPath) as! TimeLineCell
            
            cell.contentView.backgroundColor = .white
            
            let commentValues = commentsArray[indexPath.row]
            cell.postName.text = commentValues.firstName
            cell.postText.text = commentValues.text
            
            cell.postText.textColor = .black
            cell.postText.backgroundColor = .white
            
            
            let dateText = commentValues.date_created
            
           
            
            let dateFormatterGet2 = DateFormatter()
            dateFormatterGet2.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let date2 = dateFormatterGet2.date(from: dateText) ?? Date()
            
                // Create Date Formatter
                let dateFormatter = DateFormatter()

                // Set Date Format
                dateFormatter.dateFormat = "MMM d,YYYY"

                // Convert Date to String
            cell.postDate.text = dateFormatter.string(from: date2)
            
            cell.postDate.textAlignment = .right
            
            cell.profileImageView.image = UIImage(named: "Post.png")
            
            let imageUrl = URL(fileURLWithPath: commentValues.ava)
            
            
            AF.request( commentValues.ava,method: .get).response{ response in

               switch response.result {
                case .success(let responseData):
                   cell.profileImageView.image = UIImage(data: responseData!, scale:1)

                case .failure(let error):
                    print("error--->",error)
                }
            }
            
            cell.contentView.addSubview(cell.profileImageView)
         
            cell.profileImageView.anchor(top: cell.contentView.topAnchor, left: cell.contentView.leftAnchor, paddingTop: 0, paddingLeft: 0, width: 40, height: 40)
            
            cell.profileImageView.layer.borderWidth = 1
            cell.profileImageView.layer.masksToBounds = false
            cell.profileImageView.layer.borderColor = UIColor.black.cgColor
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
            cell.profileImageView.clipsToBounds = true
            
            cell.contentView.addSubview(cell.postName)
         
            cell.postName.anchor(top: cell.contentView.topAnchor, left: cell.profileImageView.rightAnchor, right: cell.contentView.centerXAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 40)
            
            cell.contentView.addSubview(cell.postDate)
         
            cell.postDate.anchor(top: cell.contentView.topAnchor, left: cell.postName.rightAnchor, right: cell.contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 40)
            
            
            cell.contentView.addSubview(cell.postText)
            
            cell.postText.anchor(top: cell.postName.bottomAnchor, left: cell.contentView.leftAnchor, bottom: cell.contentView.bottomAnchor, right: cell.contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
            
           
            
            return cell
        }
    
    func loadComments() {
        
        
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }


        let url:URL = URL(string: "https://netlaga.net/comments.php")!
        let session = URLSession.shared

        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData




        let paramString: String = "post_id=\(post_id)&user_id=\(currentUid)&type=load&limit=15&offset=1"


        print("param stuff \(paramString)")

        request.httpBody = paramString.data(using: String.Encoding.utf8)


    //STEP 2.  Execute created above request.
    let task = session.dataTask(with: request as URLRequest, completionHandler: {
        (data, response, error) in
        let helper = Helper()
        
        guard let _:Data = data, let _:URLResponse = response  , error == nil
            
            else {
                //print("error")
                if error != nil {
                    
                    helper.showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                }
                return
        }
        
       let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
       // var dataString = NSString(data: data!, encoding: CFStringConvertEncodingToNSStringEncoding(0x0422))
                
        print("YOU THERE ESSAY load comments \(dataString)")
        
        var dataEncoded : NSString = ""
        
        dataEncoded = dataString ?? ""
        
        switch dataEncoded {
        case "":
            print("Bring an umbrella")
            
            DispatchQueue.main.async
            {
                
                self.commentsArray = []
                
                self.myTableView.reloadData()
                
            }
            
        default:
            
            DispatchQueue.main.async
            {
                
                do {
                    
                    
                    
                    let datadata = dataString!.data(using: String.Encoding.utf8.rawValue)
                    
                    //if let jsonResult = try JSONSerialization.jsonObject(with: datadata!, options: []) as? [String : Any] {
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        let status = jsonResult["status"] as? String ?? ""
                        
                        // uploaded successfully
                        if status == "400" {
                            
                            let message = jsonResult["message"] as? String ?? ""
                            
                            print("which comment error1")
                            
                            helper.showAlert(title: "JSON Error", message: message, from: self)
                            
                            
                            
                            // error while uploading
                        } else {
                            
                            if let parse = jsonResult ["comments"] as? [[String:Any]] {
                                
                                print("YOU THERE ESSAY6? \(dataString)")
                                
                                for json in parse {
                                    
                                    // saving upaded user related information (e.g. ava's path, cover's path)
                                    let user_id = json["user_id"] as? String ?? ""
                                    let text = json["text"] as? String ?? ""
                                    let id =    json["id"] as! Int
                                    let picture = json["picture"] as? String ?? ""
                                    let date_created = json["date_created"] as? String ?? ""
                                    let firstName = json["firstName"] as? String ?? ""
                                    let cover = json["cover"] as? String ?? ""
                                    let ava = json["ava"] as? String ?? ""
                                    let post_id = json["post_id"] as? String ?? ""
                                    
                                    print("text name \(text) \(firstName) \(post_id)")
                                    let commentModel = CommentsModel(user_id: user_id, text: text, id: id, picture: picture, date_created: date_created, firstName: firstName, cover: cover, ava: ava, post_id: post_id)
                                    
                                    self.commentsArray.append(commentModel)
                                    
                                }
                                
                                DispatchQueue.main.async {
                                    self.myTableView.reloadData()
                                    
                                }
                                
                                
                                
                            }
                        }
                        
                    }
                    
                }
                catch
                {
                    
                    print("which comment error2")
                    
                    helper.showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
                    //print(error)
                }
                
                
            }
            
        }
    }).resume()
        
        
    }
    
    
    @objc func loadPost() {
        
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
        
        print("name2")
        
        guard let text = txtView.text else { return }
        
        print("name3 \(text)")
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }


        //let url:URL = URL(string: "http://localhost/Dating_App2/login.php")!
        let url:URL = URL(string: "https://netlaga.net/comments.php")!
        let session = URLSession.shared

        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData




        let paramString: String = "post_id=\(post_id)&user_id=\(currentUid)&type=insert&text=\(text)"


        print("param stuff \(paramString)")

        request.httpBody = paramString.data(using: String.Encoding.utf8)


    //STEP 2.  Execute created above request.
    let task = session.dataTask(with: request as URLRequest, completionHandler: {
        (data, response, error) in
        let helper = Helper()
        
        guard let _:Data = data, let _:URLResponse = response  , error == nil
            
            else {
                //print("error")
                if error != nil {
                    
                    helper.showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                }
                return
        }
        
       let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
       // var dataString = NSString(data: data!, encoding: CFStringConvertEncodingToNSStringEncoding(0x0422))
                
        print("YOU THERE ESSAY comment? \(dataString)")
        
        DispatchQueue.main.async {
            self.txtView.text = ""
            
            MBProgressHUD.hide(for: self.view, animated: true)//.hideAllHUDs(for: self.view, animated: true)

            UIApplication.shared.endIgnoringInteractionEvents()
            
            
        }
        
        self.commentsArray = []
        
        self.loadComments()
       

    }).resume()
        
        
    }


}
