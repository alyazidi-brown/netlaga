//
//  FCollectionReference.swift
//  DatingApp
//
//  Created by Scott Brown on 11/26/22.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Like
    case Match
    case Recent
    case Messages
    case Typing
}


func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}

