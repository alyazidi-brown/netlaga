//
//  DOBViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/17/22.
//

import UIKit

class DOBViewController: UIViewController, UITextFieldDelegate{
    
    var dayVar: String = ""
    var monthVar: String = ""
    var yearVar: String = ""
    
    let datePicker = UIDatePicker()
    
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
        label.text = "Date Of Birth"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    let missingLabel: UILabel = {
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
        label.text = ""
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }()
    
    
    
    lazy var dobTextField: UITextField = {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var fontSize: CGFloat = 0.0
        var height: CGFloat = 0.0
        switch (deviceIdiom) {

        case .pad:
            
            fontSize = 18
            height = 50
            
        case .phone:
            height = 30
            fontSize = 14
        default:
            height = 30
            fontSize = 14
           
        }
        
        
        let tf = UITextField()
        tf.textAlignment = .center
        
        tf.placeholder = "Date of Birth (dd/MM/yyyy)"
        
        let bottomLine = CALayer()
                
        bottomLine.frame = CGRect(x: 0.0, y: height + 3, width: 0.5*view.frame.width, height: 1.5)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
                
        tf.borderStyle = UITextField.BorderStyle.none
        tf.layer.addSublayer(bottomLine)
        
        
        return tf
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
        
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal) // Image can be downloaded from here below link
        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
        view.addSubview(backbutton)
        backbutton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 50, paddingLeft: 0, width: 40)
        
        
        configureUI()
        
        self.dobTextField.resignFirstResponder()
        
        
        
        showDatePicker()
        
    }
    
    func configureUI() {
        
        let stackTextField = UIStackView(arrangedSubviews: [dobTextField, missingLabel])
        stackTextField.axis = .vertical
        stackTextField.spacing = 5
        stackTextField.distribution = .equalSpacing
        
        
     
        let stackFirst = UIStackView(arrangedSubviews: [titleLabel, stackTextField, continueButton])
        stackFirst.axis = .vertical
        stackFirst.spacing = 50
        stackFirst.distribution = .fillProportionally
        
        view.addSubview(stackFirst)
        stackFirst.anchor(width: 0.5*view.frame.width)
        stackFirst.centerY(inView: view)
        stackFirst.centerX(inView: view)
        
    }
    
        // MARK: - Selectors
    
    
    func showDatePicker(){
        //Formate Date
        
        if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
        
        datePicker.datePickerMode = .date
        
        //self.datePicker.delegate = self
        //self.datePicker.dataSource = self
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        datePicker.isOpaque = false
        datePicker.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        datePicker.frame = CGRect(x: 10.0, y: 200.0, width: datePicker.frame.size.width - 20.0, height: 300.0)//CGRectMake(0, bounds.size.height - (datePickerHeight), _datePicker.frame.size.width, _datePicker.frame.size.height)
        
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.dateFormat = "dd-MM-yy"
        
        //self.datePicker.backgroundColor = UIColor(red: 84/255.0, green: 110/255.0, blue: 122/255.0, alpha: 0.87)
        
        //self.datePicker.inputView?.backgroundColor = UIColor(red: 84/255.0, green: 110/255.0, blue: 122/255.0, alpha: 0.87)

       //ToolBar
       let toolbar = UIToolbar();
       toolbar.sizeToFit()
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
       let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
       let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

     toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

      dobTextField.inputAccessoryView = toolbar
      dobTextField.inputView = datePicker

     }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            dayVar = "\(day)"
            monthVar = "\(month)"
            yearVar = "\(year)"
            
            print("dob is \(day) \(month) \(year)")
        }
    }

      @objc func donedatePicker(){

       let formatter = DateFormatter()
       formatter.dateFormat = "dd-MM-yy"
       dobTextField.text = formatter.string(from: datePicker.date)
       self.view.endEditing(true)
     }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
    
        
        
    @objc func continueAction() {
        
        if dobTextField.text == "" || dobTextField.text == "Date of Birth (dd/MM/yyyy)" {
            
            print("do you go here for date?")
           
            //self.missingLabel.isHidden = false
            self.missingLabel.text =  "Please Fill Out"
            
            
        } else {
            
            let dateComponentsFormatter = DateComponentsFormatter()
           
            
            var dateDifference: String = ""
            dateDifference = dateComponentsFormatter.difference(from: datePicker.date, to: Date() ) ?? "Dates Error" // "1 month"
            
            let dateArr = dateDifference.components(separatedBy: " ")

            let yearsElapsed: String = dateArr[0]
            
            let yearsElapsedInt: Int = Int(yearsElapsed) ?? 0
            

            print("date difference \(dateDifference)")
            
            if yearsElapsedInt < 18 {
                
                presentAlertController(withTitle: "Sorry", message: "You must be 18 years or older")
                
            } else {
                
                UserTwo.birthday = dobTextField.text ?? "01-01-01"
            
            
            let vc = ProfileImagesViewController() //your view controller
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
                
            }
            
        }
            
    }

    @objc func backAction() {
        print("It goes here")
        
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }

}



