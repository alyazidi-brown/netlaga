//
//  NewChatViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 1/7/23.
//

import Foundation
import MessageKit
import InputBarAccessoryView
import Firebase
import Gallery
import Kingfisher
import AVFAudio
import NVActivityIndicatorView
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import AVFoundation
import Alamofire
import CoreLocation
import UIKit


protocol ReadMessageDelegate: AnyObject {
    func notifyMe()
}

protocol SaveInviteDelegate: AnyObject {
    func saveInvite(date: String, time: String, name: String, discoverySetUp: DiscoveryStruct)
}


class ChatViewController: MessagesViewController, AudioRecorderVCDelegate, InviteLocationDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{//, chatResetDelegate{
    
    /*
    func chatReset() {
        downloadChats()
        
        self.messagesCollectionView = ChatMessagesCollectionView()
        (self.messagesCollectionView as? ChatMessagesCollectionView)?.messagesCollectionViewDelegate = self
        
        self.messagesCollectionView.reloadData()
        
        print("reloaded 1")
        super.viewDidLoad()
        
        print("reloaded 2")
        /*
        deleteImage(discoveryStruct: discoverySetUp)
        configNotificationStatus()
        
        if UserDefaults.standard.object(forKey: discoverySetUp.uid) != nil {
          
            UserDefaults.standard.set(false, forKey: discoverySetUp.uid)
            
            UserDefaults.standard.synchronize()
            
            UserDefaults.standard.removeObject(forKey: discoverySetUp.uid)
            
            self.delegate?.notifyMe()
            
        }
        
        
        self.messagesCollectionView = ChatMessagesCollectionView()
        (self.messagesCollectionView as? ChatMessagesCollectionView)?.messagesCollectionViewDelegate = self
        
        
        super.viewDidLoad()
        
        print("right chat")
        
        view.backgroundColor = .white
        
        overrideUserInterfaceStyle = .light
        
        self.messagesCollectionView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 70, right: 0)
        
        self.navigationItem.title = "title"
        //self.tabBarController?.navigationController?.navigationBar.backgroundColor = .red
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Abcd", style: .done, target: self, action: #selector(backButtonAction))
        
        //navigationItem.hidesBackButton = true
       // navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .plain, target: self, action: #selector(backButtonAction))
        
        senderRoom = Auth.auth().currentUser?.uid ?? "userNotFound"
        
        setChatTitle()
        
        self.setNavigationBar()
        //backButtonUI()
        
        //configureLeftBarButton()
        configureMessageCollectionView()
        configureMessageInputBar()
        
        //downloadChats()
        
        audioController = AudioController(messageCollectionView: messagesCollectionView)
         */
    }
    */
    

    
    
    func uploadLocation(location: CLLocation, locationImage: UIImage, date: String, time: String, placeName: String) {
        print ("do you even go here location chat?")
        var latitudeStr: String = ""
        var longitudeStr: String = ""
        
        latitudeStr = "\(location.coordinate.latitude)"
        longitudeStr = "\(location.coordinate.longitude)"
        
        print ("latitude string \(latitudeStr) \(longitudeStr)")
        
        UserService.uploadMessage(inviteLatitude: latitudeStr, inviteLongitude: longitudeStr, type: "location", to: discoverySetUp, invite: "true", date: date, time: time, placeName: placeName) { error in
            
            
            if let error = error {
                
                print("DEBUG: failed")
                
                return
                
                //inputView.clearMessagingText()//.messageInputTextView.text = nil
                
            }
            
            let title = "You've received a message."
            
            let body = "\(UserTwo.firstName) sent you a message."
            
            UserService.fetchActivity(to: self.discoverySetUp) { str in
                
                print("the activity string noted4 \(str)")
                
                if str == "inactive" {
                    
                    PushNotificationService.sendMessageToUser(sender: UserTwo.uid, chatRoomId: "", to: self.discoverySetUp.token, title: title, body: body)
                    
                } else {
                    
                    
                    
                }
                
                
            }
            
            UserService.uploadPhoto(locationImage, to: self.discoverySetUp) { imageUrl in//{ error  in
                
                print(imageUrl)
                /*
                if error != nil {
                    
                    print("DEBUG: failed")
                    
                    return

                    
                }
                */
                
                UserService.uploadMessage("Wanna meet here? :D", type: "text", to: self.discoverySetUp, invite: "true", date: date, time: time, placeName: placeName) { error in
                    if let error = error {
                        
                        print("DEBUG: failed")
                        
                        return
                        
                        
                    }
                    
                
            }
                 
            }
            
            
            UserService.uploadMessageUser(to: self.discoverySetUp) { str in//error in
                
                /*
                if let error = error {
                    
                    print("DEBUG: failed")
                    
                    return
                    
                    
                }
                 */
            }
        }
    }
    
    
    //MARK: - Vars
    //private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    
    var delegate: ReadMessageDelegate?
    
    var inviteDelegate: SaveInviteDelegate?
    
    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder?
    var isRecording = false
    
    var imagePicker = UIImagePickerController()
    let viewIndicator = UIView()
    var loadingIndicator: NVActivityIndicatorView?
    let storageRef = Storage.storage().reference()
    var numberOfRecords = 0
    
    var senderRoom = ""
    var receiverRoom = ""
    var numberOfMsg = 0
    
    var counter = 0.0
    
    let refreshController = UIRefreshControl()
    
    var audioController: AudioController?
    var isPlayingSound = false
    
    var discoverySetUp = DiscoveryStruct(firstName: "", email: "", ava: "", uid: "", place: "", token: "")
    
    let currentUser = MKSender(senderId: UserTwo.uid, displayName: UserTwo.firstName)
    
    private var mkmessages: [Message] = []
    
    private var mkmessagesTwo: [MKMessage] = []
    var loadedMessageDictionaries: [Dictionary<String, Any>] = []
    
    var gallery: GalleryController!
    
    var initialLoadCompleted = false
    var displayingMessagesCount = 0
    
    var maxMessageNumber = 0
    var minMessageNumber = 0
    var loadOld = false
    
    var typingCounter = 0
    
    var floatingButton: UIButton = {
       let button = UIButton(type: .custom)
       
       button.setImage(UIImage(named: "BackButton"), for: .normal)
       
    
       return button
   }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "ic_mic"), for: .normal)
        
        button.addTarget(self, action: #selector(recordAction), for: .touchUpInside)
        
        button.tintColor = UIColor.blue
        
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

    //MARK: - Inits
    init(recipientId: String, recipientName: String) {
    
        super.init(nibName: nil, bundle: nil)
        
        self.recipientId = recipientId
        self.recipientName = recipientName
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        
        
        
        self.messagesCollectionView = ChatMessagesCollectionView()
        (self.messagesCollectionView as? ChatMessagesCollectionView)?.messagesCollectionViewDelegate = self
        
        configureMessageCollectionView()
        configureMessageInputBar()

        
        super.viewDidLoad()
       
        
        print("right chat")
        
        view.backgroundColor = .white
        
        overrideUserInterfaceStyle = .light
        
        
        
        
        
        self.messagesCollectionView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 70, right: 0)
        
        self.navigationItem.title = "title"
        //self.tabBarController?.navigationController?.navigationBar.backgroundColor = .red
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Abcd", style: .done, target: self, action: #selector(backButtonAction))
        
        //navigationItem.hidesBackButton = true
       // navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .plain, target: self, action: #selector(backButtonAction))
        
        senderRoom = Auth.auth().currentUser?.uid ?? "userNotFound"
        
        setChatTitle()
        
        self.setNavigationBar()
        //backButtonUI()
        
        //configureLeftBarButton()
        //configureMessageCollectionView()
        //configureMessageInputBar()
        
        //downloadChats()
        
        audioController = AudioController(messageCollectionView: messagesCollectionView)
        

    }
    
    func configNotificationStatus() {
        
        UserService.uploadActivity(to: discoverySetUp, status: "active") { str in
            
            print("activity string \(str)")
        }
        
        
    }
    
    func configNotificationExitStatus() {
      
        
        UserService.uploadActivity(to: discoverySetUp, status: "inactive") { str in
            
            print("activity string \(str)")
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
        //Calls this function when the tap is recognized.
        @objc func dismissKeyboard() {
            
            print("message view is being tapped.")
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            view.endEditing(true)
        }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //configureMessageInputBar()
        downloadChats()
        deleteImage(discoveryStruct: discoverySetUp)
        configNotificationStatus()
        
        if UserDefaults.standard.object(forKey: discoverySetUp.uid) != nil {
          
            UserDefaults.standard.set(false, forKey: discoverySetUp.uid)
            
            UserDefaults.standard.synchronize()
            
            UserDefaults.standard.removeObject(forKey: discoverySetUp.uid)
            
            self.delegate?.notifyMe()
            
        }
        
        //inputAccessoryView?.becomeFirstResponder()
        self.becomeFirstResponder()
        
        /*
        self.messagesCollectionView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 70, right: 0)
        
        self.navigationItem.title = "title"
        
        
        senderRoom = Auth.auth().currentUser?.uid ?? "userNotFound"
        
        setChatTitle()
        
        self.setNavigationBar()
        
        configureMessageCollectionView()
        configureMessageInputBar()
        
       
        
        audioController = AudioController(messageCollectionView: messagesCollectionView)
         */
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        configNotificationExitStatus()
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    //MARK: - Config
    private func configureLeftBarButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backButtonPressed))
        
        
    }
    
    func setNavigationBar() {
        
        //create a new button
                let button = UIButton(type: .custom)
                //set image for button
                button.setImage(UIImage(named: "BackButton"), for: .normal)
                //add function for button
                button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
                //set frame
                button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)

                let barButton = UIBarButtonItem(customView: button)
                //assign button to navigationbar
                //self.navigationItem.rightBarButtonItem = barButton
        
        
        let url = URL(string: discoverySetUp.ava)!
        

            //let data = try! Data(contentsOf: url)
            //let img = UIImage(data: data)
            let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
            
            // NEW CODE HERE: Setting the constraints
            imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
            imageView.kf.setImage(with: url)
        
            //imageView.image = img?.withRenderingMode(.alwaysOriginal)
            imageView.layer.cornerRadius = 20.0
            imageView.layer.masksToBounds = true
        
        
            
        
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: screenSize.width, height: 70))
        let navItem = UINavigationItem(title: "")//(title: "\(discoverySetUp.firstName)")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: nil, action: #selector(backButtonAction))
        //navItem.leftBarButtonItem = doneItem
        
        navItem.prompt = discoverySetUp.firstName
        
        navItem.titleView = imageView
        
        navItem.leftBarButtonItem = barButton
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }

    
    func backButtonUI() {
        
       
                floatingButton.layer.cornerRadius = 25
        
                floatingButton.layer.zPosition = 1;
                
                view.addSubview(floatingButton)
                floatingButton.translatesAutoresizingMaskIntoConstraints = false

                floatingButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
                floatingButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
                
                floatingButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true

                floatingButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        
                floatingButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
               //floatingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

    }
    
    func deleteImage(discoveryStruct: DiscoveryStruct) {
       
   
        print("I go here 1st")
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        
        let parameters: [String:Any] = ["userId": currentUid, "messengerId": discoveryStruct.uid]
        
                let url = "https://us-central1-datingapp-80400.cloudfunctions.net/scrapeImage"
                
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
                    
            print("delete here32 \(parameters) \(response)")
                    
                    switch response.result {
                        case .success(let dict):
                        
                        self.deleteMessages(discoveryStruct: discoveryStruct)
                            
                        print("delete here4 \(response)")
                           
                           
                         
                        case .failure(let error):
                        print("delete here5 \(error.localizedDescription)")
                        
                        self.presentAlertController(withTitle: "Error", message: error.localizedDescription)
                           
                            print(error.localizedDescription)
                            //completion(nil, error.localizedDescription)
                    }
                }
        
        
    }
    
    
    func deleteMessages(discoveryStruct: DiscoveryStruct) {
       
   print("new chat controller")
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        
        let parameters: [String:Any] = ["userId": currentUid, "messengerId": discoveryStruct.uid]
        
                let url = "https://us-central1-datingapp-80400.cloudfunctions.net/scrape"
                
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
                    
            
                    
                    switch response.result {
                        case .success(let dict):
                            
                       
                        let successDict: [String: Any?] = dict as? [String: Any?] ?? [:]
                        
    
                           
                        case .failure(let error):
                        
                        self.presentAlertController(withTitle: "Error", message: error.localizedDescription)
                        
                        print("delete here5 \(error.localizedDescription)")
                           
                            print(error.localizedDescription)
                          
                    }
                }
        
        
    }
    
     func configureMessageCollectionView() {

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        
        
       // scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        messagesCollectionView.refreshControl = refreshController
        
    }
    
    
     func configureMessageInputBar() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        messageInputBar.delegate = self
        
        let button = InputBarButtonItem()
        button.image = UIImage(named: "attach")
        button.setSize(CGSize(width: 30, height: 30), animated: false)
        
        let audioButton = InputBarButtonItem()
        audioButton.image = UIImage(named: "ic_record")
        audioButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
       // audioButton.tintColor = UIColor.blue
        
        
        
        button.onTouchUpInside { (item) in
            self.actionAttachMessage()
        }
        
        audioButton.onTouchUpInside { (item) in
            print("audio attempt")
            let vc = AudioRecorderVC()
            vc.discoverySetUp = self.discoverySetUp
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            //self.navigationController?.pushViewController(vc, animated: true)
           
        }
        
        /*messageInputBar.setMiddleContentView(recordButton, animated: false)*/
        
        
        messageInputBar.setStackViewItems([button,audioButton], forStack: .left, animated: false)
        //messageInputBar.setStackViewItems([audioButton, messageInputBar.sendButton], forStack: .right, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 70, animated: false)
        //messageInputBar.setStackViewItems([audioButton], forStack: .bottom, animated: false)
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
    }
    
    func startAnimating() {
        viewIndicator.isHidden = false
        view.isUserInteractionEnabled = false
        loadingIndicator?.startAnimating()
    }
    
    func stopAnimating() {
        viewIndicator.isHidden = true
        view.isUserInteractionEnabled = true
        loadingIndicator?.stopAnimating()
    }
    
    func uploadAudioToStorage(file: URL, user: DiscoveryStruct) {
        print("That communication has begun \(file)")
        startAnimating()
        
        let dataAudio = try! Data(contentsOf: file)
        let date = Util.getStringFromDate(format: "YYYY,MM dd,HH:mm:ss", date: Date())
        let audioName = "\(date)  \(UUID().uuidString)"
        
        let audioSpecificPath = storageRef.child(senderRoom).child(audioName)
        let metaData = StorageMetadata()
        metaData.contentType = "audio/mp3"
        
        audioSpecificPath.putData(dataAudio, metadata: metaData) { meta, err in
            if err != nil {
                return
            } else {
                audioSpecificPath.downloadURL { url, err in
                    
                    print("well 1st off are you here3?")
                    
                    if url?.absoluteString != nil {
                      
                        
                        UserService.uploadMessage(mediaURL: url?.absoluteString, type: "audio", to: user) { error in
                            
                        
                            if let error = error {
                                
                                print("DEBUG: failed")
                                
                                return
                                
                                
                            }
                            
                            let title = "You've received a message."
                            
                            let body = "\(UserTwo.firstName) sent you a message."
                            
                            UserService.fetchActivity(to: self.discoverySetUp) { str in
                                
                                print("the activity string noted5 \(str)")
                                
                                if str == "inactive" {
                                    
                                    PushNotificationService.sendMessageToUser(sender: UserTwo.uid, chatRoomId: "", to: self.discoverySetUp.token, title: title, body: body)
                                    
                                } else {
                                    
                                    
                                    
                                }
                                
                                
                            }
                            
                            UserService.uploadMessageUser(to: self.discoverySetUp) { str in//error in
                                
                                /*
                                if let error = error {
                                    
                                    print("DEBUG: failed")
                                    
                                    return
                                    
                                    
                                }
                                 */
                            }
                        
                     
                    }
                }
                    
                    self.stopAnimating()
                }
            }
        }
         
        
    }
    
    private func setChatTitle() {
        self.title = recipientName
    }
    

    //MARK: - Actions
    @objc func backButtonPressed() {
        
        //FirebaseListener.shared.resetRecentCounter(chatRoomId: chatId)
        //removeListeners()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backButtonAction() {
        
        print("back button pressed")
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func recordAction() {
        
           
        
        
    }
    

    private func actionAttachMessage() {
        
        messageInputBar.inputTextView.resignFirstResponder()

        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction(title: "Camera", style: .default) { (alert) in
            
            self.showImageGalleryFor(camera: true)
        }
        
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert) in
            self.showImageGalleryFor(camera: false)
        }
        
        let invite = UIAlertAction(title: "Invite To Meet Up", style: .default) { (alert) in
           
            self.locationInvite()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(invite)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)

    }
    
    private func messageSend(text: String?, photo: UIImage?) {
        
        if photo == nil {
            
        } else {
            
            
        }
        
        UserService.uploadMessage(text, type: "text", to: discoverySetUp) { error in
            if let error = error {
                
                print("DEBUG: failed")
                
                return
                
                //inputView.clearMessagingText()//.messageInputTextView.text = nil
                
            }
            
            let title = "You've received a message."
            
            let body = "\(UserTwo.firstName) sent you a message."
            
            UserService.fetchActivity(to: self.discoverySetUp) { str in
                
                print("the activity string noted \(str)")
                
                if str == "inactive" {
                    
                    PushNotificationService.sendMessageToUser(sender: UserTwo.uid, chatRoomId: "", to: self.discoverySetUp.token, title: title, body: body)
                    
                } else {
                    
                    
                    
                }
                
                
            }
            
            
            
            
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
        
        //OutgoingMessage.send(chatId: chatId, text: text, photo: photo, memberIds: [FUser.currentId(), recipientId])
    }
    
    
    //MARK: - Download chats
    
    private func downloadChats() {
        
        UserService.fetchMessagesTwo(forUser: discoverySetUp) { messages, messagesTwo in
            
            self.mkmessagesTwo = messages
            
            self.mkmessages = messagesTwo
            
            print("the messages \(self.mkmessagesTwo) sep1 \(messages) sep2 \(self.mkmessages)")
            
            self.view.isUserInteractionEnabled = true
            
            DispatchQueue.main.async {
                
                self.messagesCollectionView.reloadData()
                
                self.messagesCollectionView.scrollToLastItem()
                
            }
        }
        
       
    }
    
    
  
    

 
  

    
    //MARK: - UIScrollViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if refreshController.isRefreshing {
            
            if displayingMessagesCount <  mkmessagesTwo.count {//loadedMessageDictionaries.count {
                
               // self.loadMoreMessages(maxNumber: maxMessageNumber, minNumber: minMessageNumber)
                messagesCollectionView.reloadDataAndKeepOffset()
            }
            
            refreshController.endRefreshing()
        }
    }


    
    //MARK: - Helpers
    

 
    
   
    
    func isLastSectionVisible() -> Bool {
        
        guard !mkmessagesTwo.isEmpty else {
            return false
        }
        
        let lastIndexPath = IndexPath(item: 0, section: mkmessagesTwo.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    //MARK: - Gallery
    
    private func showImageGalleryFor(camera: Bool) {
        /*
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = camera ? [.cameraTab] : [.imageTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        self.present(gallery, animated: true, completion: nil)
         */
       // alert.dismiss(animated: true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = false

                    present(imagePicker, animated: true, completion: nil)
                }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("image comes here")
        
        imagePicker.dismiss(animated: true, completion: nil)
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                print("image comes here2")
                UserService.uploadPhoto(image, to: self.discoverySetUp) { imageUrl in//{ error  in
                    
                    
                    
                    print("images coming soon2 \(imageUrl)")
                    
                    let title = "You've received a message."
                    
                    let body = "\(UserTwo.firstName) sent you a message."
                    
                    UserService.fetchActivity(to: self.discoverySetUp) { str in
                        
                        print("the activity string noted2 \(str)")
                        
                        if str == "inactive" {
                            
                            PushNotificationService.sendMessageToUser(sender: UserTwo.uid, chatRoomId: "", to: self.discoverySetUp.token, title: title, body: body)
                            
                        } else {
                            
                            
                            
                        }
                        
                        
                    }                }
            }

        }
    
    
    
        //MARK: - LocationInvite
    private func locationInvite() {
        
        let vc = MapInviteViewController()
        
        let navController = UINavigationController(rootViewController: vc)
        vc.delegate = self
        self.present(navController, animated:true, completion: nil)
        //self.present(vc, animated:true, completion: nil)
    }
      
}


