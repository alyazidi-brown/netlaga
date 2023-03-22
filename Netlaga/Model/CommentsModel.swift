//
//  CommentsModel.swift
//  DatingApp
//
//  Created by Scott Brown on 3/16/23.
//

import Foundation

struct CommentsModel {
    
    var user_id : String = ""
    
    var text : String = ""
    
    var id : Int = 0
    
    var post_id : String = ""
    
    var picture : String = ""
    
    var date_created : String = ""
    
    var firstName : String = ""
    
    var cover : String = ""
    
    var ava : String = ""
    

    
  
  
    
    init (user_id: String, text: String, id : Int, picture: String, date_created : String, firstName : String, cover : String,  ava : String, post_id: String) {
        
        self.user_id = user_id
        self.text = text
        self.id = id
        self.picture = picture
        self.date_created = date_created
        self.firstName = firstName
        self.cover = cover
        self.ava = ava
        self.post_id = post_id
        
        
        
        
    }
    
    
    
}

