//
//  MessageCell.swift
//  DatingApp
//
//  Created by Scott Brown on 11/11/22.
//

import Foundation
import UIKit
import Kingfisher

class MessageCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var message: Message? {
        
        didSet { configure() }
    }
    
    var msgImageViewLeftAnchor: NSLayoutConstraint!
    var msgImageViewRightAnchor: NSLayoutConstraint!
    
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    private let profileImageView: UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let msgImageView: UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let textView : UITextView = {
        
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .white
        return tv
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple
        return view
    }()
    
    
    
        //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        //backgroundColor = .red
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, bottom: bottomAnchor,  paddingLeft: 8, paddingBottom: -4)
        profileImageView.setDimensions(height: 32, width: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        
        addSubview(msgImageView)
        msgImageView.layer.cornerRadius = 12
        msgImageView.anchor(top: topAnchor)
        msgImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        msgImageViewLeftAnchor = msgImageView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        msgImageViewLeftAnchor.isActive = true
        msgImageViewRightAnchor = msgImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        msgImageViewRightAnchor.isActive = true
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.anchor(top: topAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        bubbleLeftAnchor.isActive = true
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightAnchor.isActive = true
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        
        guard let message = message else { return }
        
        let viewModel = MessageViewModel(message: message)
        
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        textView.textColor = viewModel.messageTextColor
        
        textView.text = message.text
        
        if message.type == "picture" {
        
        FileStorage.downloadImage(imageUrl: message.mediaURL) { (image) in

            DispatchQueue.main.async {
            
            self.msgImageView.image = image
                
            }
            
        }
            
        }
        
        
        /*
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
         */
        profileImageView.isHidden = viewModel.shouldHideProfileImage
         
        let imageUrl = viewModel.profileImageurl
        
        
        
        
        profileImageView.kf.setImage(with: imageUrl)
        
        
    }
}
