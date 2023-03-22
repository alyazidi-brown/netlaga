//
//  MatchObject.swift
//  DatingApp
//
//  Created by Scott Brown on 11/26/22.
//

import Foundation


struct MatchObject {
    
    let uid: String
    let uIds: [String]
    let date: Date
    
    var dictionary: [String : Any] {
        return ["objectId" : uid, "uIds" : uIds, "date" : date]
    }
    
    func saveToFireStore() {
        
        FirebaseReference(.Match).document(self.uid).setData(self.dictionary)
    }
}

