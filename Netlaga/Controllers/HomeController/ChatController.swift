//
//  ChatController.swift
//  DatingApp
//
//  Created by Scott Brown on 11/9/22.
//

import UIKit
import Alamofire
import FirebaseAuth
import Gallery


private let reuseIdentifier = "MessageCell"

class ChatController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GalleryControllerDelegate{
    
        //, UICollectionViewDelegateFlowLayout {
    
    
    
    // MARK - Properties
    
    //private let user: User
    
    private let discoverySetUp: DiscoveryStruct
    
    //private let userMessageObject: UserMessageObject
    
    private var messages = [Message]()
    
   var fromCurrentUser = false
    
    private lazy var customInputView: CustomInputAccessory = {
    
    let iv = CustomInputAccessory(frame: CGRect(x:0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
    return iv
        
    }()
    
    var myCollectionView:UICollectionView?
    
    var gallery: GalleryController!
    
   
    var titleLabel = UILabel()
    
        // MARK: - API
    
    func fetchMessages() {
        
        
        
        UserService.fetchMessages(forUser: discoverySetUp) { messages in
            
            self.messages = messages
            
            print("messages coming in \(self.messages.map{$0.text})")
            self.myCollectionView?.reloadData()
        }
    }
    
    func fetchMessageUsers() {
        
        UserService.fetchMessageUsers { users in
            
        }
    }
    
    
    
    // MARK: - Lifecycle
    
    init(discoverySetUp: DiscoveryStruct) {
        
        self.discoverySetUp = discoverySetUp
       // self.userMessageObject = userMessageObject
        super.init(nibName: nil, bundle: nil)
        //super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        
        
        
        //deleteMessages()
        fetchMessages()
       
        print("User in chat controller is \(discoverySetUp.firstName)")
        
    }
    
    override var inputAccessoryView: UIView? {
        
        get {
            return customInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
         }
    
    
        // MARK: - Helpers
    
    func deleteMessages() {
       
   
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        
        let parameters: [String:Any] = ["userId": currentUid, "messengerId": discoverySetUp.uid]
        
                let url = "https://us-central1-datingapp-80400.cloudfunctions.net/scrape"
                
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
                    
            print("delete here3 \(parameters) \(response)")
                    
                    switch response.result {
                        case .success(let dict):
                            
                        print("delete here4 \(response)")
                           
                            let successDict: [String: Any?] = dict as? [String: Any?] ?? [:]
                        
                        self.fetchMessages()
                        
                        case .failure(let error):
                        print("delete here5 \(error.localizedDescription)")
                           
                            print(error.localizedDescription)
                            //completion(nil, error.localizedDescription)
                    }
                }
        
        
    }
    
    
    func configureUI() {
        
        view.backgroundColor = .white
        //collectionView.backgroundColor = .white
        
        titleLabel.frame = CGRect(x: view.frame.width / 2 - 70, y: 30, width: 140, height: 30)
        
        view.addSubview(titleLabel)
        
        titleLabel.text = discoverySetUp.firstName
        
        
        
               
               let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
               layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
               layout.itemSize = CGSize(width: view.frame.width, height: 50)
        
               
               myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
            myCollectionView?.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
               myCollectionView?.backgroundColor = UIColor.white
        
            myCollectionView?.dataSource = self
            myCollectionView?.delegate = self
        
        myCollectionView?.alwaysBounceVertical = true
        
               view.addSubview(myCollectionView ?? UICollectionView())
               
             
        
        //configureNavigationBar(withTitle: discoverySetUp.firstName, prefersLargeTitles: false)
        
    }
    
    
   
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return messages.count // How many cells to display
            
        }
     
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
               // myCell.backgroundColor = UIColor.blue
                myCell.message = messages[indexPath.row]
                myCell.message?.user = discoverySetUp
                //myCell.message.
                return myCell
            }
        
     
   
     
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           print("User tapped on item \(indexPath.row)")
        }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
     */
    
        //MARK: - Gallery
        
        private func showImageGalleryFor(camera: Bool) {
            
            self.gallery = GalleryController()
            self.gallery.delegate = self
            
            Config.tabsToShow = camera ? [.cameraTab] : [.imageTab]
            Config.Camera.imageLimit = 1
            Config.initialTab = .imageTab
            
            self.present(gallery, animated: true, completion: nil)

        }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            images.first!.resolve { (image) in
                print("images coming soon")
                UserService.uploadPhoto(image, to: self.discoverySetUp) { error in
                    if error != nil {
                        
                        print("DEBUG: failed")
                        
                        return
    
                        
                    }
                }
                //self.messageSend(text: nil, photo: image)
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

extension ChatController: CustomInputAccessoryViewDelegate {
    
    
    func attachView(_ inputView: CustomInputAccessory) {
        
        inputView.resignFirstResponder()

        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction(title: "Camera", style: .default) { (alert) in
            
            self.showImageGalleryFor(camera: true)
            print("camera here")
        }
        
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert) in
            self.showImageGalleryFor(camera: false)
            print("library here")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func inputView(_ inputView: CustomInputAccessory, wantsToSend message: String) {
        
        UserService.uploadMessage(message, type: "text", to: discoverySetUp) { error in
            if let error = error {
                
                print("DEBUG: failed")
                
                return
                
                //inputView.clearMessagingText()//.messageInputTextView.text = nil
                
            }
            
            inputView.clearMessagingText()
            
            UserService.uploadMessageUser(to: self.discoverySetUp) { str in//error in
                
                /*
                if let error = error {
                    
                    print("DEBUG: failed")
                    
                    return
                    
                    //inputView.clearMessagingText()//.messageInputTextView.text = nil
                    
                }
                 */
            }
        }
        /*
        fromCurrentUser.toggle()
        let message = Message(text: message, isFromCurrentUser: fromCurrentUser)
        messages.append(message)
        myCollectionView?.reloadData()
       // print("DEBUG: Handle send msg in chat controller")
         */
        
    }
    
    
    
}


