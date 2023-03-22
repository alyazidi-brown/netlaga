//
//  Extensions.swift
//  DatingApp
//
//  Created by Scott Brown on 8/17/22.
//

import UIKit
import MapKit
import Firebase

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static let backgroundColor = UIColor.rgb(red: 25, green: 25, blue: 25)
    static let mainBlueTint = UIColor.rgb(red: 17, green: 154, blue: 237)
    static let outlineStrokeColor = UIColor.rgb(red: 33, green: 189, blue: 25)//UIColor.rgb(red: 234, green: 46, blue: 111)
    static let trackStrokeColor = UIColor.rgb(red: 25, green: 56, blue: 30)//UIColor.rgb(red: 56, green: 25, blue: 49)
    static let pulsatingFillColor = UIColor.rgb(red: 234, green: 228, blue: 46)//UIColor.rgb(red: 86, green: 30, blue: 63)
}

extension UIView {
    
    func checkBoxContainerView(checkBox: Checkbox? = nil, label: UITextView? = nil) -> UIView {
        let view = UIView()
        
        var textFieldHeight : CGFloat = 0.0
        var checkBoxHeight : CGFloat = 0.0
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        let idiomHeight = UIScreen.main.bounds.height
        // 2. check the idiom
        switch (deviceIdiom) {
    
        case .pad:
            textFieldHeight = 60
            checkBoxHeight = 30
        case .phone:
            checkBoxHeight = 15
            if idiomHeight < 736.0 {
                
                textFieldHeight = 30
            } else {
                
                textFieldHeight = 36
                
            }
        
        default:
            checkBoxHeight = 15
            textFieldHeight = 30
           // print("Unspecified UI idiom")
        }
        
        view.addSubview(checkBox!)
       
        checkBox!.centerY(inView: view)
        checkBox!.anchor(left: view.leftAnchor, paddingLeft: 8, width: checkBoxHeight, height: checkBoxHeight)
        
        view.addSubview(label!)
        //label!.centerY(inView: view)
       // label?.anchor(left: checkBox?.rightAnchor, bottom: view.bottomAnchor, top: view.topAnchor,
                      //right: view.rightAnchor, paddingLeft: 4, paddingBottom: 1, paddingTop: 0)
        label?.anchor(top: view.topAnchor, left: checkBox?.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        
        return view
    }
    
   
    
    func inputContainerView(image: UIImage, textField: UITextField? = nil, textField2: UITextField? = nil,
                            segmentedControl: UISegmentedControl? = nil, checkBox: Checkbox? = nil, label: UILabel? = nil) -> UIView {
        let view = UIView()
        
        var imageView = UIImageView()
        if #available(iOS 13.0, *) {
        
        imageView.image = image
        imageView.alpha = 0.87
        view.addSubview(imageView)
        }else{
        imageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = UIColor.white
        imageView.alpha = 0.87
        view.addSubview(imageView)
        }
        
        var textFieldHeight : CGFloat = 0.0
        var checkBoxHeight : CGFloat = 0.0
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        let idiomHeight = UIScreen.main.bounds.height
        // 2. check the idiom
        switch (deviceIdiom) {
    
        case .pad:
            textFieldHeight = 36
            checkBoxHeight = 30
        case .phone:
            checkBoxHeight = 15
            if idiomHeight < 736.0 {
                
                textFieldHeight = 18
            } else {
                
                textFieldHeight = 24
                
            }
        
        default:
            checkBoxHeight = 15
            textFieldHeight = 24
           // print("Unspecified UI idiom")
        }
        
        /*
        if let checkBox = checkBox {
            
            checkbox = Checkbox(frame: CGRect(x: 5, y: view.frame.height - 180, width: checkBoxHeight, height: checkBoxHeight))//(frame: CGRect(x: 5, y: view.frame.height - 40, width: 20, height: 20))
            
            view.addSubview(checkbox)
     
     
                checkbox.centerY(inView: view)
            checkbox.anchor(left: imageView.rightAnchor, paddingLeft: 4, widthAnchor: checkBoxHeight, heightAnchor: checkBoxHeight)
            
            view.addSubview(label)
            label.centerY(inView: view)
            label.anchor(left: checkbox.rightAnchor,
                             right: view.rightAnchor, paddingLeft: 4, paddingRight: 4)

                
        }
        */
        if let label = label {
            
            
        }
        
        if let textField = textField {
           
            imageView.centerY(inView: view)
            imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: textFieldHeight, height: textFieldHeight)
            
            view.addSubview(textField)
            textField.centerY(inView: view)
            textField.anchor(left: imageView.rightAnchor, bottom: view.bottomAnchor,
                             right: view.rightAnchor, paddingLeft: 4, paddingBottom: 1, paddingRight: -20)
        }
        
