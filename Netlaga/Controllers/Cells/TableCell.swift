//
//  TableCell.swift
//  DatingApp
//
//  Created by Scott Brown on 9/27/22.
//

import UIKit

protocol NewMessageControllerDelegate: class {
    
    //func controller(_ controller: DiscoveryViewController, wantsToStartChatWith user: DiscoveryStruct)
    
    func chatController(wantsToStartChatWith user: DiscoveryStruct)
}

protocol friendDelegate: class {
    
    
    func friendRequest(status: String, friend_id: String)
}

class TableCell: UITableViewCell {


    weak var delegate: NewMessageControllerDelegate?
    
    var delegateFriend: friendDelegate?
   
     
    var friend_id : String = ""
    
    var friendBool: Bool = false
     
     let nameLabel : UILabel = {
     let lbl = UILabel()
     lbl.textColor = .black
     lbl.font = UIFont.boldSystemFont(ofSize: 16)
     lbl.textAlignment = .left
     return lbl
     }()
    
    let locationLabel : UILabel = {
    let lbl = UILabel()
    lbl.textColor = .red
    lbl.font = UIFont.boldSystemFont(ofSize: 12)
    lbl.textAlignment = .left
    return lbl
    }()
     
    
    let profilePhotoImageView: UIImageView = {
        let theImageView = UIImageView()
        
        if #available(iOS 13.0, *) {
        theImageView.image = UIImage(named: "user.png")
        }else{
        let image = UIImage(named: "user.png")?.withRenderingMode(.alwaysTemplate)
        theImageView.image = image
        theImageView.tintColor = UIColor.white
        }
           
           
        theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
       
        
           return theImageView
        }()
    
    let unreadImageView: UIImageView = {
        let theImageView = UIImageView()
        
        if #available(iOS 13.0, *) {
        theImageView.image = UIImage(named: "blue_circle.png")
        }else{
        let image = UIImage(named: "blue_circle.png")?.withRenderingMode(.alwaysTemplate)
        theImageView.image = image
        theImageView.tintColor = UIColor.white
        }
           
           
        theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
       
        
           return theImageView
        }()
    
     var friendButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "unfriend.png"), for: .normal)
        
     
        return button
    }()
    
     
     
     
     /*
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
     super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    addSubview(profilePhotoImageView)
    addSubview(nameLabel)
    addSubview(locationLabel)
    addSubview(friendButton)
     
    profilePhotoImageView.anchor(left: leftAnchor, paddingLeft: 20, width: 50, height: 50)
        
    profilePhotoImageView.centerY(inView: contentView)
    
    nameLabel.anchor(top: topAnchor, left: profilePhotoImageView.rightAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 100, height: 50)
        
    locationLabel.anchor(top: nameLabel.bottomAnchor, left: profilePhotoImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 100)
    
    friendButton.anchor(right: rightAnchor, paddingRight: 20, width: 50, height: 50)
            
    friendButton.centerY(inView: contentView)
        
        friendButton.addTarget(self, action: #selector(friendRequest), for: .touchUpInside)
        
        contentView.isUserInteractionEnabled = true
     
    
     
     }
     
    required init?(coder aDecoder: NSCoder) {
        fatalError("We aren't using storyboards")
    }
    
   
   */
    
    override func layoutSubviews()
    {
        
        super.layoutSubviews()
    
    
    contentView.backgroundColor = .white
    friendButton.addTarget(self, action: #selector(friendRequest), for: .touchUpInside)
        
        
    }
    
    @objc func friendRequest() {
        
        print("just see what friend id would be \(friend_id)")
        
        if friendBool == false {
          
            friendButton.setImage(UIImage(named: "friend.png"), for: .normal)
            
            friendBool = true
            
            self.delegateFriend?.friendRequest(status: "add", friend_id: friend_id)
            
        } else {
            
            friendButton.setImage(UIImage(named: "unfriend.png"), for: .normal)
            
            friendBool = false
            
            self.delegateFriend?.friendRequest(status: "reject", friend_id: friend_id)
            
            
            
        }
      
        
    }
     
}
