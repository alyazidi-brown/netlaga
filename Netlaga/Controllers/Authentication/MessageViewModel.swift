//
//  MessageViewModel.swift
//  DatingApp
//
//  Created by Scott Brown on 11/13/22.
//

import UIKit

struct MessageViewModel {

private let message: Message
    
    var messageBackgroundColor: UIColor {
        
        return message.isFromCurrentUser ? .lightGray : .systemPurple
    }
    
    var messageTextColor: UIColor {
        
        return message.isFromCurrentUser ? .black : .white
    }
    
    var rightAnchorActive: Bool {
        
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        
        return message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    var profileImageurl: URL? {
        
        guard let user = message.user else { return nil }
        return URL(string: user.ava)
    }

init(message: Message) {
    
    self.message = message
    
}

}
