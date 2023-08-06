//
//  CustomView.swift
//  Netlaga
//
//  Created by Scott Brown on 03/07/2023.
//

import UIKit

class customView: UIView {

    public var myLabel: UILabel?
    public var placeImageView: UIImageView?
    
    
    override init(frame: CGRect) {

        super.init(frame:frame)

        placeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width/2, height: self.frame.height))
        addSubview(placeImageView!)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
