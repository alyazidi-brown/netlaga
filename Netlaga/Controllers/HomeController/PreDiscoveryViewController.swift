//
//  PreDiscoveryViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 10/4/22.
//

import UIKit
import Kingfisher
import FirebaseAuth
import GeoFire
import MapKit
import GoogleMaps
//import GooglePlaces
import Alamofire
import CoreLocation

protocol TinderDelegate: AnyObject {
    
    func switchToPersons()
    
    
}

class PreDiscoveryViewController: UITableViewController, CLLocationManagerDelegate{//UITableViewController, GMSMapViewDelegate {
    
    weak var delegate: TinderDelegate?
    
    var updateMessage: Bool = false
    
    var firstPlaceCheck: Bool = false
    
    var manager: CLLocationManager? = nil
    
    var placeArray = [PlaceList]()
    
    var shuffledList = [PlaceList]()
    
    var initialLocation = CLLocation()
    
    var trigger : Bool = true
    
    var n: Int = 0
    
    var activityView: UIActivityIndicatorView?
    
    /// View which contains the loading text and the spinner
    let loadingView = UIView()
    
    /// Spinner shown during load the TableView
    let spinner = UIActivityIndicatorView()
    
    /// Text shown during load the TableView
    let loadingLabel = UILabel()

    
    
    var placeTypeArr2 : [String] = ["airport", "amusement_park", "aquarium", "art_gallery", "bakery", "bank", "bar", "beauty_salon", "book_store", "bowling_alley", "bus_station", "cafe", "campground", "car_dealer", "car_wash", "casino", "cemetery", "church", "city_hall", "clothing_store", "convenience_store" , "courthouse", "dentist", "department_store", "doctor", "drugstore", "electronics_store", "embassy", "florist", "furniture_store", "gas_station", "gym", "hair_care", "hardware_store", "hindu_temple", "home_goods_store", "hospital", "jewelry_store", "laundry", "library", "light_rail_station", "liquor_store", "local_government", "office", "lodging", "mosque", "movie_theater", "muesum", "night_club", "park", "parking", "pet_store", "pharmacy", "physiotherapist", "post_office", "real_estate_agency", "restaurant", "rv_park", "secondary_school", "shoe_store", "shopping_mall", "spa", "stadium", "store", "subway_station", "supermarket", "synagogue", "taxi", "university", "veterinary_care", "zoo"]
    
    
    //var placesClient: GMSPlacesClient?
    //var likeHoodList: GMSPlaceLikelihoodList?
    
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
   
    
   

override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    tableView.register(TableCell2.self, forCellReuseIdentifier: "cell2")

    
    setLoadingScreen()

    
    //requestNearbyLocations()
    //googlePace(iteration: 0)
    
