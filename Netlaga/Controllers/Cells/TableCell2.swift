//
//  TableCell2.swift
//  DatingApp
//
//  Created by Scott Brown on 10/4/22.
//

import UIKit

class TableCell2: UITableViewCell {

    
    
   
     
     
     let nameLabel : UILabel = {
     let lbl = UILabel()
     lbl.textColor = .black
     lbl.font = UIFont.boldSystemFont(ofSize: 16)
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
    
     
     
     
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
     super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
     addSubview(nameLabel)
     
        nameLabel.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 20, paddingRight: 20)
        
        nameLabel.centerYAnchor
    
        
    
     
     
    
     
     }
     
    required init?(coder aDecoder: NSCoder) {
        fatalError("We aren't using storyboards")
    }
}

