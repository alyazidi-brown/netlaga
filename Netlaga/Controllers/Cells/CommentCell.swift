//
//  CommentCell.swift
//  DatingApp
//
//  Created by Scott Brown on 3/16/23.
//

import UIKit
import FirebaseAuth
import SwiftyComments




class CommentCell: UITableViewCell {
    
   


    let postText : UITextView = {
    let lbl = UITextView()
    lbl.textColor = .black
    lbl.font = UIFont.boldSystemFont(ofSize: 12)
    lbl.textAlignment = .left
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
        
      
    
        
     }

    required init?(coder aDecoder: NSCoder) {
        fatalError("We aren't using storyboards")
    }
    
    
    
    
    
}

