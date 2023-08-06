//
//  ChatMessagesCollectionView.swift
//  Netlaga
//
//  Created by Scott Brown on 25/06/2023.
//

import MessageKit

protocol MessagesCollectionViewDelegate: AnyObject {
    func didTap()
}

class ChatMessagesCollectionView: MessagesCollectionView {
    weak var messagesCollectionViewDelegate: MessagesCollectionViewDelegate?
    
    override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        super.handleTapGesture(gesture) // Required for MessageCellDelegate methods to work
        messagesCollectionViewDelegate?.didTap()
    }
}

