//
//  GenderViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/18/22.
//

import UIKit

class GenderViewController: UIViewController {
    
    var selected : Bool = false
    
    var genderSelected : String = ""
    
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
        label.text = "I am a"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    private let femaleButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "Female.png"), for: .normal)
        
        button.addTarget(self, action: #selector(femaleSelection), for: .touchUpInside)
        
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
    
    private let maleButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "Male.png"), for: .normal)
        
        button.addTarget(self, action: #selector(maleSelection), for: .touchUpInside)
        
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
        
        
        let stackButtons = UIStackView(arrangedSubviews: [femaleButton, maleButton])
        stackButtons.axis = .horizontal
        stackButtons.spacing = 10
        stackButtons.distribution = .equalSpacing
     
        let stackFirst = UIStackView(arrangedSubviews: [titleLabel, stackButtons, continueButton])
        stackFirst.axis = .vertical
        stackFirst.spacing = 50
        stackFirst.distribution = .fillProportionally
        
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
                
                User.gender = genderSelected
            
            let vc = LookingViewController() //your view controller
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
                
            }
            
        }
    
    @objc func maleSelection() {
        
        print("male gender selected")
        
        selected = true
        
        genderSelected = "male"
        
        maleButton.backgroundColor = .gray
        
        femaleButton.backgroundColor = .white
        
    }
    
    @objc func femaleSelection() {
        
        print("female gender selected")
        
        selected = true
        
        genderSelected = "female"
        
        femaleButton.backgroundColor = .gray
        
        maleButton.backgroundColor = .white
        
    }
    
    

    @objc func backAction() {
        print("It goes here")
        
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }

}


