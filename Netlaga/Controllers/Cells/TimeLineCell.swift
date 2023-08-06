//
//  TimeLineCell.swift
//  DatingApp
//
//  Created by Scott Brown on 2/13/23.
//

import UIKit
import FirebaseAuth
import SwiftyComments

protocol CommentDelegate: class {
    
    func commentView(_ id: Int)
    
}


class TimeLineCell: UITableViewCell {//CommentCell {
    
    weak var delegateComment: CommentDelegate?


    let postText : UITextView = {
    let lbl = UITextView()
    lbl.textColor = .black
    lbl.backgroundColor = .white
    lbl.font = UIFont.boldSystemFont(ofSize: 12)
    lbl.textAlignment = .left
    lbl.isEditable = false
    return lbl
    }()
    
    let postName : UILabel = {
    let lbl = UILabel()
    lbl.textColor = .black
    lbl.font = UIFont.boldSystemFont(ofSize: 12)
    lbl.textAlignment = .left
    return lbl
    }()
    
    let postDate : UILabel = {
    let lbl = UILabel()
    lbl.textColor = .black
    lbl.font = UIFont.boldSystemFont(ofSize: 12)
    lbl.textAlignment = .left
    return lbl
    }()
    
    let likeButton: UIButton = {
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        
        let image = UIImage(named: "ic_heart_empty_192dp")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        if #available(iOS 13.0, *) {
        button.tintColor = UIColor.systemBlue
        } else {
            button.tintColor = UIColor.white
        }
        //button.addTarget(self, action: #selector(attachMessage), for: .touchUpInside)
        return button
        
    }()
    
    let commentButton: UIButton = {
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        
        let image = UIImage(named: "More.png")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        if #available(iOS 13.0, *) {
        button.tintColor = UIColor.systemBlue
        } else {
            button.tintColor = UIColor.white
        }
        //button.addTarget(self, action: #selector(attachMessage), for: .touchUpInside)
        return button
        
    }()
     
    
    let photoImageView: UIImageView = {
        let theImageView = UIImageView()
        
        if #available(iOS 13.0, *) {
        theImageView.image = UIImage(named: "user.png")
        }else{
        let image = UIImage(named: "user.png")?.withRenderingMode(.alwaysTemplate)
        theImageView.image = image
        theImageView.tintColor = UIColor.white
        }
           
           
        theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
        /*
        let idiomHeight = UIScreen.main.bounds.height
        if idiomHeight  < 736.0 {
            
            theImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
        } else {
            
            theImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true

        }
       */
        
           return theImageView
        }()
    
    let profileImageView: UIImageView = {
        let theImageView = UIImageView()
        
        if #available(iOS 13.0, *) {
        theImageView.image = UIImage(named: "user.png")
        }else{
        let image = UIImage(named: "user.png")?.withRenderingMode(.alwaysTemplate)
        theImageView.image = image
        theImageView.tintColor = UIColor.white
        }
           
           
        theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
        
        let idiomHeight = UIScreen.main.bounds.height
        if idiomHeight  < 736.0 {
            
            theImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
        } else {
            
            theImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true

        }
       
        
           return theImageView
 }()
    
    var isclick = false
    
    var postId: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
     super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
       /*
        addSubview(photoImageView)
     
        photoImageView.anchor(top: topAnchor,left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 100)
        
     
        
        addSubview(postText)
     
        postText.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
      */
        
        likeButton.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        
        commentButton.addTarget(self, action: #selector(commentAction), for: .touchUpInside)
    
        
     }

    required init?(coder aDecoder: NSCoder) {
        fatalError("We aren't using storyboards")
    }
    
    
    @objc func commentAction(){
        
        delegateComment?.commentView(postId)
        
    }
    
    
    @objc func likeAction(){
        
        if isclick == false {//(!isclick){
         
            
            likeButton.setImage(UIImage(named: "ic_heart_full_192dp_pink"), for: UIControl.State.normal)
            
            
            isclick=true
            
            guard let currentUid = Auth.auth().currentUser?.uid else { return }

            let url:URL = URL(string: "https://netlaga.net/like.php")!
            let session = URLSession.shared

            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData




            let paramString: String = "post_id=\(postId)&user_id=\(currentUid)=&type=insert"


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
                        
                       // helper.showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                    }
                    return
            }
            
           let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
           // var dataString = NSString(data: data!, encoding: CFStringConvertEncodingToNSStringEncoding(0x0422))
                    
            print("YOU THERE ESSAY4? \(dataString)")
            /*
            DispatchQueue.main.async
                {
                print("YOU THERE ESSAY4? ")
                    
                    
                    do {
                        
                      
                        
                        let datadata = dataString!.data(using: String.Encoding.utf8.rawValue)
                        
                        //if let jsonResult = try JSONSerialization.jsonObject(with: datadata!, options: []) as? [String : Any] {
                        
                       if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {

                          let status = jsonResult["status"] as? String ?? ""
                           
                        // uploaded successfully
                        if status == "400" {
                            
                            let message = jsonResult["message"] as? String ?? ""
                            
                            //helper.showAlert(title: "JSON Error", message: message, from: self)
                            
            
                            
                        // error while uploading
                        } else {
                            
                            if let parse = jsonResult ["posts"] as? [[String:Any]] {
                            
                            print("YOU THERE ESSAY6? \(dataString)")
                                
                                for json in parse {
                            
                            // saving upaded user related information (e.g. ava's path, cover's path)
                            let user_id = json["user_id"] as? String ?? ""
                            let text = json["text"] as? String ?? ""
                            let id =    json["id"] as? String ?? ""
                            let picture = json["picture"] as? String ?? ""
                            let date_created = json["date_created"] as? String ?? ""
                            let firstName = json["firstName"] as? String ?? ""
                            let cover = json["cover"] as? String ?? ""
                            let ava = json["ava"] as? String ?? ""
                            let liked = json["liked"] as? Int ?? 0
                            
                                print("text name \(text) \(firstName) \(liked)")
                                    let timeLineModel = TimeLineModel(user_id: user_id, text: text, id: id, picture: picture, date_created: date_created, firstName: firstName, cover: cover, ava: ava, liked: liked)
                                    
                                    
                                    
                                    print("here1")
                            
                                }
                                
                             
                                    
                            }
                        }
                            
                        }
                        
                    }
                    catch
                    {
                    
                    print("YOU THERE ESSAY8?")
                    
                   // helper.showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
                        //print(error)
                    }
            }
           */
            
        }).resume()
            
            
        } else {
            
            likeButton.setImage(UIImage(named: "ic_heart_empty_192dp"), for: UIControl.State.normal)
            
            
            isclick=false
            
            
            guard let currentUid = Auth.auth().currentUser?.uid else { return }

            let url:URL = URL(string: "https://netlaga.net/like.php")!
            let session = URLSession.shared

            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData




            let paramString: String = "post_id=\(postId)&user_id=\(currentUid)=&type=delete"


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
                        
                       // helper.showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                    }
                    return
            }
            
           let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
           // var dataString = NSString(data: data!, encoding: CFStringConvertEncodingToNSStringEncoding(0x0422))
                    
            print("YOU THERE ESSAY5? \(dataString)")
            /*
            DispatchQueue.main.async
                {
                print("YOU THERE ESSAY4? ")
                    
                    
                    do {
                        
                      
                        
                        let datadata = dataString!.data(using: String.Encoding.utf8.rawValue)
                        
                        //if let jsonResult = try JSONSerialization.jsonObject(with: datadata!, options: []) as? [String : Any] {
                        
                       if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {

                          let status = jsonResult["status"] as? String ?? ""
                           
                        // uploaded successfully
                        if status == "400" {
                            
                            let message = jsonResult["message"] as? String ?? ""
                            
                            //helper.showAlert(title: "JSON Error", message: message, from: self)
                            
            
                            
                        // error while uploading
                        } else {
                            
                            if let parse = jsonResult ["posts"] as? [[String:Any]] {
                            
                            print("YOU THERE ESSAY6? \(dataString)")
                                
                                for json in parse {
                            
                            // saving upaded user related information (e.g. ava's path, cover's path)
                            let user_id = json["user_id"] as? String ?? ""
                            let text = json["text"] as? String ?? ""
                            let id =    json["id"] as? String ?? ""
                            let picture = json["picture"] as? String ?? ""
                            let date_created = json["date_created"] as? String ?? ""
                            let firstName = json["firstName"] as? String ?? ""
                            let cover = json["cover"] as? String ?? ""
                            let ava = json["ava"] as? String ?? ""
                            let liked = json["liked"] as? Int ?? 0
                            
                                print("text name \(text) \(firstName) \(liked)")
                                    let timeLineModel = TimeLineModel(user_id: user_id, text: text, id: id, picture: picture, date_created: date_created, firstName: firstName, cover: cover, ava: ava, liked: liked)
                                    
                                    
                                    
                                    print("here1")
                            
                                }
                                
                             
                                    
                            }
                        }
                            
                        }
                        
                    }
                    catch
                    {
                    
                    print("YOU THERE ESSAY8?")
                    
                   // helper.showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
                        //print(error)
                    }
            }
           */
            
        }).resume()
            
            
            
            
        }
        
    }
         

}
