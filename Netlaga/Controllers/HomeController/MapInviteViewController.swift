//
//  MapInviteViewController.swift
//  Netlaga
//
//  Created by Scott Brown on 4/29/23.
//

import Foundation
import UIKit
import MapKit
import GooglePlaces

protocol InviteLocationDelegate {
    func uploadLocation(location: CLLocation, locationImage: UIImage, date: String, time: String, placeName: String)
}

class MapInviteViewController: UIViewController, UISearchResultsUpdating, UITextFieldDelegate {
    
   
    var delegate: InviteLocationDelegate?
    var datePicker : UIDatePicker!
    var timePicker : UIDatePicker!
    
    var timeBool: Bool = false
    var dateBool: Bool = false
    
    var button = UIButton()
    
    var dateString: String = ""
    var timeString: String = ""
    
    var imageViewTapped = ""
    
    var inviteLocation = CLLocation()
    let mapView = MKMapView()
    var customView = UIView()
    let infoView = UIView()
    var placesClient = GMSPlacesClient()
    
    var views: [Any]?
    
    var calloutView = CustomCalloutView()
    
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Where would you like to Invite User?"
        view.addSubview(mapView)
        mapView.delegate = self
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        
        views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        calloutView = views?[0] as! CustomCalloutView
        calloutView.nameLabel.text = MapPlace.name
        
        calloutView.dateLabel.attributedPlaceholder = NSAttributedString(string: "Choose a Date")
        calloutView.timeLabel.attributedPlaceholder = NSAttributedString(string: "Choose a Time")
        
        calloutView.dateLabel.delegate = self
        calloutView.timeLabel.delegate = self
        //calloutView.dateLabel.text = "Choose a Date"
        //calloutView.timeLabel.text = "Choose a Time"
        //calloutView.starbucksPhone.text = "Invite?"
        calloutView.inviteButton.setTitle("Invite?", for: .normal)
        calloutView.inviteButton.isEnabled = false
        //button.isEnabled = false
        
