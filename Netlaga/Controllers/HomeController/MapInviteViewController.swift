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
    func uploadLocation(location: CLLocation, locationImage: UIImage)
}

class MapInviteViewController: UIViewController, UISearchResultsUpdating {
    
   
    var delegate: InviteLocationDelegate?
    
    var inviteLocation = CLLocation()
    let mapView = MKMapView()
    let infoView = UIView()
    var placesClient = GMSPlacesClient()
    
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Where would you like to Invite User?"
        view.addSubview(mapView)
        mapView.delegate = self
        searchVC.searchBar.backgroundColor = .secondarySystemBackground
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(x: 0.0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
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
        print("contact \(inviteLocation.coordinate.latitude)")
        
        self.dismiss(animated: true) {
            self.delegate?.uploadLocation(location: self.inviteLocation, locationImage: InviteStruct.inviteImage!)
        }
        
       
        
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
    calloutView.starbucksAddress.text = "starbucksAnnotation.address"
    calloutView.starbucksPhone.text = "starbucksAnnotation.phone"
    
    let button = UIButton(frame: calloutView.starbucksPhone.frame)//UIButton(frame: CGRect(x: (calloutView.frame.height/2) + 10, y: calloutView.frame.height - 60, width: 60, height: 40))
    button.addTarget(self, action: #selector(MapInviteViewController.callPhoneNumber(sender:)), for: .touchUpInside)
    calloutView.addSubview(button)
    
    ///retrieve photo of place
    // Specify the place data types to return (in this case, just photos).
    let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.photos.rawValue))
    
    

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
