//
//  TimeLineModel.swift
//  DatingApp
//
//  Created by Scott Brown on 2/24/23.
//

import Foundation

struct TimeLineModel {
    
    var user_id : String = ""
    
    var text : String = ""
    
    var id : Int = 0
    
    var picture : String = ""
    
    var date_created : String = ""
    
    var firstName : String = ""
    
    var cover : String = ""
    
    var ava : String = ""
    
    var liked : Int = 0
    
  
  
    
    init (user_id: String, text: String, id : Int, picture: String, date_created : String, firstName : String, cover : String,  ava : String, liked: Int) {
        
        self.user_id = user_id
        self.text = text
        self.id = id
        self.picture = picture
        self.date_created = date_created
        self.firstName = firstName
        self.cover = cover
        self.ava = ava
        self.liked = liked
        
        
        
        
    }
    
    
    
}