        button = UIButton(frame: calloutView.inviteButton.frame)//UIButton(frame: CGRect(x: (calloutView.frame.height/2) + 10, y: calloutView.frame.height - 60, width: 60, height: 40))
        button.addTarget(self, action: #selector(MapInviteViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        calloutView.addSubview(button)
        
        
             
            
            datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        datePicker.datePickerMode = UIDatePicker.Mode.date
                   datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
            calloutView.dateLabel.inputView = datePicker
                   let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
                   let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
            toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
            calloutView.dateLabel.inputAccessoryView = toolBar
         
        
        timePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        
        timePicker.datePickerMode = UIDatePicker.Mode.time
        timePicker.addTarget(self, action: #selector(self.timeChanged), for: .allEvents)
        calloutView.timeLabel.inputView = timePicker
               let doneButtonTwo = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.timePickerDone))
               let toolBarTwo = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBarTwo.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButtonTwo], animated: true)
        calloutView.timeLabel.inputAccessoryView = toolBarTwo
        
        //[calloutView.dateLabel, calloutView.timeLabel].forEach({ $0.addTarget(self, action: #selector(textFieldEditingDidChange), for: .editingChanged) })
        calloutView.dateLabel.addTarget(self, action: #selector(MapInviteViewController.textFieldDidChange(_:)),for: .editingChanged)
             
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(x: 0.0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
    }
    
    func createSubview() {
        
        
    }
    
    /*
    @objc func textFieldEditingDidChange(sender: UITextField) {
                
                /*guard
                    let tfPasswordTxtValue = calloutView.dateLabel.text, !tfPasswordTxtValue.isEmpty, tfPasswordTxtValue != "Choose a Date",
                    let tfConfirmPasswordTextValue = calloutView.timeLabel.text, !tfConfirmPasswordTextValue.isEmpty, tfConfirmPasswordTextValue != "Choose a Time"*/
        /*
                        
        guard
            let tfPasswordTxtValue = calloutView.dateLabel.text, !tfPasswordTxtValue.isEmpty,
            let tfConfirmPasswordTextValue = calloutView.timeLabel.text, !tfConfirmPasswordTextValue.isEmpty else {
            calloutView.inviteButton.isEnabled = false
                    return
                }
        calloutView.inviteButton.isEnabled = true
         */
        
        let tfPasswordTxtValue = calloutView.dateLabel.text
        let tfConfirmPasswordTextValue = calloutView.timeLabel.text
        
        print("empty 1 \(tfPasswordTxtValue?.isEmpty) empty 2 \(tfConfirmPasswordTextValue)")
        
        if tfPasswordTxtValue?.isEmpty ?? false || tfConfirmPasswordTextValue?.isEmpty ?? false {
            
            print("here now")
            
            calloutView.inviteButton.isEnabled = false
            
        } else {
            
            print("here now2")
            
            calloutView.inviteButton.isEnabled = true
            
        }
        
        
        
            }
         */
    
    
    @objc func datePickerDone() {
        
        calloutView.dateLabel.resignFirstResponder()
        
        print("textfield gets me here2 \(calloutView.dateLabel)")
        
        dateBool = true
        
        if timeBool == true && dateBool == true && calloutView.timeLabel != nil && calloutView.dateLabel != nil && calloutView.timeLabel.text != "" && calloutView.dateLabel.text != "" && calloutView.timeLabel.text != "Choose a Time" && calloutView.dateLabel.text != "Choose a Date" {
            
            
            calloutView.inviteButton.isEnabled = true
            
        }
        
       }
    
    @objc func timePickerDone() {
        
        calloutView.timeLabel.resignFirstResponder()
        
        print("textfield gets me here3 \(calloutView.timeLabel)")
        
        timeBool = true
        
        if timeBool == true && dateBool == true && calloutView.timeLabel != nil && calloutView.dateLabel != nil && calloutView.timeLabel.text != "" && calloutView.dateLabel.text != "" && calloutView.timeLabel.text != "Choose a Time" && calloutView.dateLabel.text != "Choose a Date" {
            
            
            calloutView.inviteButton.isEnabled = true
            
        }
        
       }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

    }
    
    @objc func timeTextChange() {
        
        print("textfield gets me here")
        
        
    }

       @objc func dateChanged() {
           
           let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = .medium
           dateFormatter.timeStyle = .none
           dateFormatter.locale = Locale.current
           //print(dateFormatter.string(from: date)) // Jan 2, 2001
           
           calloutView.dateLabel.text = dateFormatter.string(from: datePicker.date)//"\(datePicker.date)"
           
           dateString = dateFormatter.string(from: datePicker.date)
       }
    
    @objc func timeChanged() {
        
        /*
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        //print(dateFormatter.string(from: date)) // Jan 2, 2001
        
        calloutView.dateLabel.text = dateFormatter.string(from: datePicker.date)//"\(datePicker.date)"
         */
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        calloutView.timeLabel.text = formatter.string(from: timePicker.date)
        
        timeString = formatter.string(from: timePicker.date)
    }
     
     
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, let resultsVC = searchController.searchResultsController as? ResultsViewController else {
            return
        }
        
        resultsVC.delegate = self
        
        GooglePlaceManager.shared.findPlaces(query: query) { result in
            switch result {
                
                
                
            case .success(let places):
                DispatchQueue.main.async {
                        resultsVC.update(with: places)
                }

                print(places)
            case .failure(let error):
                print(error)
            }
        }
            
        }
    
        // MARK - Action Handler
        @objc func callPhoneNumber(sender: UIButton)
        {
         
            var placeName : String = "Unknown Place"
            
            if MapPlace.name != nil {
                
                placeName = MapPlace.name!
                
                print("contact \(inviteLocation.coordinate.latitude) name \(MapPlace.name)")
                
            }
            
            //Delete this after
            //landmark(name: placeName, imageLandmark: InviteStruct.inviteImage!)
        
              //Put this back after test is over
        self.dismiss(animated: true) {
            self.delegate?.uploadLocation(location: self.inviteLocation, locationImage: InviteStruct.inviteImage!, date: self.dateString, time: self.timeString, placeName: placeName)
        }
            
        
       
        
        }
    
    func landmark(name: String, imageLandmark: UIImage) {
        
        var emptyString = "default"
        
        let url:URL = URL(string: "https://netlaga.net/landmark.php")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
   
    
    let paramString: String = "name=\(name)&image=\(emptyString)"
    
    
    print("param stuff \(paramString)")
      
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        
        //STEP 2.  Execute created above request.
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            let helper = Helper()
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil
                
                else {
                    //print("error")
                    if error != nil {
                        
                       
                        
                        helper.showAlert(title: "Server Error", message: error!.localizedDescription, from: self)
                    }
                    return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("YOU THERE ESSAY3? \(dataString)")
            
            DispatchQueue.main.async
                {
                    
                    
                    
                    do {
                        
                        guard let data = data else {
                           
                           // helper.showAlert(title: "Data Error", message: error!.localizedDescription, from: self)
                            
                            let alert = UIAlertController(title: "Data Error.  Something went wrong in sign up.  Please try again.", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                                print("Handle Ok logic here")
                                
                             
                              
                                }))

                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                            
                            return
                            
                             }
                  
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                        
                        // save method of accessing json constant
                        guard let parsedJSON = json else {
                            return
                        }
                        
                        // uploaded successfully
                        if parsedJSON["status"] as! String == "200" {
                            
                            // saving upaded user related information (e.g. ava's path, cover's path)
                            
                            let id =    parsedJSON["id"] as! String
                            let name = parsedJSON["name"] as! String
                            let image = parsedJSON["image"] as! String
                            
                            print("need to check that you go here \(id) \(name) \(image)")
                            
                          
                            
                            self.uploadImage(id: id, image: imageLandmark)
                            
                            
                            
                        // error while uploading
                        } else {
                            
                            // show the error message in AlertView
                            if parsedJSON["message"] != nil {
                                
                                let message = parsedJSON["message"] as! String
                                
                                //helper.showAlert(title: "JSON Error", message: message, from: self)
                                
                                
                                let alert = UIAlertController(title: "JSON Error.  Something went wrong in sign up.  Please try again.", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                                    print("Handle Ok logic here")
                                    
                                  
                                  
                                    }))

                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        
                    }
                    catch
                    {
                    
                    
                    helper.showAlert(title: "JSON Error", message: error.localizedDescription, from: self)
                        //print(error)
                    }
            }
            
            
            
        })
            
            .resume()
        
        
    }
    
    
    func uploadImage(id: String, image: UIImage) {
            
            imageViewTapped = "image"
            
            // STEP 1. Declare URL, Request and Params
            // url we gonna access (API)
            let url = URL(string: "https://netlaga.net/uploadImageLandmark.php")!
            
            // declaring reqeust with further configs
            var request = URLRequest(url: url)
            
            // POST - safest method of passing data to the server
            request.httpMethod = "POST"
            
            // values to be sent to the server under keys (e.g. ID, TYPE)
            let params = ["id": id, "type": imageViewTapped]
            //let params = ["id": id, "type": "ava"]
            
            // MIME Boundary, Header
            let boundary = "Boundary-\(NSUUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // if in the imageView is placeholder - send no picture to the server
            // Compressing image and converting image to 'Data' type
            var imageData = Data()
            
        var newImage = image
        
        print("image orientation2 \(newImage.imageOrientation)")
        
        if newImage.jpegData(compressionQuality: 0.8) != nil {
            
            imageData = newImage.jpegData(compressionQuality: 0.8)!//.pngData()!
            
            
            
        }
        
        //imageData = UserTwo.avaImgData
        
        let testImg = UIImage(data: imageData)
        
        let testOrientation = testImg?.imageOrientation
        
        print("here is the test orientation")
        
        let currentDate = generateCurrentTimeStamp()
            
            // assigning full body to the request to be sent to the server
            request.httpBody = Helper().body(with: params, filename: "\(imageViewTapped)\(currentDate).jpg", filePathKey: "file", imageDataKey: imageData, boundary: boundary) as Data
            
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
                        print("YOU THERE ESSAY5? \(dataString)")
                        
                        // fetching JSON generated by the server - php file
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                        
                        // save method of accessing json constant
                        guard let parsedJSON = json else {
                            
                            return
                        }
                        
                        // uploaded successfully
                        if parsedJSON["status"] as! String == "200" {
                            
                 
                           
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
    
    func generateCurrentTimeStamp () -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
            return (formatter.string(from: Date()) as NSString) as String
        }

    
}