        if let textField2 = textField2 {
            imageView.centerY(inView: view)
            imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: textFieldHeight, height: textFieldHeight)
            
            view.addSubview(textField2)
            textField2.centerY(inView: view)
            textField2.anchor(left: imageView.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 4, paddingBottom: 1, paddingRight: -200)
        }
        
        if let sc = segmentedControl {
            imageView.anchor(top: view.topAnchor, left: view.leftAnchor,
                             paddingTop: -8, paddingLeft: 8, width: 24, height: 24)
            
            view.addSubview(sc)
            sc.anchor(left: view.leftAnchor, right: view.rightAnchor,
                     paddingLeft: 8, paddingRight: 8)
            sc.centerY(inView: view, constant: 8)
        }
        
       
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        view.addSubview(separatorView)
        separatorView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                             right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        let separatorView2 = UIView()
        separatorView2.backgroundColor = .lightGray
        view.addSubview(separatorView2)
        separatorView2.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                              right: view.rightAnchor, paddingLeft: 8, paddingRight: 200, height: 0.75)
        
        return view
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func anchorTwo(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat = 0,
                height: CGFloat = 0) -> [NSLayoutConstraint] {
      translatesAutoresizingMaskIntoConstraints = false

      var anchors = [NSLayoutConstraint]()

      if let top = top {
        anchors.append(topAnchor.constraint(equalTo: top, constant: paddingTop))
      }
      if let left = left {
        anchors.append(leftAnchor.constraint(equalTo: left, constant: paddingLeft))
      }
      if let bottom = bottom {
        anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom))
      }
      if let right = right {
        anchors.append(rightAnchor.constraint(equalTo: right, constant: -paddingRight))
      }
      if width > 0 {
        anchors.append(widthAnchor.constraint(equalToConstant: width))
      }
      if height > 0 {
        anchors.append(heightAnchor.constraint(equalToConstant: height))
      }

      anchors.forEach { $0.isActive = true }

      return anchors
    }
    
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, bottomAnchor: NSLayoutYAxisAnchor? = nil,
                 paddingBottom: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
    
    func applyShadow(radius: CGFloat,
                     opacity: Float,
                     offset: CGSize,
                     color: UIColor = .black) {
      layer.shadowRadius = radius
      layer.shadowOpacity = opacity
      layer.shadowOffset = offset
      layer.shadowColor = color.cgColor
    }
    
    func anchorToSuperview() -> [NSLayoutConstraint] {
      return anchorTwo(top: superview?.topAnchor,
                    left: superview?.leftAnchor,
                    bottom: superview?.bottomAnchor,
                    right: superview?.rightAnchor)
    }
}

