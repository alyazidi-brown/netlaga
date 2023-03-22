//
//  Message.swift
//  DatingApp
//
//  Created by Scott Brown on 11/13/22.
//
import MessageKit
import Foundation
import Firebase

struct Message {
    let text: String
    let isFromCurrentUser: Bool
    let toId: String
    let fromId: String
    let type: String
    let mediaURL: String
    let mediaURLTwo: String
    var timeStamp: Timestamp!
    var user: DiscoveryStruct?
    var photoItem: PhotoMessage?
    var audioItem: AudioItem?
    var kind: MessageKind
    
    init(dictionary: [String: Any]) {
        
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.type = dictionary["type"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.mediaURLTwo = dictionary["mediaURLTwo"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.photoItem = dictionary["photoItem"] as! PhotoMessage
        self.audioItem = dictionary["audioItem"] as? AudioItem
        self.kind = dictionary["kind"] as! MessageKind
        
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}
