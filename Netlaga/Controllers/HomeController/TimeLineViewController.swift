//
//  TimeLineViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 2/10/23.
//

import Foundation
import UIKit
import FirebaseAuth
import Kingfisher
import SDWebImage
import Alamofire
import SwiftyComments



class TimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommentDelegate {
    
    
        //CommentsViewController, UITextViewDelegate {//
    

    let kHeaderSectionTag: Int = 6900;
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionItems: Array<Any> = []
    var sectionNames: Array<Any> = []
    
    private let myArray: NSArray = ["First","Second","Third"]
    private var myTableView: UITableView!
    
    
    
    var timeLineArray : [TimeLineModel] = []
    
    let imageCache = NSCache<NSString, UIImage>()
    
    //var liked = [Bool]()
    
    var skip = 0
    var limit = 10
    var isLoading = false

        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white

            let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
            let displayWidth: CGFloat = self.view.frame.width
            let displayHeight: CGFloat = self.view.frame.height
            
            

            myTableView = UITableView(frame: CGRect(x: 0, y: barHeight + 200, width: displayWidth, height: displayHeight - (barHeight + 200)))
            myTableView.register(TimeLineCell.self, forCellReuseIdentifier: "TimeLineCell")
            myTableView.dataSource = self
            myTableView.delegate = self
            /*
            myTableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            myTableView.rowHeight = UITableView.automaticDimension
            myTableView.estimatedRowHeight = 300
             */
            myTableView.separatorStyle = .none
            myTableView.backgroundColor = .white
            
