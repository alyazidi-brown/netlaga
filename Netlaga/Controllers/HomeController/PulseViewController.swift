//
//  PulseViewController.swift
//  Netlaga
//
//  Created by Scott Brown on 07/06/2023.
//

import Foundation
import UIKit
import Kingfisher
import Alamofire

protocol PeopleFinderDelegate: AnyObject {
    
    func peopleFinder()
    
    
}

class PulseViewController: UIViewController {

 
    weak var delegate: PeopleFinderDelegate?
    
    var timer = Timer()
    var timer2 = Timer()
    var timer3 = Timer()
    var timer4 = Timer()
    
    
    let imgvAvatar : UIImageView = {
     
        let imageView = UIImageView()
        
        
        
        if #available(iOS 13.0, *) {
            imageView.image = UIImage(named: "user.png")
        }else{
            let image = UIImage(named: "user.png")?.withRenderingMode(.alwaysTemplate)
            imageView.image = image
            imageView.tintColor = UIColor.white
        }
        
            return imageView
    }()
    
    let imgAvatar2 = UIImageView()
    
    var pulseLayers = [CAShapeLayer]()
   
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
      
      
  }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //
        imgAvatar2.frame = CGRect(x: (view.frame.width/2) - 50, y: (view.frame.height/2) - 50, width: 100, height: 100)
        imgAvatar2.clipsToBounds = false
        
        view.addSubview(imgAvatar2)
        
        //
        
        
        imgvAvatar.frame = CGRect(x: (imgAvatar2.frame.width/2) - 50, y: (imgAvatar2.frame.height/2) - 50, width: 100, height: 100)
              imgvAvatar.layer.borderWidth = 1
              imgvAvatar.layer.masksToBounds = false
              imgvAvatar.layer.borderColor = UIColor.blue.cgColor
              imgvAvatar.layer.cornerRadius = imgvAvatar.frame.size.width/2.0
              imgvAvatar.clipsToBounds = true
        
              imgAvatar2.addSubview(imgvAvatar)
        //view.addSubview(imgvAvatar)
        
        /*
        var newImage = UIImage()
        
        //newImage = UIImage(named: "user.png")!
        
        self.imgvAvatar.image = newImage
        
        AF.request(UserTwo.ava,method: .get).response{ response in

           switch response.result {
            case .success(let responseData):
               
               var interimImg = UIImage(data: responseData!, scale:1)
               
               let orientation = interimImg!.imageOrientation
               
               print("image orientation \(orientation)")
               if orientation.rawValue != 0 {
                   
                   print("where do you go \(orientation)")
                
                   newImage = UIImage(cgImage: interimImg!.cgImage!, scale: interimImg!.scale, orientation: .up)
                   
               } else {
                  
                   print("where do you go 2 \(orientation)")
                   
                   newImage = interimImg!
                   
               }
               
               
               DispatchQueue.main.async {
                   self.imgvAvatar.image = newImage
               }

            case .failure(let error):
                print("error--->",error)
            }
        }
         */
        
        downloadImage(urlString : UserTwo.ava){image in
             guard let image  = image else { return}
            
            
            var newImage = UIImage()
            
            let orientation = image.imageOrientation
            
            print("image orientation \(orientation)")
            if orientation.rawValue != 0 {
                
                print("where do you go \(orientation)")
             
            newImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .up)
                
            } else {
               
                print("where do you go 2 \(orientation)")
                
                newImage = image
                
            }
            
            //DispatchQueue.main.async {
                
                self.imgvAvatar.image = newImage
                
            //}
              // do what you need with the returned image.
         }
         
         
        
        
        createPulse()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        timer.invalidate()
        timer2.invalidate()
        timer3.invalidate()
        timer4.invalidate()
        
    }
    
    func downloadImage(urlString : String , imageCompletionHandler: @escaping (UIImage?) -> Void){
            guard let url = URL.init(string: urlString) else {
                return  imageCompletionHandler(nil)
            }
            let resource = ImageResource(downloadURL: url)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    imageCompletionHandler(value.image)
                case .failure:
                    imageCompletionHandler(UIImage(named: "user.png"))
                }
            }
        }
    
    func createPulse() {
        for _ in 0...2 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: UIScreen.main.bounds.size.width/2.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            let pulseLayer = CAShapeLayer()
            pulseLayer.path = circularPath.cgPath
            pulseLayer.lineWidth = 2.0
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.lineCap = CAShapeLayerLineCap.round
            pulseLayer.position = CGPoint(x: imgAvatar2.frame.size.width/2.0, y: imgAvatar2.frame.size.width/2.0)
            imgAvatar2.layer.addSublayer(pulseLayer)
            pulseLayers.append(pulseLayer)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
            self.animatePulse(index: 0)
            
            self.timer2 = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { timer2 in
                
                self.animatePulse(index: 1)
               
                self.timer3 = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer3 in
                    
                    self.animatePulse(index: 2)
                 
                    self.timer4 = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer4 in
                        
                        timer.invalidate()
                        timer2.invalidate()
                        timer3.invalidate()
                        timer4.invalidate()
                        
                        self.delegate?.peopleFinder()
                        
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                
            }
            
        }
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animatePulse(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.animatePulse(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  
                        self.animatePulse(index: 2)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        
                        self.delegate?.peopleFinder()
                        /*
                        let vc =  PeopleFinderController()//TinderViewController() //your view controller
                        
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                         */
                        
                    }
                      
                }
            }
        }*/
    }
    
    func animatePulse(index: Int) {
        pulseLayers[index].strokeColor = UIColor.black.cgColor

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(scaleAnimation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(opacityAnimation, forKey: "opacity")

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}
