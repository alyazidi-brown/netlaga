//
//  ProfileController.swift
//  Netlaga
//
//  Created by Scott Brown on 10/06/2023.
//

import Foundation
import UIKit
import Firebase
import GeoFire
import CoreLocation
import Alamofire
import FirebaseAuth
import FirebaseFirestore
import Kingfisher
import Photos
import Network
import NetworkExtension


class ProfileController: UIViewController {
    
    
    var person = DiscoveryStruct(firstName: "", email: "", ava: "", uid: "", place: "", token: "")
    
    let profilePhotoImageView: UIImageView = {
        
        let imageView = UIImageView()
        
        
        if #available(iOS 13.0, *) {
            imageView.image = UIImage(named: "user.png")
        }else{
            let image = UIImage(named: "user.png")?.withRenderingMode(.alwaysTemplate)
            imageView.image = image
            imageView.tintColor = UIColor.white
        }
        
        return imageView
    }()
    
    
    private let firstnameLabel: UILabel = {
        let label = UILabel()
        label.text = "firstname"
        label.font = UIFont(name: "Avenir-Light", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        print("this is the person \(person)")
        
        configureUI()
        
        populateUI(ava: person.ava, firstName: person.firstName)
        
    }
    
    @objc func backAction() {
        print("It goes here")
        
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    
    func configureUI() {
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
        
        
        view.addSubview(backbutton)
        backbutton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 0, width: 100, height: 70)
        
        view.addSubview(profilePhotoImageView)
        profilePhotoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 110, paddingLeft: 0, paddingRight: 0, height: 400)
        
        view.addSubview(firstnameLabel)
        firstnameLabel.anchor(top: profilePhotoImageView.bottomAnchor, paddingTop: 10, width: 250, height: 50)
        
        firstnameLabel.centerX(inView: view)
        
        
        
    }
    
    ////UI configuration
    func populateUI(ava: String, firstName: String) {
        
       
        let imageUrl = URL(string: ava)
        
        print("ava image \(ava)")
        /*
        AF.request(ava,method: .get).response{ response in

           switch response.result {
               
               
            case .success(let responseData):
               
               print("ava 3")
               
               DispatchQueue.main.async {
                   self.profilePhotoImageView.image = UIImage(data: responseData!, scale:1)
               }

            case .failure(let error):
                print("error--->",error)
            }
        }
         */
        
        self.profilePhotoImageView.kf.setImage(with: imageUrl)
        
     
        
        firstnameLabel.text = firstName
        
    }
    
    
    
}