extension MapInviteViewController: ResultsViewControllerDelegate{
    func didTapPlace(with coordinates: CLLocationCoordinate2D) {
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        //Remove all map pins
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        //Add a map pin
        print("map name \(MapPlace.name)")
        let pin = CustomAnnotation(coordinate: coordinates, title: "\(MapPlace.name)", subtitle: nil)//MKPointAnnotation()
        pin.title = MapPlace.name
        
        pin.coordinate = coordinates
       mapView.addAnnotation(pin)
        
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: true)
        
        //retrieve CLLocation
        
        
        let longitude1 = coordinates.longitude//.roundToDecimal(10)
        
        let latitude1 = coordinates.latitude//.roundToDecimal(10)
        
        inviteLocation = CLLocation(latitude: latitude1, longitude: longitude1)
        
    }
    
    
    
    
}

extension MapInviteViewController: MKMapViewDelegate {
    
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "Female")
        return annotationView
    }
    
    
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
    
    print("selected \(MapPlace.identifier) ")
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        // 2
    //let starbucksAnnotation = view.annotation as! CustomAnnotation
       
    
    ///retrieve photo of place
    // Specify the place data types to return (in this case, just photos).
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(UInt(GMSPlaceField.photos.rawValue)))
    
    

    placesClient.fetchPlace(fromPlaceID: MapPlace.identifier ?? "",
                             placeFields: fields,
                             sessionToken: nil, callback: {
      (place: GMSPlace?, error: Error?) in
      if let error = error {
        print("An error occurred: \(error.localizedDescription)")
        return
      }
      if let place = place {
        // Get the metadata for the first photo in the place photo metadata list.
          
          if place.photos != nil {
              
              if place.photos!.count > 0 {
                  
                  
                  let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]
                  
                  
                  // Call loadPlacePhoto to display the bitmap and attribution.
                  self.placesClient.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                      if let error = error {
                          // TODO: Handle the error.
                          print("Error loading photo metadata: \(error.localizedDescription)")
                          return
                      } else {
                          // Display the first image and its attributions.
                          // self.imageView?.image = photo;
                          print("place photos \(photo)")
                          self.calloutView.mapImageView.image = photo
                          //self.calloutView.starbucksImage.image = photo
                          
                          InviteStruct.inviteImage = photo
                          
                      }
                  })
              } else {
                  
                  self.calloutView.mapImageView.image = UIImage(named: "location")
                  //self.calloutView.starbucksImage.image = photo
                  
                  InviteStruct.inviteImage = UIImage(named: "location")
                  
              }
              
          } else {
              
              self.calloutView.mapImageView.image = UIImage(named: "location")
              //self.calloutView.starbucksImage.image = photo
              
              InviteStruct.inviteImage = UIImage(named: "location")
              
          }
      }
    })
    
    
       // calloutView.starbucksImage.image = UIImage(named: "Female")
    
    
    
    
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
     
    
    
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
}


