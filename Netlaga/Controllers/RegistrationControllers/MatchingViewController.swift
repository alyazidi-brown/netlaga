//
//  MatchingViewController.swift
//  bothApp
//
//  Created by Scott Brown on 8/18/22.
//

import Foundation
import UIKit

class MatchingViewController: UIViewController {
    
    var matchingBool: Bool = false
    
    var selected : Bool = false
    
    var matched: String = ""
    
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
        label.text = "Interested in..."
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    private let femalesButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Females", for: .normal)
        
        button.addTarget(self, action: #selector(femalesAction), for: .touchUpInside)
        
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
    
    private let malesButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Males", for: .normal)
        
        button.addTarget(self, action: #selector(malesAction), for: .touchUpInside)
        
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
    
    private let bothButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Both", for: .normal)
        
        button.addTarget(self, action: #selector(bothAction), for: .touchUpInside)
        
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
        
        
       
        let stackFirst = UIStackView(arrangedSubviews: [titleLabel, femalesButton, malesButton, bothButton, continueButton])
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
            
            if selected == false {
                
                self.presentAlertController(withTitle: "Please Select", message: "Please select a gender to proceed.")
                
            } else {
            
                UserTwo.matching = matched
            
            let vc = InterestsViewController() //your view controller
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            
            }
        }
    
  
    
    @objc func femalesAction() {
        
        selected = true
        
        matched = femalesButton.titleLabel!.text ?? "Empty"
            
            femalesButton.setTitleColor(.red, for: .normal)
            
            malesButton.setTitleColor(.black, for: .normal)
            
            bothButton.setTitleColor(.black, for: .normal)
        
    
    }
    
    @objc func malesAction() {
        
        selected = true
        
        matched = malesButton.titleLabel!.text ?? "Empty"
        
       
        femalesButton.setTitleColor(.black, for: .normal)
        
        malesButton.setTitleColor(.red, for: .normal)
        
        bothButton.setTitleColor(.black, for: .normal)
        
    }
    
    @objc func bothAction() {
        
        selected = true
        
        matched = bothButton.titleLabel!.text ?? "Empty"
        
        femalesButton.setTitleColor(.black, for: .normal)
        
        malesButton.setTitleColor(.black, for: .normal)
        
        bothButton.setTitleColor(.red, for: .normal)
        
    }
    

    @objc func backAction() {
        
        self.dismiss(animated: true, completion: nil)
        
    }

}


