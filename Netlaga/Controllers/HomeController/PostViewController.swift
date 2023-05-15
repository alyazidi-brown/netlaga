//
//  PostViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 2/12/23.
//

import Foundation
import FirebaseAuth
import UIKit




class PostViewController: UIViewController, UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var textView = UITextView()
    
    var placeholderLabel = UILabel()
    
    var postButton = UIButton()
    
    var imageData = Data()
    
   
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            
            print("user id in post \(UserTwo.uid)")
            
            let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
            let displayWidth: CGFloat = self.view.frame.width
            let displayHeight: CGFloat = self.view.frame.height
            
            
            
            

            textView = UITextView(frame: CGRect(x: 0, y: barHeight + 300, width: displayWidth, height: displayHeight - (barHeight + 300)))
            
            self.view.addSubview(textView)
            
            

            textView.delegate = self
            
            
            placeholderLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 100, height: 50))//.frame.size = CGSize(width: 100, height: 50)

                   
                    placeholderLabel.text = "Enter some text..."
                    //placeholderLabel.font = .italicSystemFont(ofSize: (textView.font?.pointSize)!)
                    placeholderLabel.sizeToFit()
                    textView.addSubview(placeholderLabel)
                    //placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
                    placeholderLabel.textColor = .tertiaryLabel
                    placeholderLabel.isHidden = !textView.text.isEmpty
            
            postButton = UIButton(type: .custom)
            postButton.setImage(UIImage(named: "HomeCover.jpg"), for: .normal) // Image can be downloaded from here below line
            postButton.addTarget(self, action: #selector(self.postAction), for: .touchUpInside)
            view.addSubview(postButton)
            postButton.anchor(left: view.leftAnchor, bottom: textView.topAnchor, right: view.rightAnchor, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, height: 200)
            
            let backbutton = UIButton(type: .custom)
            backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
            backbutton.setTitle("Back", for: .normal)
            backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
            backbutton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
            view.addSubview(backbutton)
            backbutton.anchor(left: view.leftAnchor, bottom: postButton.topAnchor, paddingLeft: 0, paddingBottom: 0, width: 150, height: 40)
            
            let shareButton = UIButton(type: .system)
            shareButton.setTitle("Share", for: .normal)
            shareButton.setTitleColor(shareButton.tintColor, for: .normal) // You can change the TitleColor
            shareButton.addTarget(self, action: #selector(self.shareAction), for: .touchUpInside)
            view.addSubview(shareButton)
            shareButton.anchor(bottom: postButton.topAnchor, right: view.rightAnchor, paddingBottom: 0, paddingRight: 0, width: 150, height: 40)
            
        }
    
    func textViewDidChange(_ textView: UITextView) {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }

        
    
    @objc func postAction() {
        print("It goes here")
        
        let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = false //If you want edit option set "true"
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @objc func shareAction() {
        print("It goes here")
        
        let currentDate = Date()
        
        let dateString = currentDate.stringDate()
        
        guard let text = textView.text else { return }
        // STEP 1. Declare URL, Request and Params
        // url we gonna access (API)
        let url = URL(string: "https://netlaga.net/uploadPost.php")!
        
        // declaring reqeust with further configs
        var request = URLRequest(url: url)
        
        // POST - safest method of passing data to the server
        request.httpMethod = "POST"
        
        // values to be sent to the server under keys (e.g. ID, TYPE)
        //let params = ["user_id": User.uid, "type": "posts", "text": text, "date": dateString]
        let params = ["user_id": UserTwo.uid, "type": "posts", "text": text]
        //let params = ["id": id, "type": "ava"]
        print("params \(params)")
        
        // MIME Boundary, Header
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // if in the imageView is placeholder - send no picture to the server
        // Compressing image and converting image to 'Data' type
        
        
   
    
       
        
        // assigning full body to the request to be sent to the server
        request.httpBody = Helper().body(with: params, filename: "\(dateString)posts.jpg", filePathKey: "file", imageDataKey: imageData, boundary: boundary) as Data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                // error occured
                if error != nil {
                    Helper().showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                    return
                }
                
                
                do {
                    
                    // save mode of casting any data
                    guard let data = data else {
                        Helper().showAlert(title: "Data Error", message: error!.localizedDescription, from: self)
                        return
                    }
                    
                    let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("YOU THERE ESSAYposts? \(dataString)")
                    
                    // fetching JSON generated by the server - php file
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    
                    // save method of accessing json constant
                    guard let parsedJSON = json else {
                        return
                    }
                    
                    // uploaded successfully
                    if parsedJSON["status"] as! String == "200" {
                        
               
                            
                            if let error = error {
                                
                                print("firebase error here \(error.localizedDescription)")
                                    return
                                  }
                        
                        var timeLineAlert = UIAlertController(title: "Success!", message: "Your post has been made successfully!", preferredStyle: UIAlertController.Style.alert)

                        timeLineAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                          
                            
                            
                            let vc = HomeTabBarController() //your view controller
                            //vc.fromPost = true
                            vc.selectedIndex = 3
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true, completion: nil)
                            
                          }))

                        

                        self.present(timeLineAlert, animated: true, completion: nil)
                            
                        /*
                            let vc = HomeTabBarController()//HomeViewController() //your view controller
                                                       vc.modalPresentationStyle = .overFullScreen
                                                       self.present(vc, animated: true, completion: nil)
                                                       
                                                       print("why aren't we moving from here2")
                                                       
                            */
                        
                        
                        print("why aren't we moving from here")
                        
                       
                    // error while uploading
                    } else {
                        
                        // show the error message in AlertView
                        if parsedJSON["message"] != nil {
                            let message = parsedJSON["message"] as! String
                            Helper().showAlert(title: "Error", message: message, from: self)
                        }
                        
                    }
                    
                } catch {
                    Helper().showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
                }
                
            }
        }.resume()
        
       
    }
    
    
    @objc func backAction() {
        print("It goes here")
        
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //imgRoom.image  = tempImage
        
        guard let newImage = tempImage.resized() else { return }
        imageData = newImage.jpegData(compressionQuality: 0.5)!
        postButton.setImage(tempImage, for: .normal)
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    

}


   