/*
 func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     if annotation is MKUserLocation
     {
         return nil
     }
     var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
     if annotationView == nil{
         annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
         annotationView?.canShowCallout = false
     }else{
         annotationView?.annotation = annotation
     }
     annotationView?.image = UIImage(named: "Female")
     return annotationView
 }
 func mapView(_ mapView: MKMapView,
              didSelect view: MKAnnotationView)
 {
 
 print("selected \(MapPlace.identifier)")
     // 1
     if view.annotation is MKUserLocation
     {
         // Don't proceed with custom callout
         return
     }
     // 2
 let starbucksAnnotation = view.annotation as! CustomAnnotation
    
 let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
 let calloutView = views?[0] as! CustomCalloutView
 calloutView.starbucksName.text = MapPlace.name
 calloutView.starbucksAddress.text = "Choose a Date"
 calloutView.starbucksPhone.text = "Invite?"
 
 let button = UIButton(frame: calloutView.starbucksPhone.frame)//UIButton(frame: CGRect(x: (calloutView.frame.height/2) + 10, y: calloutView.frame.height - 60, width: 60, height: 40))
 button.addTarget(self, action: #selector(MapInviteViewController.callPhoneNumber(sender:)), for: .touchUpInside)
 calloutView.addSubview(button)
 
 ///retrieve photo of place
 // Specify the place data types to return (in this case, just photos).
     let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(UInt(GMSPlaceField.photos.rawValue)))
 
 

 placesClient.fetchPlace(fromPlaceID: MapPlace.identifier ?? "",
                          placeFields: fields,
                          sessionToken: nil, callback: {
   (place: GMSPlace?, error: Error?) in
   if let error = error {
     print("An error occurred: \(error.localizedDescription)")
     return
   }
   if let place = place {
     // Get the metadata for the first photo in the place photo metadata list.
     let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]

     // Call loadPlacePhoto to display the bitmap and attribution.
       self.placesClient.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
       if let error = error {
         // TODO: Handle the error.
         print("Error loading photo metadata: \(error.localizedDescription)")
         return
       } else {
         // Display the first image and its attributions.
        // self.imageView?.image = photo;
           
           calloutView.starbucksImage.image = photo
           
           InviteStruct.inviteImage = photo
         
       }
     })
   }
 })
 
 
    // calloutView.starbucksImage.image = UIImage(named: "Female")
 
 
 
 
     // 3
     calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
     view.addSubview(calloutView)
     mapView.setCenter((view.annotation?.coordinate)!, animated: true)
 }
 */