extension ChatViewController : MessagesDataSource {
    
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {

        return mkmessagesTwo[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {

        return mkmessagesTwo.count
    }
    
    
    /*
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.section % 3 == 0 {

            let showLoadMore = (indexPath.section == 0) && mkmessagesTwo.count > displayingMessagesCount//loadedMessageDictionaries.count > displayingMessagesCount
            
            let text = showLoadMore ? "Pull to load more" : MessageKitDateFormatter.shared.string(from: message.sentDate)
            let font = showLoadMore ? UIFont.boldSystemFont(ofSize: 15) : UIFont.boldSystemFont(ofSize: 10)
            let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray
            
            return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
        }
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if isFromCurrentSender(message: message) {
            let message = mkmessagesTwo[indexPath.section]
            let status = indexPath.section == mkmessages.count - 1 ? message.status : ""
            
            return NSAttributedString(string: status, attributes: [.font : UIFont.boldSystemFont(ofSize: 10), .foregroundColor: UIColor.darkGray])
            
        }
        return nil
    }
     */
    
    
}



extension ChatViewController: MessageCellDelegate {
    
    /*
    @objc(didTapBackgroundIn:) func didTapBackground(in cell: MessageCollectionViewCell) {
    self.messageInputBar.inputTextView.resignFirstResponder()
    }
     */
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        
        let indexPath = messagesCollectionView.indexPath(for: cell)
        let msg = mkmessagesTwo[indexPath!.section]
        print("tap on audio message")
        
        switch msg.kind {
       
        case .audio(_):
            audioController?.mp3Player?.volume = 0.7
            if audioController?.state == .stopped {
                audioController!.playSound(for: msg, in: cell)
            } else if audioController?.state == .playing {
                audioController?.pauseSound(for: msg, in: cell)
            } else if audioController?.state == .pause {
                audioController?.resumeSound()
            }
        default:
            print("do nothing")
        }
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        
        let indexPath = messagesCollectionView.indexPath(for: cell)
        let msg = mkmessagesTwo[indexPath!.section]
        
        let msgTwo = mkmessages[indexPath!.section]
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
       
        
        print("tap on image message")
        
        switch msg.kind {
            
        case .audio(_):
            audioController?.mp3Player?.volume = 1.0
            if audioController?.state == .stopped {
                audioController!.playSound(for: msg, in: cell as! AudioMessageCell)
            } else if audioController?.state == .playing {
                audioController?.pauseSound(for: msg, in: cell as! AudioMessageCell)
            } else if audioController?.state == .pause {
                audioController?.resumeSound()
            }
        default:
            print("do nothing")
            if msg.invite == "true" {
                
                if msgTwo.fromId != currentUid{
                    
                    let alert = UIAlertController(title: "\(discoverySetUp.firstName) is inviting you out!", message: "Would you like to accept the invite to attend \(msgTwo.placeName) on \(msgTwo.date) at \(msgTwo.time)?", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        print("ok pressed for invite")
                        
                        self.dismiss(animated: true) {
                            
                            self.inviteDelegate?.saveInvite(date: msgTwo.date, time: msgTwo.time, name: msgTwo.placeName, discoverySetUp: self.discoverySetUp)
                            
                        }
                        
                            /*
                            
                             let vc =  EventViewController() //your view controller
                             vc.discoverySetUp = self.discoverySetUp
                             vc.inviteDateString = msgTwo.date
                             vc.inviteTimeString = msgTwo.time
                             vc.inviteTitle = msgTwo.placeName
                             vc.chatDelegate = self
                             
                             vc.modalPresentationStyle = .overFullScreen
                             
                             //self.navigationController?.pushViewController(vc, animated: true)
                             self.present(vc, animated: true, completion: nil)
                             
                            */
                       
                         
                    })
                    
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                        
                        print("cancel pressed for invite")
                        
                    }
                    
                    alert.addAction(ok)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
            }
            
        }
    }
    
}


