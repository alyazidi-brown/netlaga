//
//  ProfileImagesViewController2.swift
//  Netlaga
//
//  Created by Scott Brown on 3/28/23.
//

import Foundation
import UIKit
import Photos
import Alamofire

class ProfileImagesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var imageViewArr : [UIImageView] = []
    var profileImageArr : [ProfilePhotosModel] = []
    var imageCount : Int = 0
    
    var collectionview: UICollectionView!
    
    var cellId = "ProfilePictureCell"
    
    let imagePickerController = UIImagePickerController()
  
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
        
        imagePickerController.delegate = self
        
            // Create an instance of UICollectionViewFlowLayout since you cant
            // Initialize UICollectionView without a layout
        
        var backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: "backAction", for: .touchUpInside)
        view.addSubview(backbutton)
        backbutton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 50, paddingLeft: 0, width: 40)
        
       
        
        configureUI()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 6
        }


        
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! ProfilePictureCell
        
        let profileImageCount = profileImageArr.count
    
        if profileImageCount > indexPath.row {
            
        let photoModel = profileImageArr[indexPath.row]
            
            DispatchQueue.main.async {
        
        cell.profilePhotoImageView.image = photoModel.profileImage//UIImage(named: "BackButton.png")
            
            }
           /*
            AF.request( photoModel.profileImage as! URLConvertible,method: .get).response{ response in

               switch response.result {
                case .success(let responseData):
                   cell.profilePhotoImageView.image = photoModel.profileImage

                case .failure(let error):
                    print("error--->",error)
                }
            }*/
            
        }
        return cell
    }
    

    
    
    func configureUI() {
        let stackThird = UIStackView(arrangedSubviews: [titleLabel, button])
        //let stackThird = UIStackView(arrangedSubviews: [stackFirst, continueButton])
        stackThird.axis = .vertical
        stackThird.spacing = 5
        stackThird.distribution = .fillProportionally
                
        view.addSubview(stackThird)
        stackThird.anchor(top: view.topAnchor, paddingTop: 50, width: 0.9*view.frame.width, height: 0.5*view.frame.height)
        stackThird.centerX(inView: view)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width/3, height: 50)
        
        var rect = CGRect(x: 0, y: view.frame.height/2 + 50, width: view.frame.width, height: 300)
    

        collectionview = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(ProfilePictureCell.self, forCellWithReuseIdentifier: cellId)
        collectionview.showsVerticalScrollIndicator = false
        collectionview.backgroundColor = UIColor.white
        self.view.addSubview(collectionview)
       
       
        //collectionview.anchor(top: stackThird.bottomAnchor, paddingTop: 5)
        
        
        view.addSubview(continueButton)
        continueButton.anchor(bottom: view.bottomAnchor, paddingBottom: 20, width: 100, height: 50)
        continueButton.centerX(inView: view)
        
        
        
    }
    
    @objc func backAction() {
       
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func ImageAction() {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            
            self.openCameraButton()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func openCameraButton() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera;
            imagePickerController.allowsEditing = false
            self.present(imagePickerController, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have image access", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let photoModel = ProfilePhotosModel(profileImage: imagePicked)
            
            profileImageArr.append(photoModel)
            
            if profileImageArr.count > 0 {
            
                UserTwo.avaImgData = profileImageArr[0].profileImage.pngData()!
                
            }
            
            print("profileImageArr", profileImageArr)
            
            if profileImageArr.count < 7 {
            
                collectionview.reloadData()
                
            }
            
        }
        
        picker.dismiss(animated: true) {
            
            
            print("Picker Dismissed...")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func continueAction() {
        
        let vc = GenderViewController() //your view controller
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
