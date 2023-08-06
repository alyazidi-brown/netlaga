//
//  LookingViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/18/22.
//

import Foundation
import UIKit

class LookingViewController: UIViewController {
    
    var friendsBool: Bool = false
    var networkingBool: Bool = false
    var datingBool: Bool = false
    
    var lookingArr : [String] = []
    
    let titleLabel: UILabel = {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var fontSize: CGFloat = 0.0
        
        switch (deviceIdiom) {

        case .pad:
            
            fontSize = 20
           
            
        case .phone:
           
            fontSize = 16
        default:
            
            fontSize = 16
           
        }
        
        let label = UILabel()
        label.text = "Looking For"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    private let friendsButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Friends", for: .normal)
        
        button.addTarget(self, action: #selector(friendsAction), for: .touchUpInside)
        
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
    
    private let networkingButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Networking", for: .normal)
        
        button.addTarget(self, action: #selector(networkingAction), for: .touchUpInside)
        
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
    
    private let datingButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Dating", for: .normal)
        
        button.addTarget(self, action: #selector(datingAction), for: .touchUpInside)
        
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
    
   
    
    private let continueButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Continue", for: .normal)
        
        button.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        
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
    
    private let dismissButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        var backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: "backAction", for: .touchUpInside)
        view.addSubview(backbutton)
        backbutton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 50, paddingLeft: 0, width: 40)
        
        
        configureUI()
        
    }
    
    func configureUI() {
        
        
       
        let stackFirst = UIStackView(arrangedSubviews: [titleLabel, friendsButton, networkingButton, datingButton, continueButton, dismissButton])
        stackFirst.axis = .vertical
        stackFirst.spacing = 50
        stackFirst.distribution = .equalSpacing
        
        view.addSubview(stackFirst)
        stackFirst.anchor(width: 0.9*view.frame.width)
        stackFirst.centerY(inView: view)
        stackFirst.centerX(inView: view)
        
    }
    
        // MARK: - Selectors
        
        
        @objc func continueAction() {
            
            if friendsBool == false && networkingBool == false &&  datingBool == false{
                
                self.presentAlertController(withTitle: "Please Select", message: "Please select an interest to proceed.")
                
            } else {
                
            let joined = lookingArr.joined(separator: ";")
                
                UserTwo.lookingFor = joined
            
            let vc = MatchingViewController() //your view controller
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
                
            }
            
        }
    
  
    
    @objc func friendsAction() {
        
        if friendsBool == false {
            
            friendsBool = true
            
            friendsButton.setTitleColor(.red, for: .normal)
            
            lookingArr.append((friendsButton.titleLabel?.text)!)
            
        } else {
            
            friendsBool = false
            
            friendsButton.setTitleColor(.black, for: .normal)
            
            for i in 0...lookingArr.count - 1 {
                
                if lookingArr[i] == friendsButton.titleLabel?.text{
                    
                    lookingArr.remove(at: i)
                    
                }
                
            }
            
        }
        
    
    }
    
    @objc func networkingAction() {
        
       
        if networkingBool == false {
            
            networkingBool = true
            
            networkingButton.setTitleColor(.red, for: .normal)
            
            lookingArr.append((networkingButton.titleLabel?.text)!)
            
        } else {
            
            networkingBool = false
            
            networkingButton.setTitleColor(.black, for: .normal)
            
            for i in 0...lookingArr.count - 1 {
                
                if lookingArr[i] == networkingButton.titleLabel?.text{
                    
                    lookingArr.remove(at: i)
                    
                }
                
            }
            
        }
       
    }
    
    @objc func datingAction() {
        
        if datingBool == false {
            
            datingBool = true
            
            datingButton.setTitleColor(.red, for: .normal)
            
            lookingArr.append((datingButton.titleLabel?.text)!)
            
        } else {
            
            datingBool = false
            
            datingButton.setTitleColor(.black, for: .normal)
            
            for i in 0...lookingArr.count - 1 {
                
                if lookingArr[i] == datingButton.titleLabel?.text{
                    
                    lookingArr.remove(at: i)
                    
                }
                
            }
            
        }
    }
    

    @objc func backAction() {
        
        self.dismiss(animated: true, completion: nil)
        
    }

}