    findMe()
  
   

   
}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        findMe()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("DISAPPEAR TRIGGERED")
        
        stopMonitoringRegionAtLocation(center: UserTwo.location.coordinate, identifier: "Geofence")
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shuffledList.count
}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TableCell2
        
    let discoverySetUp = shuffledList[indexPath.row]
        
        
       
    cell.nameLabel.text = discoverySetUp.name
    cell.nameLabel.textAlignment = .center
    cell.nameLabel.textColor  = .black
    return cell
}

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
}
    
        // MARK: - Navigation & Pass Data
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let discoverySetUp = shuffledList[indexPath.row]
        
        if discoverySetUp.name == "Don't share place name" {
          
            UserTwo.place = ""
            
        } else {
            
            UserTwo.place = discoverySetUp.name
            
        }
        
        let token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
       
        
        let values = ["email": UserTwo.email, "firstName": UserTwo.firstName, "ava": UserTwo.ava, "token": token, "place": discoverySetUp.name]
        
        Database.database(url: "https://datingapp-80400-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("users").child(UserTwo.uid).updateChildValues(values) { error, ref in
        
            
           
            
            if let error = error {
                
                print("firebase error here \(error.localizedDescription)")
                    return
                  }
            
           
           // let nextVC = TinderViewController()//DiscoveryViewController()
            
    
            //nextVC.modalPresentationStyle = .overCurrentContext//.overFullScreen
            
            
            //let navController = UINavigationController(rootViewController: nextVC)
            
           // HomeTabBarController().present(nextVC, animated: true, completion: nil)
            //self.present(nextVC, animated:true, completion: nil)
            
           
            self.delegate?.switchToPersons()
                                       
            
        }

          
        }
    
    
    
    
 /*
  
    func googlePace(iteration: Int) {
        

        
       
        
        if placeTypeArr2[iteration] == "airport" {
            
            self.placeArray.removeAll()
            
            self.shuffledList.removeAll()
            
            //tableView.reloadData()
            
        }
      
        
        var latitudeString : String = ""
        
        var longitudeString : String = ""
        
        latitudeString = String(UserTwo.location.coordinate.latitude)
        
        longitudeString = String(UserTwo.location.coordinate.longitude)
        
        
        var http : String = ""
        
        ////radius is in metres
        http = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitudeString),\(longitudeString)&radius=20&type=\(placeTypeArr2[iteration])&key=AIzaSyAVAEwf8eLJ8yMZtX1NndYSuBWeqrEvEco"
        
        AF.request(http).responseJSON { responseData in
            
         print("checking")
           
            
            switch responseData.result {
              
               
                
            case .success(let dict):
                print("checking2")
                let successDict: [String: Any?] = dict as? [String: Any?] ?? [:]
                
                if let results = successDict["results"] as? [[String:Any]] {
                
                //let results = successDict["results"] as! [[String:Any]]
                    
                    print("checking32 \(results)")
                    
            for result in results {
                    
                print("checking3 ")
                
                let name = result["name"] as? String ?? ""
                let vicinity = result["vicinity"] as? String ?? ""
                        
                let place = PlaceList(name: name , address: vicinity, category: "\(self.placeTypeArr2[iteration])")
                        
                if !self.placeArray.contains(where: {$0.name == name}) &&  !self.placeArray.contains(where: {$0.address == vicinity}){
                   
                    self.placeArray.append(place)
                }
                        
                
                
                print("checking5 \(place)")
                      
            }
                    
                    print("checking6 \(self.placeTypeArr2[iteration])")
                   
                    if self.placeTypeArr2[iteration] == "zoo" {
                        
                        print("checking4")
                        
                        self.shuffledList = self.placeArray.shuffled()
                        
                      
                        for _ in 0..<self.shuffledList.count {
                            
                            print("seems like this is missing")
                            
                            
                            DispatchQueue.main.async {
                              
                            self.tableView.reloadData()
                                
                                self.removeLoadingScreen()
                                
                            }
                            
                        }
                        
                    }
                    
                }
               
                
                case .failure(let error):
                    
                print("checking failure \(error.localizedDescription)")
                    
                    print(error.localizedDescription)
                    
            }
            
            if self.placeTypeArr2[iteration] == "zoo" {
            
                self.n = 0
                
            } else {
  
            
                self.n = self.n + 1
                
                self.googlePace(iteration: self.n)
                
            }
            
        }
        
       
        
        
    }
  
  */
    
    func distanceCalculator(location: CLLocation) -> Double {
        
            //My location
        let myLocation = UserTwo.location//CLLocation(latitude: 59.244696, longitude: 17.813868)

            //My buddy's location
            let myBuddysLocation = location//CLLocation(latitude: 59.326354, longitude: 18.072310)

            //Measuring my distance to my buddy's (in km)
        let distance = myLocation.distance(from: myBuddysLocation)//myLocation.distance(from: myBuddysLocation) / 1000

            //Display the result in km
            //print(String(format: "The distance to my buddy is %.01fkm", distance))
        
            //Display the result in m
            print("The distance to my buddy is \(distance)m")
        
        return distance
    }
    
    func findMe() {
            // IMPORTANT 1. Add this to plist to allow tracking: NSLocationWhenInUseUsageDescription
            // IMPORTANT 2. Reset Simulator, then select Debug > Location > City Bycle Ride to trigger tracking (otherwise no locations)
        manager = CLLocationManager()
        manager!.delegate = self
        manager!.desiredAccuracy = kCLLocationAccuracyBest
        manager!.requestWhenInUseAuthorization()
        manager!.startUpdatingLocation()
            
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
               // self.locationTextField.text = "Navigation Tracking Not Authorized!"
            } else {
                print("LocationManager Authorized")
            }
        
        monitorRegionAtLocation(center: UserTwo.location.coordinate, identifier: "Geofence")
            
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
        let myLocation : CLLocation = locations[0]
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let myLocation2 = manager.location!
        print("locations = \(locValue.latitude) \(locValue.longitude) \(myLocation) \(myLocation2)")
        
        let longitude1 = locValue.longitude.roundToDecimal(10)
        
        let latitude1 = locValue.latitude.roundToDecimal(10)
        
        let myLocation3 = CLLocation(latitude: latitude1, longitude: longitude1)
        
        
        UserTwo.location = myLocation3
        
        requestNearbyLocations(latitude: latitude1, longitude: longitude1)
        
        
        }   // end of locationManager function

    
    
    
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        print("are you here again?")
           // Make sure the devices supports region monitoring.
           if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
               // Register the region.
               let maxDistance = CLLocationDistance(20)
               let region = CLCircularRegion(center: center,
                 radius: maxDistance, identifier: identifier)
               region.notifyOnEntry = false
               region.notifyOnExit = true
               
               manager!.startMonitoring(for: region)
            
           }
       }
    
    func stopMonitoringRegionAtLocation(center: CLLocationCoordinate2D, identifier: String) {
        print("are you here again2?")
           // Make sure the devices supports region monitoring.
           if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
               // Register the region.
               let maxDistance = CLLocationDistance(20)
               let region = CLCircularRegion(center: center,
                 radius: maxDistance, identifier: identifier)
               region.notifyOnEntry = false
               region.notifyOnExit = true
               manager!.stopUpdatingLocation()
               manager!.stopMonitoring(for: region)
            
           }
       }
    
    
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
       
    
    let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
    let myLocation2 = manager.location!
        
    print("locations2 = \(locValue.latitude) \(locValue.longitude)")
    
    let longitude1 = locValue.longitude.roundToDecimal(10)
    
    let latitude1 = locValue.latitude.roundToDecimal(10)
    
    let myLocation3 = CLLocation(latitude: latitude1, longitude: longitude1)
    
        print("locations3 = \(myLocation3) \(UserTwo.uid)")
        
        UserTwo.location = myLocation3
        
        let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
        
        
        if UserTwo.uid != nil && UserTwo.uid != "" {
            
            geofire.setLocation(myLocation3, forKey: UserTwo.uid, withCompletionBlock: { (error) in
                
                print("strange that you don't make it here2")
                
                if (error != nil) {
                    self.presentAlertController(withTitle: "Error", message: "\(error!.localizedDescription)")
                    
                    
                } else {
                    
                }
                
            })
            
        }
        
        print("are you here again3?")
        
        monitorRegionAtLocation(center: UserTwo.location.coordinate, identifier: "Geofence")
        
       // googlePace(iteration: 0)
        
        requestNearbyLocations(latitude: latitude1, longitude: longitude1)
        
       // loopTypes()
           
       }
    
        // Set the activity indicator into the main view
           private func setLoadingScreen() {

               // Sets the view which contains the loading text and the spinner
               let width: CGFloat = 120
               let height: CGFloat = 30
               let x = 100.0//tableView.frame.width / 2 - 60//(tableView.frame.width / 2) - (width / 2)
               let y = 50.0//tableView.frame.height / 2 //(tableView.frame.height / 2) - (height / 2) //- (navigationController?.navigationBar.frame.height)!
               loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

               // Sets loading text
               loadingLabel.textColor = .gray
               loadingLabel.textAlignment = .center
               loadingLabel.text = "Loading..."
               loadingLabel.frame = CGRect(x: tableView.frame.width / 2 - 70, y: 80, width: 140, height: 30)

               // Sets spinner
               spinner.style = .gray
               spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
               spinner.startAnimating()

               // Adds text and spinner to the view
               loadingView.addSubview(spinner)
               loadingView.addSubview(loadingLabel)

               tableView.addSubview(loadingView)

           }

           // Remove the activity indicator from the main view
           private func removeLoadingScreen() {

               // Hides and stops the text and the spinner
               spinner.stopAnimating()
               spinner.isHidden = true
               loadingLabel.isHidden = true

           }
    
    func requestNearbyLocations(latitude: Double, longitude: Double) {
            var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(latitude: UserTwo.location.coordinate.latitude, longitude: UserTwo.location.coordinate.longitude)
        
        print("region here \(region.center)")
        
        var address : String = ""
        
        let request = MKLocalPointsOfInterestRequest(center: region.center, radius: 20)
            //attempt 1
            //self.mapView.pointOfInterestFilter = .some(MKPointOfInterestFilter(including: []))
            //self.mapView.pointOfInterestFilter = .some(MKPointOfInterestFilter(excluding: [.restaurant, .cafe]))
            //attempt 2
           // let categories : [MKPointOfInterestCategory] = [.cafe, .restaurant]
           // let filters = MKPointOfInterestFilter(excluding: categories)
            //self.mapView.pointOfInterestFilter = .some(filters)
            
            let search = MKLocalSearch(request: request)
            search.start { (response , error ) in
                
                guard let response = response else {
                    
                    self.removeLoadingScreen()
                    
                    if self.updateMessage == false {
                        
                        self.updateMessage = true
                        
                        self.presentAlertController(withTitle: "Nothing Found", message: "Unfortunately no places of interest found in this area.")
                        
                        let noPlace = PlaceList(name: "Don't share place name", address: "", category: "none")
                        
                        self.shuffledList.append(noPlace)
                        
                        if self.shuffledList.count == 1 {
                            
                            self.delegate?.switchToPersons()
                            
                        } else {
                            
                            for _ in 0..<self.shuffledList.count {
                                
                                DispatchQueue.main.async {
                                    
                                    self.tableView.reloadData()
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                   
                    print("stoppingat this response?")
                    return
                }
                
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    
                    print("places coordinate \(item.placemark.coordinate) new1 \(item.placemark) new2 \(item.description) new3 \(item.placemark.locality) new4 \(item.placemark.administrativeArea) new5 \(item.placemark.subAdministrativeArea) new6 \(item.placemark.subLocality) new7 \(item.placemark.subThoroughfare) new8 \(item.placemark.thoroughfare) new9 \(item.placemark.address)")
                    
                    
                    if item.placemark.address != nil {
                        address = item.placemark.address!
                    } else {
                        
                        if item.placemark.thoroughfare != nil {
                            
                            if item.placemark.subThoroughfare != nil{
                                
                            address = "\(item.placemark.subThoroughfare) \(item.placemark.thoroughfare)"
                                
                            } else {
                               
                                address = "\(item.placemark.thoroughfare)"
                                
                            }
                            
                        } else {
                            
                            address = "Address Not Found"
                        }
                        
                    }
                  
                    
                    let place = PlaceList(name: item.name ?? "Name Unavailable", address: address, category: "none")
                    
                    
                    
                    print("places \(place)")
                    
                    if !self.placeArray.contains(where: {$0.name == place.name}) &&  !self.placeArray.contains(where: {$0.address == place.address}){
                     
                        self.placeArray.append(place)
                        
                        print("places2 \(self.placeArray)")
                        
                    }
                    
                      
                    /*
                    DispatchQueue.main.async {

                    self.tableView.reloadData()
                                        
                        self.removeLoadingScreen()
                        
                     
                     
                    }
                    */
                   // DispatchQueue.main.async {
                        //self.mapView.addAnnotation(annotation)
                  //  }
                    
                }
                
                self.shuffledList = self.placeArray//.shuffled()
                
                let noPlace = PlaceList(name: "Don't share place name", address: "", category: "none")
                
                self.shuffledList.append(noPlace)
                
                print("seems like this is missing2")
                
                if self.shuffledList.count == 1 {
                    
                    self.delegate?.switchToPersons()
                    
                } else {
                    
                    for _ in 0..<self.shuffledList.count {
                        
                        print("seems like this is missing")
                        
                        
                        DispatchQueue.main.async {
                            
                            self.tableView.reloadData()
                            
                            self.removeLoadingScreen()
                            
                        }
                        
                    }
                    
                }
                
            }
        
        
        
        }

}



/*
    
  
    
    
    func requestNearbyLocations() {
            var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(latitude: UserTwo.location.coordinate.latitude, longitude: UserTwo.location.coordinate.longitude)
        
        print("region here \(region.center)")
        
        var address : String = ""
        
        let request = MKLocalPointsOfInterestRequest(center: region.center, radius: 20)
            //attempt 1
            //self.mapView.pointOfInterestFilter = .some(MKPointOfInterestFilter(including: []))
            //self.mapView.pointOfInterestFilter = .some(MKPointOfInterestFilter(excluding: [.restaurant, .cafe]))
            //attempt 2
           // let categories : [MKPointOfInterestCategory] = [.cafe, .restaurant]
           // let filters = MKPointOfInterestFilter(excluding: categories)
            //self.mapView.pointOfInterestFilter = .some(filters)
            
            let search = MKLocalSearch(request: request)
            search.start { (response , error ) in
                
                guard let response = response else {
                    return
                }
                
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    
                    print("places coordinate \(item.placemark.coordinate) new1 \(item.placemark) new2 \(item.description) new3 \(item.placemark.locality) new4 \(item.placemark.administrativeArea) new5 \(item.placemark.subAdministrativeArea) new6 \(item.placemark.subLocality) new7 \(item.placemark.subThoroughfare) new8 \(item.placemark.thoroughfare) new9 \(item.placemark.address)")
                    
                    
                    if item.placemark.address != nil {
                        address = item.placemark.address!
                    } else {
                        
                        if item.placemark.thoroughfare != nil {
                            
                            if item.placemark.subThoroughfare != nil{
                                
                            address = "\(item.placemark.subThoroughfare) \(item.placemark.thoroughfare)"
                                
                            } else {
                               
                                address = "\(item.placemark.thoroughfare)"
                                
                            }
                            
                        } else {
                            
                            address = "Address Not Found"
                        }
                        
                    }
                  
                    
                    let place = PlaceList(name: item.name ?? "Name Unavailable", address: address, category: "none")
                    
                    print("places \(place)")
                    
                    self.placeArray.append(place)
                        
                    DispatchQueue.main.async {

                    self.tableView.reloadData()
                                        
                        
                                            
                    }
                    
                   // DispatchQueue.main.async {
                        //self.mapView.addAnnotation(annotation)
                  //  }
                    
                }
                
            }
        }
    */
