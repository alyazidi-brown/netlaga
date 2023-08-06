//
//  NewAuthButton.swift
//  Netlaga
//
//  Created by Scott Brown on 11/07/2023.
//

import UIKit

class NewAuthButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = frame.height/2//5
        backgroundColor = .white//UIColor(red:154/255.0, green: 27/255.0, blue: 27/255.0, alpha: 1.0)//.yellow//.green//.mainBlueTint
        setTitleColor(.black, for: .normal)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        let idiomHeight = UIScreen.main.bounds.height

        // 2. check the idiom
        switch (deviceIdiom) {

        case .pad:
            heightAnchor.constraint(equalToConstant: 40).isActive = true
            //print("iPad style UI")
        case .phone:
            if idiomHeight < 736.0 {
                heightAnchor.constraint(equalToConstant: 20).isActive = true
            } else {
                heightAnchor.constraint(equalToConstant: 25).isActive = true
                
            }
            
           // print("iPhone and iPod touch style UI")
       // case .tv:
           // print("tvOS style UI")
        default:
            heightAnchor.constraint(equalToConstant: 25).isActive = true
           // print("Unspecified UI idiom")
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