extension UITextField {
    func textField(withPlaceholder placeholder: String, isSecureTextEntry: Bool) -> UITextField {
        var textFieldFont : CGFloat = 0.0
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        let idiomHeight = UIScreen.main.bounds.height
        print("idiomheight \(idiomHeight)")
        // 2. check the idiom
        switch (deviceIdiom) {

        case .pad:
            textFieldFont = 24
            //print("iPad style UI")
        case .phone:
            
            if idiomHeight < 736.0 {
                textFieldFont = 8
            } else {
                textFieldFont = 16
                
            }
            textFieldFont = 16
           // print("iPhone and iPod touch style UI")
       // case .tv:
           // print("tvOS style UI")
        default:
            textFieldFont = 16
           // print("Unspecified UI idiom")
        }
        
        print("text font \(textFieldFont)")
        
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: textFieldFont)
        tf.textColor = .white
        tf.keyboardAppearance = .dark
        tf.isSecureTextEntry = isSecureTextEntry
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        return tf
    }
}

extension MKPlacemark {
    var address: String? {
        get {
            guard let subThoroughfare = subThoroughfare else { return nil }
            guard let thoroughfare = thoroughfare else { return nil }
            guard let locality = locality else { return nil }
            guard let adminArea = administrativeArea else { return nil }
            
            return "\(subThoroughfare) \(thoroughfare), \(locality), \(adminArea) "
        }
    }
}

extension MKMapView {
    func zoomToFit(annotations: [MKAnnotation]) {
        var zoomRect = MKMapRect.null
        
        annotations.forEach { (annotation) in
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y,
                                      width: 0.01, height: 0.01)
            zoomRect = zoomRect.union(pointRect)
        }
        
        let insets = UIEdgeInsets(top: 100, left: 100, bottom: 300, right: 100)
        setVisibleMapRect(zoomRect, edgePadding: insets, animated: true)
    }
    
    func addAnnotationAndSelect(forCoordinate coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        addAnnotation(annotation)
        selectAnnotation(annotation, animated: true)
    }
}

extension UIViewController {
    func presentAlertController(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func shouldPresentLoadingView(_ present: Bool, message: String? = nil) {
        if present {
            let loadingView = UIView()
            loadingView.frame = self.view.frame
            loadingView.backgroundColor = .black
            loadingView.alpha = 0
            loadingView.tag = 1
            
            let indicator = UIActivityIndicatorView()
            if #available(iOS 13.0, *) {
                indicator.style = .large
            } else {
                // Fallback on earlier versions
            }//.whiteLarge
            indicator.center = view.center
            
            let label = UILabel()
            label.text = message
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = .white
            label.textAlignment = .center
            label.alpha = 0.87
            
            view.addSubview(loadingView)
            loadingView.addSubview(indicator)
            loadingView.addSubview(label)
            
            label.centerX(inView: view)
            label.anchor(top: indicator.bottomAnchor, paddingTop: 32)
            
            indicator.startAnimating()
            
            UIView.animate(withDuration: 0.3) {
                loadingView.alpha = 0.7
            }
        } else {
            view.subviews.forEach { (subview) in
                if subview.tag == 1 {
                    UIView.animate(withDuration: 0.3, animations: {
                        subview.alpha = 0
                    }, completion: { _ in
                        subview.removeFromSuperview()
                    })
                }
            }
        }
    }
    
    func configureNavigationBar(withTitle title: String, prefersLargeTitles: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemPurple
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
}


extension Firestore {
    var categories: Query {
        return collection("categories").order(by: "timeStamp", descending: true)
    }
    
    func products(category: String) -> Query {
        return collection("products").whereField("category", isEqualTo: category).order(by: "timeStamp", descending: true)
    }
}

extension Auth {
    func handleFireAuthError(error: Error, vc: UIViewController) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
        }
    }
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account. Pick another email!"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password or email is incorrect."
            
        default:
            return "Sorry, something went wrong."
        }
    }
}

extension DateComponentsFormatter {
    
    func difference(from fromDate: Date, to toDate: Date) -> String? {
        self.allowedUnits = [.year,.month,.weekOfMonth,.day]
        self.maximumUnitCount = 1
        self.unitsStyle = .full
        return self.string(from: fromDate, to: toDate)
    }
}

extension Date {
    
    func longDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyyHHmmss"
        return dateFormatter.string(from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0}
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0}

        return end - start
    }
}




