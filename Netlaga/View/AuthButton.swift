//
//  AuthButton.swift
//  DatingApp
//
//  Created by Scott Brown on 8/17/22.
//

import UIKit

class AuthButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        backgroundColor = UIColor(red:255/255.0, green: 215/255.0, blue: 0/255.0, alpha: 1.0)//.yellow//.green//.mainBlueTint
        setTitleColor(.black, for: .normal)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        let idiomHeight = UIScreen.main.bounds.height

        // 2. check the idiom
        switch (deviceIdiom) {

        case .pad:
            heightAnchor.constraint(equalToConstant: 80).isActive = true
            //print("iPad style UI")
        case .phone:
            if idiomHeight < 736.0 {
                heightAnchor.constraint(equalToConstant: 40).isActive = true
            } else {
                heightAnchor.constraint(equalToConstant: 50).isActive = true
                
            }
            
           // print("iPhone and iPod touch style UI")
       // case .tv:
           // print("tvOS style UI")
        default:
            heightAnchor.constraint(equalToConstant: 50).isActive = true
           // print("Unspecified UI idiom")
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
