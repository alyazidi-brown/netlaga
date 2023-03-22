//
//  UserModel.swift
//  DatingApp
//
//  Created by Scott Brown on 8/30/22.
//

import Foundation
/*
struct UserModel {
    
    
    
    var email : String = ""
    
    var phone : String = ""
    
    var gender : String = ""
    
    var birthday : String = ""
    
    var interests : String = ""
    
    var lookingFor : String = ""
    
    var matching : String = ""
    
    var Facebook_link : String = ""
    
    var cover : String = ""
    
    var ava : String = ""
    
    init (email : String, phone : String, gender : String, birthday : String, interests : String, lookingFor : String, Facebook_link : String, cover : String, ava : String) {
        
        
        self.email = email
        self.phone = phone
        self.gender = gender
        self.birthday = birthday
        self.interests = interests
        self.lookingFor = lookingFor
        self.Facebook_link = Facebook_link
        self.cover = cover
        self.ava = ava
        
        
    }
    
    
    
}
*/

struct UserModel {
    
    var status : String = ""
    
    var uid : String = ""
    
    var email : String = ""
    
    var firstName : String = ""
    
    var phoneNumber : String = ""
    
    var birthday : String = ""
    
    var gender : String = ""
    
    var Interested_In : String = ""
    
    var Facebook_link : String = ""
    
    var id : String = ""
    
    var ava : String = ""
    
  
    
    init (status: String, uid: String, email : String, firstName: String, phoneNumber : String, birthday : String, gender : String,  Interested_In : String, Facebook_link : String, id : String, ava : String) {
        
        self.status = status
        self.uid = uid
        self.email = email
        self.firstName = firstName
        self.phoneNumber = phoneNumber
        self.birthday = birthday
        self.gender = gender
        self.Interested_In = Interested_In
        self.Facebook_link = Facebook_link
        self.id = id
        self.ava = ava
        
        
        
    }
    
    
    
}
