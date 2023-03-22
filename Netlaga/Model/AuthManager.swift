//
//  AuthManager.swift
//  DatingApp
//
//  Created by Scott Brown on 8/2/22.
//

import FirebaseAuth
import Foundation

class AuthManager {
  
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private var verificationId: String?
        
    public func startAuth(phoneNumber:String, completion: @escaping (Bool) -> Void) {
       
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) {[weak self] verificationId, error in
            
            if let error = error {
                    //self.(error.localizedDescription)
                //presentAlertController(withTitle: "Oops An Error Occured", message: error.localizedDescription)
                
                print("phone error here \(error.localizedDescription)")
                    return
                  }
            
            guard let verificationId = verificationId, error == nil else {
                completion(false)
                return
            }
            
            self?.verificationId = verificationId
            completion(true)
            
        }
        
        
    }
    
    public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        
        guard let verificationId = verificationId else {
            completion(false)
            return
        }

        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)
    
    
    auth.signIn(with: credential) { result, error in
        guard result != nil, error == nil else {
            
            completion(false)
            return
        }
        
        completion(true)
        
        
    }
    
    
    
}
    
}
