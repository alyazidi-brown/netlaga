//
//  InputViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/17/22.
//

import UIKit
import Firebase

class InputViewController: UIViewController {
    

    
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
        label.text = "First Name"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    let missingLabel: UILabel = {
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
        label.text = ""
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    
  
    
    lazy var nameTextField: UITextField = {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var fontSize: CGFloat = 0.0
        var height: CGFloat = 0.0
        switch (deviceIdiom) {

        case .pad:
            
            fontSize = 18
            height = 50
            
        case .phone:
            height = 30
            fontSize = 14
        default:
            height = 30
            fontSize = 14
           
        }
        
        
        let tf = UITextField()
        
        tf.placeholder = "Jill"
        
        tf.textColor = .black
        
        let bottomLine = CALayer()
                
        bottomLine.frame = CGRect(x: 0.0, y: height + 3, width: 0.5*view.frame.width, height: 1.5)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
                
        tf.borderStyle = UITextField.BorderStyle.none
        tf.layer.addSublayer(bottomLine)
        
        
        return tf
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
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        User.uid = currentUid
        
        configureUI()
        
        self.nameTextField.resignFirstResponder()
        
    }
    
    func configureUI() {
        
        let stackTextField = UIStackView(arrangedSubviews: [nameTextField, missingLabel])
        stackTextField.axis = .vertical
        stackTextField.spacing = 5
        stackTextField.distribution = .equalSpacing
     
        let stackFirst = UIStackView(arrangedSubviews: [titleLabel, stackTextField, continueButton])
        stackFirst.axis = .vertical
        stackFirst.spacing = 50
        stackFirst.distribution = .fillProportionally
        
        view.addSubview(stackFirst)
        stackFirst.anchor(width: 0.5*view.frame.width)
        stackFirst.centerY(inView: view)
        stackFirst.centerX(inView: view)
        
       
        
    }
    
        // MARK: - Selectors
        
        
        @objc func continueAction() {
            
            if nameTextField.text == "" {
                
               
                self.missingLabel.text =  "Please Fill Out"
                
                
            } else {
                
                User.firstName = nameTextField.text ?? "First Name"
            
            let vc = DOBViewController() //your view controller
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
                
            }
            
        }
         
   


}


