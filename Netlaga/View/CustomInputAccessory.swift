//
//  CustomInputAccessory.swift
//  DatingApp
//
//  Created by Scott Brown on 11/10/22.
//

import Foundation
import UIKit
import Kingfisher

protocol CustomInputAccessoryViewDelegate: class {
    
    func inputView(_ inputView: CustomInputAccessory, wantsToSend message: String)
    
    func attachView(_ inputView: CustomInputAccessory)
}

class CustomInputAccessory: UIView {
    
    //MARK: - Properties
    
    weak var delegate: CustomInputAccessoryViewDelegate?

   private lazy var messageInputTextView: UITextView = {
        
        let tv = UITextView()
        
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let attachButton: UIButton = {
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        
        let image = UIImage(named: "attach")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        if #available(iOS 13.0, *) {
        button.tintColor = UIColor.systemBlue
        } else {
            button.tintColor = UIColor.white
        }
        button.addTarget(self, action: #selector(attachMessage), for: .touchUpInside)
        return button
        
    }()
    
    private let sendButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.systemPurple, for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
        
    }()
    
    private let placeHolder: UILabel = {
        
        let label = UILabel()
        label.text = "Enter Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4,paddingRight: 8)
        
        sendButton.setDimensions(height: 50, width: 50)
        
        addSubview(attachButton)
        attachButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 4,paddingLeft: 8)
        
        attachButton.setDimensions(height: 50, width: 50)
        
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top: topAnchor, left: attachButton.rightAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 12, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        addSubview(placeHolder)
        placeHolder.anchor(left: messageInputTextView.leftAnchor, paddingLeft: 4)
        placeHolder.centerY(inView: messageInputTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var intrinsicContentSize: CGSize {
        
        return .zero
    }
    
    @objc func handleTextInputChange() {
        
        print("DEBUG: New Handle send message here....")
        
        placeHolder.isHidden = !self.messageInputTextView.text.isEmpty
    }
    
    @objc func handleSendMessage() {
        
        guard let message = messageInputTextView.text else {return}
        
        delegate?.inputView(self, wantsToSend: message)
        
        //print("DEBUG: Handle send message here....")
    }
    
    @objc func attachMessage() {
      
        delegate?.attachView(self)
       
    }
    
    func clearMessagingText() {
        messageInputTextView.text = nil
        placeHolder.isHidden = false
        
    }
    
}
