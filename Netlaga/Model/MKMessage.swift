//
//  MKMessage.swift
//  DatingApp
//
//  Created by Scott Brown on 1/7/23.
//

import Foundation
import MessageKit
import Firebase

class MKMessage: NSObject, MessageType {
    var sentDate: Date
    
    
    var messageId: String
    var kind: MessageKind
    
    //var incoming: Bool
    var mksender: MKSender
    var sender: SenderType { return mksender }
    //var senderInitials: String
    
    var photoItem: PhotoMessage?
    var audioItem: AudioItem?
    var locationItem: LocationItem?
    var user: DiscoveryStruct?
    var invite: String
   // var status: String
    
    
    init(message: Message) {
        self.messageId = message.toId
        self.mksender = MKSender(senderId: message.fromId, displayName: "testname")//message.senderName)
        //self.status = message.status
        self.kind = message.kind//MessageKind.text(message.text)
        //self.senderInitials = message.senderInitials
        self.sentDate = message.timeStamp.dateValue()
        self.user = message.user
        self.photoItem = message.photoItem
        self.audioItem = message.audioItem
        self.locationItem = message.locationItem
        self.invite = message.invite
        //self.incoming = FUser.currentId() != mksender.senderId
    }
    
}

