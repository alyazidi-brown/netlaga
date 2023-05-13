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





class ChatViewController: MessagesViewController, AudioRecorderVCDelegate, InviteLocationDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func uploadLocation(location: CLLocation, locationImage: UIImage) {
        print ("do you even go here location chat?")
        var latitudeStr: String = ""
        var longitudeStr: String = ""
        
        latitudeStr = "\(location.coordinate.latitude)"
        longitudeStr = "\(location.coordinate.longitude)"
        
        print ("latitude string \(latitudeStr) \(longitudeStr)")
        
        UserService.uploadMessage(inviteLatitude: latitudeStr, inviteLongitude: longitudeStr, type: "location", to: discoverySetUp) { error in
            if let error = error {
                
                print("DEBUG: failed")
                
                return
                
                //inputView.clearMessagingText()//.messageInputTextView.text = nil
                
            }
            
            let title = "You've received a message."
            
            let body = "\(User.firstName) sent you a message."
            
            PushNotificationService.sendMessageToUser(sender: "", chatRoomId: "", to: self.discoverySetUp.token, title: title, body: body)
            
            UserService.uploadPhoto(locationImage, to: self.discoverySetUp) { imageUrl in//{ error  in
                
                print(imageUrl)
                /*
                if error != nil {
                    
                    print("DEBUG: failed")
                    
                    return

                    
                }
                */
                
                UserService.uploadMessage("Wanna meet here? :D", type: "text", to: self.discoverySetUp) { error in
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
    
    let currentUser = MKSender(senderId: User.uid, displayName: User.firstName)
    
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
        super.viewDidLoad()
        
        print("right chat")
        
        view.backgroundColor = .white
        
        overrideUserInterfaceStyle = .light
        
        senderRoom = Auth.auth().currentUser?.uid ?? "userNotFound"
        
        setChatTitle()
        
        backButtonUI()
        
        configureLeftBarButton()
        configureMessageCollectionView()
        configureMessageInputBar()
        
        //downloadChats()
        
        audioController = AudioController(messageCollectionView: messagesCollectionView)
        
        /*
            //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        
        let tapTwo = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        

        view.addGestureRecognizer(tap)
        
        messagesCollectionView.addGestureRecognizer(tapTwo)
         */
    }
    
        //Calls this function when the tap is recognized.
        @objc func dismissKeyboard() {
            
            print("message view is being tapped.")
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            view.endEditing(true)
        }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadChats()
        deleteImage(discoveryStruct: discoverySetUp)
        //FirebaseListener.shared.resetRecentCounter(chatRoomId: chatId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("will disappear")
        //removeListeners()
        //FirebaseListener.shared.resetRecentCounter(chatRoomId: chatId)
    }
    
    //MARK: - Config
    private func configureLeftBarButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backButtonPressed))
        
        
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
        
        
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
        //messageInputBar.setStackViewItems([audioButton, messageInputBar.sendButton], forStack: .right, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([audioButton], forStack: .bottom, animated: false)
        
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
                            
                            let body = "\(User.firstName) sent you a message."
                            
                            PushNotificationService.sendMessageToUser(sender: "", chatRoomId: "", to: self.discoverySetUp.token, title: title, body: body)
                            
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
            
            let body = "\(User.firstName) sent you a message."
            
            PushNotificationService.sendMessageToUser(sender: "", chatRoomId: "", to: self.discoverySetUp.token, title: title, body: body)
            
            
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
        
        UserService.fetchMessagesTwo(forUser: discoverySetUp) { messages in
            
            self.mkmessagesTwo = messages
            
            print("the messages \(self.mkmessagesTwo) \(messages)")
            
            self.messagesCollectionView.reloadData()
            self.view.isUserInteractionEnabled = true
            self.messagesCollectionView.scrollToLastItem()
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
                    
                    let body = "\(User.firstName) sent you a message."
                    
                    PushNotificationService.sendMessageToUser(sender: "", chatRoomId: "", to: self.discoverySetUp.token, title: title, body: body)
                }
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
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        
        let indexPath = messagesCollectionView.indexPath(for: cell)
        let msg = mkmessagesTwo[indexPath!.section]
        print("tap on audio message")
        
        switch msg.kind {
       
        case .audio(_):
            audioController?.mp3Player?.volume = 1.0
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
        }
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
        
        if User.uid == message.sender.senderId {
            
            imageURL = User.ava
            
        } else {
            
            imageURL = discoverySetUp.ava
            
        }
        
     
        
        print("image url here? \(imageURL) \(indexPath.section) messagetype \(message.sender.senderId) \(message.messageId)")
        
        if let url = URL(string: "\(imageURL)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    
                    avatarView.set(avatar: Avatar(image: UIImage(data: data), initials: "AB"))
                }
            }
            
            task.resume()
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
                    
                    let body = "\(User.firstName) sent you a message."
                    
                    PushNotificationService.sendMessageToUser(sender: "", chatRoomId: "", to: self.discoverySetUp.token, title: title, body: body)
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



