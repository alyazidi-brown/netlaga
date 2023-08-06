//
//  PeopleFinderCell.swift
//  Netlaga
//
//  Created by Scott Brown on 09/06/2023.
//

import UIKit

protocol RequestDelegate: AnyObject {
    
    func requestPerson()
    
    
}

protocol RejectDelegate: AnyObject {
    
    func rejectPerson()
    
    
}

class PeopleFinderCell: UITableViewCell {

    var delegaterequest: RequestDelegate?
    
    var delegatereject: RejectDelegate?
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    
    let profileImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = 35
        img.clipsToBounds = true
        return img
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobTitleDetailedLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor =  .white
        label.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countryImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // without this your image will shrink and looks ugly
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 13
        img.clipsToBounds = true
        return img
    }()
    
     let tickButton: UIButton = {
        
        let button = UIButton(type: .custom)

         //button.setImage(UIImage(named: "tick")!.withRenderingMode(.automatic), for: .normal)
         button.setImage(#imageLiteral(resourceName: "tick").withRenderingMode(.alwaysOriginal), for: .normal)
        // button.setImage(UIImage(named: "tick"), for: .normal)
        
         
         //button.contentMode = .scaleAspectFill
         button.translatesAutoresizingMaskIntoConstraints = false
         button.layer.cornerRadius = 13
         button.clipsToBounds = true
        //button.addTarget(self, action: #selector(attachMessage), for: .touchUpInside)
        return button
        
    }()
    
    let xButton: UIButton = {
       
       let button = UIButton(type: .custom)

        //button.setImage(UIImage(named: "tick")!.withRenderingMode(.automatic), for: .normal)
        button.setImage(#imageLiteral(resourceName: "xcross").withRenderingMode(.alwaysOriginal), for: .normal)
       // button.setImage(UIImage(named: "tick"), for: .normal)
       
        
        //button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 13
        button.clipsToBounds = true
       //button.addTarget(self, action: #selector(attachMessage), for: .touchUpInside)
       return button
       
   }()
    
    


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.containerView.backgroundColor = .white
        
        self.contentView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(jobTitleDetailedLabel)
        self.contentView.addSubview(containerView)
        self.contentView.addSubview(xButton)
        self.contentView.addSubview(tickButton)
        
        profileImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant:70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant:70).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        jobTitleDetailedLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor).isActive = true
        jobTitleDetailedLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        jobTitleDetailedLabel.topAnchor.constraint(equalTo:self.nameLabel.bottomAnchor).isActive = true
        jobTitleDetailedLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        
        xButton.widthAnchor.constraint(equalToConstant:26).isActive = true
        xButton.heightAnchor.constraint(equalToConstant:26).isActive = true
        xButton.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-20).isActive = true
        xButton.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        
        
        tickButton.widthAnchor.constraint(equalToConstant:26).isActive = true
        tickButton.heightAnchor.constraint(equalToConstant:26).isActive = true
        tickButton.trailingAnchor.constraint(equalTo:xButton.leadingAnchor, constant:-20).isActive = true
        tickButton.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        
        
    }
    
    override func layoutSubviews()
    {
        
        super.layoutSubviews()
    
    
        xButton.addTarget(self, action: #selector(friendReject), for: .touchUpInside)
        
        tickButton.addTarget(self, action: #selector(friendRequest), for: .touchUpInside)
        
        
    }
    
    @objc func friendRequest() {
        
        self.delegaterequest?.requestPerson()
        print("friend requested")
        
    }
    
    @objc func friendReject() {
        
        self.delegatereject?.rejectPerson()
        print("friend rejected")
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

}

