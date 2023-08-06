//
//  InterestsCell.swift
//  Netlaga
//
//  Created by Scott Brown on 08/06/2023.
//

import Foundation
import UIKit

class InterestsCell: UICollectionViewCell {

/*
    


    let interestLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.text = "Interest"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()


    



    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
    }




    func addViews(){
        backgroundColor = UIColor.white

        addSubview(interestLabel)
        
        interestLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        interestLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        interestLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        interestLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
       


    }



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
 */
    
    var interestLabel:UILabel = {
        let label = UILabel()//(frame: CGRect(x:0, y: 30, width: contentView.frame.width - 10 , height: 40))
                label.textAlignment = .center
                label.lineBreakMode = .byWordWrapping
                label.numberOfLines = 0
        label.textColor = .black
                return label
            }()

            override init(frame: CGRect) {
                super.init(frame: frame)
                
                self.interestLabel.frame = CGRect(x:5, y: 5, width: contentView.frame.width - 10 , height: contentView.frame.height - 10)
                self.addSubview(self.interestLabel)
            }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
