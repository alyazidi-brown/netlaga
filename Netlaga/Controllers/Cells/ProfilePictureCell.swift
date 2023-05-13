//
//  ProfilePictureCell.swift
//  Netlaga
//
//  Created by Scott Brown on 3/28/23.
//

class ProfilePictureCell: UICollectionViewCell {


    var profilePhotoImageView: UIImageView = {
        let theImageView = UIImageView()
        
        if #available(iOS 13.0, *) {
        theImageView.image = UIImage(named: "avatar.png")
        }else{
        let image = UIImage(named: "avatar.png")?.withRenderingMode(.alwaysTemplate)
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
    
    
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            addViews()
        }

        func addViews(){
            backgroundColor = UIColor.white

            addSubview(profilePhotoImageView)
            


            profilePhotoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
            profilePhotoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
            profilePhotoImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
            profilePhotoImageView.bottomAnchor.constraint(equalTo: topAnchor, constant: -5).isActive = true
            
            profilePhotoImageView.image = UIImage(named: "avatar.png")

            
        }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profilePhotoImageView.image = UIImage(named: "avatar.png")//nil
        
    }



        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }


}