            self.view.addSubview(myTableView)
            
            
            let postButton = UIButton(type: .custom)
           postButton.setImage(UIImage(named: "Post"), for: .normal) // Image can be downloaded from here below line
            
           
        
            
            postButton.addTarget(self, action: #selector(self.postAction), for: .touchUpInside)
            view.addSubview(postButton)
            postButton.anchor(bottom: myTableView.topAnchor, right: view.rightAnchor, paddingBottom: 50, paddingRight: 0, width: 40, height: 40)
            
            
            
            loadPosts(offset: skip, limit: limit)
            
            sectionItems = [ ["iPhone 5", "iPhone 5s", "iPhone 6", "iPhone 6 Plus", "iPhone 7", "iPhone 7 Plus"],
                             ["iPad Mini", "iPad Air 2", "iPad Pro", "iPad Pro 9.7"],
                             ["Apple Watch", "Apple Watch 2", "Apple Watch 2 (Nike)"]
                           ];
            self.myTableView.tableFooterView = UIView()
            
            
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Num: \(indexPath.row)")
            print("Value: \(timeLineArray[indexPath.row])")
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if timeLineArray.count == 0 {
            self.myTableView.setEmptyMessage("Be the first to post to the timeline!")
            } else {
            self.myTableView.restore()
            }
            
            return timeLineArray.count
        }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0;//Choose your custom row height
    }
     

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//-> CommentCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell", for: indexPath) as! TimeLineCell
        cell.contentView.backgroundColor = .white
        
        cell.delegateComment = self
           
            let timeLineValues = timeLineArray[indexPath.row]
            
            cell.postId = timeLineValues.id
            
            if timeLineValues.liked == nil || timeLineValues.liked is NSNull || timeLineValues.liked == 0 {
                
                print("click false \(timeLineValues.liked)")
             
                cell.isclick = false
                
                cell.likeButton.setImage(UIImage(named: "ic_heart_empty_192dp"), for: UIControl.State.normal)
                
            } else {
                
                print("click true \(timeLineValues.liked)")
                
                cell.isclick = true
                
                cell.likeButton.setImage(UIImage(named: "ic_heart_full_192dp_pink"), for: UIControl.State.normal)
            }
        
        cell.commentButton.setImage(UIImage(named: "More"), for: UIControl.State.normal)
            
            cell.postText.text = timeLineValues.text
            
            cell.postName.text = timeLineValues.firstName
            
            let dateText = timeLineValues.date_created
            
           // var dateArr : [String] = []
            
          //  dateArr = dateText.components(separatedBy: " ")
            
            let dateFormatterGet2 = DateFormatter()
            dateFormatterGet2.dateFormat = "dd-MM-yy HH:mm:ss"
            
            let date2 = dateFormatterGet2.date(from: dateText) ?? Date()
            
                // Create Date Formatter
                let dateFormatter = DateFormatter()

                // Set Date Format
                dateFormatter.dateFormat = "MMM d,YYYY"

                // Convert Date to String
            cell.postDate.text = dateFormatter.string(from: date2)
            
            cell.postDate.textAlignment = .right
            
            print("pic url \(timeLineValues.picture)")
            
            
        
        //cell.photoImageView.contentMode = .scaleAspectFit
            
            cell.contentView.addSubview(cell.postName)
         
            cell.postName.anchor(top: cell.contentView.topAnchor, left: cell.contentView.leftAnchor, right: cell.contentView.centerXAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 40)
            
            cell.contentView.addSubview(cell.postDate)
         
            cell.postDate.anchor(top: cell.contentView.topAnchor, left: cell.postName.rightAnchor, right: cell.contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 40)
        
        
        cell.photoImageView.image = UIImage(named: "Post.png")
        
        let imageUrl = URL(fileURLWithPath: timeLineValues.picture)
        
        
        AF.request( timeLineValues.picture,method: .get).response{ response in

           switch response.result {
            case .success(let responseData):
               cell.photoImageView.image = UIImage(data: responseData!, scale:1)
               
                var aspectR: CGFloat = 0.0

               aspectR = (cell.photoImageView.image?.size.width)!/(cell.photoImageView.image?.size.height)!

               
               
               DispatchQueue.main.async {
                   
                   //cell.photoImageView.translatesAutoresizingMaskIntoConstraints = false
                                          
                   //cell.photoImageView.contentMode = .scaleToFill//.scaleAspectFit
                   
                   cell.contentView.addSubview(cell.photoImageView)
                   
                   cell.photoImageView.anchor(top: cell.postName.bottomAnchor, left: cell.contentView.leftAnchor, right: cell.contentView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingRight: 10, height: 300)
                   /*
                   NSLayoutConstraint.activate([
                    cell.photoImageView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                    cell.photoImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    cell.photoImageView.leadingAnchor.constraint(greaterThanOrEqualTo: cell.contentView.leadingAnchor),
                    cell.photoImageView.trailingAnchor.constraint(lessThanOrEqualTo: cell.contentView.trailingAnchor),
                    cell.photoImageView.heightAnchor.constraint(equalTo: cell.photoImageView.widthAnchor, multiplier: 1/aspectR)
                           ])
                   */
                   cell.contentView.addSubview(cell.postText)
                
                   cell.postText.anchor(top: cell.photoImageView.bottomAnchor, left: cell.contentView.leftAnchor, bottom: cell.contentView.bottomAnchor, right: cell.contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 0)
                   
                   cell.contentView.addSubview(cell.likeButton)
                   
                   cell.likeButton.anchor(top: cell.postText.bottomAnchor, right: cell.contentView.rightAnchor, width: 20, height: 20)
               
                   cell.contentView.addSubview(cell.commentButton)
               
                   cell.commentButton.anchor(top: cell.postText.bottomAnchor, right: cell.likeButton.leftAnchor, paddingRight: 40, width: 20, height: 20)
                   
               }

            case .failure(let error):
                print("error--->",error)
            }
        }
            
            
            
            
        
            
            
            /*
            if dailyWeather.comment_user_like == "0" {
                
                
                
                cell.likeButton.setImage(UIImage(named: "ic_heart_empty_192dp"), for: UIControl.State.normal)//(#imageLiteral(resourceName: "empty_heart"), for: .normal)
                cell.likeButton.imageView?.contentMode = .scaleAspectFill
                
                
                
            }else {
                
                // cell.likeButton.setImage(UIImage.init(named:"pink_heart"), for: .normal)
                
                cell.likeButton.setImage(UIImage(named: "ic_heart_full_192dp_pink"), for: UIControl.State.normal)//(#imageLiteral(resourceName: "pink_heart"), for: .normal)
                
                cell.likeButton.imageView?.contentMode = .scaleAspectFill
                
            }
            */
            
            //cell.photoImageView.centerX(inView: cell.contentView)
            //cell.photoImageView.anchor(top: cell.contentView.safeAreaLayoutGuide.topAnchor)
            
            
            
            /*
            DispatchQueue.global(qos: .background).async {
                let url = imageUrl//URL(string:(activeUser?.avatarUrl)!)
                let data = try? Data(contentsOf: url)
                let image: UIImage = UIImage(data: data!)!
                DispatchQueue.main.async {
                    //self.imageCache.setObject(image, forKey: NSString(string: (activeUser?.login!)!))
                    cell.photoImageView.image = image
                }
            }
             */
            /*
            let url = URL(string: "https://domain.com/logo.png")!

            loadData(url: imageUrl) { (data, error) in
                // Handle the loaded file data

                // If the data is an image, use UIImage(data: data) to
                // load the image
                
                let image: UIImage = UIImage(data: data!)!
                DispatchQueue.main.async {
                    //self.imageCache.setObject(image, forKey: NSString(string: (activeUser?.login!)!))
                    cell.photoImageView.image = image
                }
            }
             */
            
    
            /*
            cell.photoImageView.kf.setImage(with: imageUrl,
                                        placeholder: UIImage(named: "Post.png"),
                                        options: [.transition(.fade(1))],
                                        progressBlock: { receivedSize, totalSize in
                                           // print(": \(receivedSize)/\(totalSize)")
            },
                                        completionHandler: { (error) in

                                           // print(": Finished")
                                            //print(image?.size)
                /*
                                            if image != nil{
                                                cell.photoImageView.image = self.resizeImage(image: image!, newWidth: self.view.frame.width/2)
                                            }else{
                                                
                                                cell.photoImageView.image = self.resizeImage(image: UIImage(named: "Post.png")!, newWidth: self.view.frame.width/4)
                                                
                                            }
                 */

            })
             */
            
            //cell.photoImageView.kf.setImage(with: imageUrl)
         
            //cell.photoImageView.anchor(top: cell.contentView.topAnchor,left: cell.contentView.leftAnchor, right: cell.contentView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 100)
            
            //cell.photoImageView.anchor(top: cell.contentView.topAnchor, paddingTop: 0, width: 100, height: 100)
            
            //cell.photoImageView.centerX(inView: cell.contentView)
            
            
            
            
            
            return cell
        }
    /*
    func download(url: URL, toFile file: URL, completion: @escaping (Error?) -> Void) {
        // Download the remote URL to a file
        let task = URLSession.shared.downloadTask(with: url) {
            (tempURL, response, error) in
            // Early exit on error
            guard let tempURL = tempURL else {
                completion(error)
                return
            }

            do {
                // Remove any existing document at file
                if FileManager.default.fileExists(atPath: file.path) {
                    try FileManager.default.removeItem(at: file)
                }

                // Copy the tempURL to file
                try FileManager.default.copyItem(
                    at: tempURL,
                    to: file
                )

                completion(nil)
            }

            // Handle potential file system errors
            catch let fileError {
                completion(error)
            }
        }

        // Start the download
        task.resume()
    }
    
    func loadData(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        // Compute a path to the URL in the cache
        let fileCachePath = FileManager.default.temporaryDirectory
            .appendingPathComponent(
                url.lastPathComponent,
                isDirectory: false
            )
        
        // If the image exists in the cache,
        // load the image from the cache and exit
        if let data = Data(contentsOfFile: fileCachePath.path {
            completion(data, nil)
            return
        }
        
        // If the image does not exist in the cache,
        // download the image to the cache
        download(url: url, toFile: fileCachePath) { (error) in
            let data = Data(contentsOfFile: fileCachePath.path)
            completion(data, error)
        }
    }

   */
    
    func commentView(_ id: Int) {
        
        let vc =  CommentViewController() //your view controller
        vc.post_id = id
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @objc func likeAction() {
        print("Like goes here")
        
        
       
    }
    
    
    @objc func postAction() {
        print("It goes here")
        
        let vc =  PostViewController() //your view controller
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
       
    }
    
    func loadPosts(offset: Int, limit: Int) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }


        //let url:URL = URL(string: "http://localhost/Dating_App2/login.php")!
        let url:URL = URL(string: "https://netlaga.net/selectPosts.php")!
        let session = URLSession.shared

        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData




        let paramString: String = "id=\(currentUid)&limit=10&offset=1"


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
        
        var dataEncoded : NSString = ""
        
        dataEncoded = dataString ?? ""
                
        print("YOU THERE ESSAY3? \(dataString ?? "")")
        
        switch dataEncoded {
        case "":
            print("Bring an umbrella")
        
            DispatchQueue.main.async
            {
                
                self.timeLineArray = []
                
                self.myTableView.reloadData()
                
            }
            
        default:
            print("Enjoy your day!")
            
            DispatchQueue.main.async
                       {
                       print("YOU THERE ESSAY4? ")
                           
                           
                           do {
                               
                             
                               
                               let datadata = dataString!.data(using: String.Encoding.utf8.rawValue)
                               
                               //if let jsonResult = try JSONSerialization.jsonObject(with: datadata!, options: []) as? [String : Any] {
                               //if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] {
                               
                              
                               if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {

                                 let status = jsonResult["status"] as? String ?? ""
                                  
                               // uploaded successfully
                               if status == "400" {
                                   
                                   let message = jsonResult["message"] as? String ?? ""
                                   
                                   helper.showAlert(title: "Error", message: message, from: self)
                                   
                   
                                   
                               // error while uploading
                               } else {
                                   
                                   if let parse = jsonResult ["posts"] as? [[String:Any]] {
                                   
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
                                   let liked = json["liked"] as? Int ?? 0
                                   
                                       print("text name \(text) \(firstName) \(liked)")
                                           let timeLineModel = TimeLineModel(user_id: user_id, text: text, id: id, picture: picture, date_created: date_created, firstName: firstName, cover: cover, ava: ava, liked: liked)
                                           
                                           self.timeLineArray.append(timeLineModel)
                                           
                                           print("here1")
                                   
                                       }
                                       
                                       let imageUrl = URL(string: self.timeLineArray[0].picture)
                                       
                                       
                                       
                                       
                                       print("here2")
                                       DispatchQueue.main.async {
                                           self.myTableView.reloadData()
                                           
                                       }
                                           
                                   }
                               }
                                   
                               }
                               
                           }
                           catch
                           {
                           
                           print("YOU THERE ESSAY8?")
                           
                           helper.showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
                               //print(error)
                           }
                   }
        }
        
       
        
        
    }).resume()
        
    }
}
