//
//  Helper.swift
//  DatingApp
//
//  Created by Scott Brown on 8/16/22.
//

import Foundation
import UIKit

class Helper {
    
    func showAlert(title: String, message: String, from: UIViewController){
     
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: title, style: .cancel, handler: nil)
        
        alert.addAction(ok)
        from.present(alert, animated: true, completion: nil)
    }
    
    
        // MIME for the Image
        func body(with parameters: [String: Any]?, filename: String, filePathKey: String?, imageDataKey: Data, boundary: String) -> NSData {
            
            let body = NSMutableData()
            
            // MIME Type for Parameters [id: 777, name: michael]
            if parameters != nil {
                for (key, value) in parameters! {
                    body.append(Data("--\(boundary)\r\n".utf8))
                    body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                    body.append(Data("\(value)\r\n".utf8))
                }
            }
            
            
            // MIME Type for Image
            let mimetype = "image/jpg"
            
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".utf8))
            body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
            
            body.append(imageDataKey)
            body.append(Data("\r\n".utf8))
            body.append(Data("--\(boundary)--\r\n".utf8))
            
            return body
        }
    
}