extension ChatViewController: MessagesCollectionViewDelegate {
    func didTap() {
        
        print("touch for message")
        self.messageInputBar.inputTextView.resignFirstResponder()
    }
}



extension ChatViewController: MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key : Any] {
        
        switch detector {
        case .hashtag, .mention: return [.foregroundColor: UIColor.blue]
        default: return MessageLabel.defaultAttributes
        }
    }
    
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? MessageDefaults.bubbleColorOutgoing : MessageDefaults.bubbleColorIncoming
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }
    
}


extension ChatViewController: MessagesLayoutDelegate {
    
    /*
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if indexPath.section % 3 == 0 {
            
            if (indexPath.section == 0) && mkmessagesTwo.count > displayingMessagesCount {//loadedMessageDictionaries.count > displayingMessagesCount {
                
                return 40
            }
            
            return 18
        }
        
        return 0
    }
    */
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        print("sender stuff\(isFromCurrentSender(message: message))")
        
        return isFromCurrentSender(message: message) ? 17 : 0
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) {
        
        var imageURL : String = ""
        
        if UserTwo.uid == message.sender.senderId {
            
            imageURL = UserTwo.ava
            
        } else {
            
            imageURL = discoverySetUp.ava
            
        }
        
     
        
        print("image url here? \(imageURL) \(indexPath.section) messagetype \(message.sender.senderId) \(message.messageId)")
        
        /*
        if let url = URL(string: "\(imageURL)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    
                    avatarView.set(avatar: Avatar(image: UIImage(data: data), initials: "AB"))
                }
            }
            
            task.resume()
        }
       */
        
        if let url = URL(string: imageURL) {
            

            
            KingfisherManager.shared.retrieveImage(with: url) { result in
                let image = try? result.get().image
                if let image = image {
                   
                    avatarView.set(avatar: Avatar(image: image, initials: "AB"))
                    
                } else {
                    
                    avatarView.set(avatar: Avatar(image: UIImage(named: "avatar"), initials: "AB"))
                    
                    
                }
            }
            
        }
        
        
        //.set(avatar: Avatar(initials: mkmessages[indexPath.section].senderInitials))
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
        if text != "" {
            //typingIndicatorUpdate()
        }
    }
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        view.endEditing(true)
        
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                
                messageSend(text: text, photo: nil)
                
                
            }
        }
        
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
    
    
    
    
    
}


extension ChatViewController : GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            images.first!.resolve { (image) in
                print("images coming soon")
                UserService.uploadPhoto(image, to: self.discoverySetUp) { imageUrl in//{ error  in
                    /*
                    if let error = error {
                        
                        print("DEBUG: failed")
                        
                        return
    
                        
                    }
                    */
                    print("images coming soon2 \(imageUrl)")
                    
                    let title = "You've received a message."
                    
                    let body = "\(UserTwo.firstName) sent you a message."
                    
                    
                    
                    UserService.fetchActivity(to: self.discoverySetUp) { str in
                        
                        print("the activity string noted3 \(str)")
                        
                        if str == "inactive" {
                            
                            PushNotificationService.sendMessageToUser(sender: UserTwo.uid, chatRoomId: "", to: self.discoverySetUp.token, title: title, body: body)
                            
                        } else {
                            
                            
                            
                        }
                        
                        
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



