//
//  UserFirebase.swift
//  DatingApp
//
//  Created by Scott Brown on 9/26/22.
//

import Foundation


struct UserFirebase {
    let firstName: String
    let email: String
    let uid: String
    let ava: String
    let place: String
    
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.ava = dictionary["ava"] as? String ?? ""
        self.place = dictionary["place"] as? String ?? ""
        
    }
    
}
