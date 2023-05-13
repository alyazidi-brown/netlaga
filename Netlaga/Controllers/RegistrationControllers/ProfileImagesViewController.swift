//
//  ProfileImagesViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/17/22.
//
/*
import Foundation
import BSImagePicker
import UIKit
import Photos

class ProfileImagesViewController: UIViewController {
    
    var imageViewArr : [UIImageView] = []
    var imageCount : Int = 0
  
    let titleLabel: UILabel = {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var fontSize: CGFloat = 0.0
        
        switch (deviceIdiom) {

        case .pad:
            
            fontSize = 20
           
            
        case .phone:
           
            fontSize = 16
        default:
            
            fontSize = 16
           
        }
        
        let label = UILabel()
        label.text = "Upload Photos of Yourself"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    var button:UIButton =
    {
        let btn = UIButton()
    
    //cancelButton = UIButton(frame: CGRect(x: 0, y: self.innerView.frame.height-50, width: displayWidth, height: cancelButtonHeight))
    //self.innerView.addSubview(cancelButton)
    
        btn.setTitle("Upload", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(ImageAction),for: .touchUpInside)
        return btn
    }()
    
    
    
    var profilePhotoImageView: UIImageView = {
        let theImageView = UIImageView()
        
        if #available(iOS 13.0, *) {
        theImageView.image = UIImage(named: "BackButton.png")
        }else{
        let image = UIImage(named: "BackButton.png")?.withRenderingMode(.alwaysTemplate)
        theImageView.image = image
        theImageView.tintColor = UIColor.white
        }
           
           
           theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
        
        
        let idiomHeight = UIScreen.main.bounds.height
        if idiomHeight  < 736.0 {
            
            theImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
        } else {
            
            theImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true

        }
         
        
        
           return theImageView
        }()
    
    var profilePhotoImageViewTwo: UIImageView = {
        let theImageView = UIImageView()
        
        if #available(iOS 13.0, *) {
        theImageView.image = UIImage(named: "BackButton.png")
        }else{
        let image = UIImage(named: "BackButton.png")?.withRenderingMode(.alwaysTemplate)
        theImageView.image = image
        theImageView.tintColor = UIColor.white
        }
           
           
           theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
        
        
        let idiomHeight = UIScreen.main.bounds.height
        if idiomHeight  < 736.0 {
            
            theImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
        } else {
            
            theImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true

        }
         
        
        
           return theImageView
        }()
    
    
    var profilePhotoImageViewThree: UIImageView = {
        let theImageView = UIImageView()
        
        if #available(iOS 13.0, *) {
        theImageView.image = UIImage(named: "BackButton.png")
        }else{
        let image = UIImage(named: "BackButton.png")?.withRenderingMode(.alwaysTemplate)
        theImageView.image = image
        theImageView.tintColor = UIColor.white
        }
           
           
           theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
        
        
        let idiomHeight = UIScreen.main.bounds.height
        if idiomHeight  < 736.0 {
            
            theImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
        } else {
            
            theImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true

        }
         
        
        
           return theImageView
        }()
    
    var profilePhotoImageViewFour: UIImageView = {
        let theImageView = UIImageView()
        
        if #available(iOS 13.0, *) {
        theImageView.image = UIImage(named: "BackButton.png")
        }else{
        let image = UIImage(named: "BackButton.png")?.withRenderingMode(.alwaysTemplate)
        theImageView.image = image
        theImageView.tintColor = UIColor.white
        }
           
           
           theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
        
        
        let idiomHeight = UIScreen.main.bounds.height
        if idiomHeight  < 736.0 {
            
            theImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
        } else {
            
            theImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true

        }
         
        
        
           return theImageView
        }()
    
    var profilePhotoImageViewFive: UIImageView = {
        let theImageView = UIImageView()
        
        if #available(iOS 13.0, *) {
        theImageView.image = UIImage(named: "BackButton.png")
        }else{
        let image = UIImage(named: "BackButton.png")?.withRenderingMode(.alwaysTemplate)
        theImageView.image = image
        theImageView.tintColor = UIColor.white
        }
           
           
           theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
        
        
        let idiomHeight = UIScreen.main.bounds.height
        if idiomHeight  < 736.0 {
            
            theImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
        } else {
            
            theImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true

        }
         
        
        
           return theImageView
        }()
    
    
    var profilePhotoImageViewSix: UIImageView = {
        let theImageView = UIImageView()
        
        if #available(iOS 13.0, *) {
        theImageView.image = UIImage(named: "BackButton.png")
        }else{
        let image = UIImage(named: "BackButton.png")?.withRenderingMode(.alwaysTemplate)
        theImageView.image = image
        theImageView.tintColor = UIColor.white
        }
           
           
           theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
        
        
        let idiomHeight = UIScreen.main.bounds.height
        if idiomHeight  < 736.0 {
            
            theImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            
        } else {
            
            theImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true

        }
         
        
        
           return theImageView
        }()
    
    
    
    private let continueButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Continue", for: .normal)
        
        button.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        // 2. check the idiom
        switch (deviceIdiom) {

        case .pad:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
            //print("iPad style UI")
        case .phone:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
           // print("iPhone and iPod touch style UI")
       // case .tv:
           // print("tvOS style UI")
        default:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
           // print("Unspecified UI idiom")
        }
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        
        var backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: "backAction", for: .touchUpInside)
        view.addSubview(backbutton)
        backbutton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 50, paddingLeft: 0, width: 40)
        
        imageViewArr = [profilePhotoImageView, profilePhotoImageViewTwo, profilePhotoImageViewThree, profilePhotoImageViewFour, profilePhotoImageViewFive, profilePhotoImageViewSix]
        
        
        configureUI()
        
    }
    
    func configureUI() {
        
        
     
        let stackFirst = UIStackView(arrangedSubviews: [profilePhotoImageView, profilePhotoImageViewTwo, profilePhotoImageViewThree])
        stackFirst.axis = .horizontal
        stackFirst.spacing = 5
        stackFirst.distribution = .fillEqually
        
        
        
        let stackSecond = UIStackView(arrangedSubviews: [profilePhotoImageViewFour, profilePhotoImageViewFive, profilePhotoImageViewSix])
        stackSecond.axis = .horizontal
        stackSecond.spacing = 5
        stackSecond.distribution = .fillEqually
       
       
        
        let stackThird = UIStackView(arrangedSubviews: [titleLabel, button, stackFirst, stackSecond, continueButton])
        //let stackThird = UIStackView(arrangedSubviews: [stackFirst, continueButton])
        stackThird.axis = .vertical
        stackThird.spacing = 5
        stackThird.distribution = .fillProportionally
        
        view.addSubview(stackThird)
        stackThird.anchor(width: 0.9*view.frame.width, height: 0.8*view.frame.height)
        stackThird.centerY(inView: view)
        stackThird.centerX(inView: view)
        
    }
    
    // MARK: - Selectors
        
        
    @objc func continueAction() {
        
        /*
        if self.imageCount < 6 {
            
            self.presentAlertController(withTitle: "Need more Pictures", message: "Please Select More Pictures")
            
            
        } else {
         */
            
        let vc = GenderViewController() //your view controller
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
            
       // }
            
        }

    @objc func backAction() {
       
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func ImageAction() {
       
        let allAssets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                var evenAssets = [PHAsset]()

        print("here 1")
                allAssets.enumerateObjects({ (asset, idx, stop) -> Void in
                    if idx % 2 == 0 {
                        evenAssets.append(asset)
                    }
                })
        
        print("here 2")

                let imagePicker = ImagePickerController(selectedAssets: evenAssets)
                imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        print("here 3")
        
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
            print("selected \(asset)")
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
            print("deselected \(asset)")
        }, cancel: { (assets) in
            // User canceled selection.
            print("cancelled \(assets)")
        }, finish: { (assets) in
            // User finished selection assets.
            
            print("here 4")
            
            var imageData = Data()
            
            
            imageData = self.convertImageFromAsset(asset: assets[0]).jpegData(compressionQuality: 0.5)!
            
            User.avaImgData = imageData
            
            
            
            self.imageCount = assets.count
            
            print("here 5")
            
            for i in 0...assets.count - 1 {
                
                print("here 6")
                
                self.imageViewArr[i].image = self.convertImageFromAsset(asset: assets[i])
                
                print("here 7")
                
            }
            
            print("finished \(assets)")
        })
        
    }
    
    
    func convertImageFromAsset(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }


}

*/


