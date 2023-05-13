//
//  FeaturesViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 9/12/22.
//

import UIKit
import Kingfisher
import FirebaseAuth
import GeoFire
import MapKit
import CoreLocation
import Alamofire



class FeaturesViewController: UITableViewController, CLLocationManagerDelegate, friendDelegate {
    
    
    
    func friendRequest(status: String, friend_id: String) {
        
    }
    
    
    
    var users = [NSDictionary]()
    
    //var discoveryArray = [DiscoveryStruct]()
    
    var locationName : String = ""
    var locationAddress : String = ""
    
    //var discoveryArray : [DiscoveryStruct] = []
    static let shared = DiscoveryViewController()
    
    var discoveryArray = [UserFirebase]()
    
    var newPostsQuery = GFCircleQuery()
    
    //var locationManager: CLLocationManager? = nil
    var locationManager : CLLocationManager = CLLocationManager()
    //internal let refreshControl = UIRefreshControl()
    
    let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)

override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white

    tableView.register(TableCell.self, forCellReuseIdentifier: "cell")
    
    tableView.delaysContentTouches = false
    
    //tableview cell selection disabled
    //tableView.allowsSelection = false
    
    self.locationManager.requestAlwaysAuthorization()
      self.locationManager.delegate = self
    
    
    if #available(iOS 10.0, *) {
        tableView.refreshControl = refreshControl
    } else {
        tableView.addSubview(refreshControl!)
    }
    
    downloadMatches()
   
    
}
    
        //MARK: - Download
        private func downloadMatches() {
            
            UserService.downloadUserMatches { (matchedUserIds) in
                
                print("match user ids \(matchedUserIds)")
                
                if matchedUserIds.count > 0 {
                    
                    for userId in matchedUserIds {
                        
                        UserService.fetchUserData(uid: userId) { (discovery) in
                            
                         print("driver stuff \(discovery)")
                            
                            self.discoveryArray.append(discovery)//.append(discovery)
                                
                                print("discovery array \(discovery) \(self.discoveryArray)")
                                
                            DispatchQueue.main.async {

                            self.tableView.reloadData()
                                                
                                                
                                                    
                            }
                            
                            
                        }
                        
                        
                        
                    }
                  /*
                    FirebaseListener.shared.downloadUsersFromFirebase(withIds: matchedUserIds) { (allUsers) in
                        
                        self.recentMatches = allUsers
                        
                        DispatchQueue.main.async {
                            //nide notification spinner
                            self.tableView.reloadData()
                        }
                    }
                   */
                    
                    
                } else {
                    
                    //self.presentAlertController(withTitle: "Error", message: error.localizedDescription)
                    print("No matches")
                    //note show activity indicator result
                }
            }
        }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    if discoveryArray.count == 0 {
    self.tableView.setEmptyMessage("No cool people around here.... Don't worry check Feature tab to match you with someone cool.")
    } else {
    self.tableView.restore()
    }

    return discoveryArray.count

}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell
        
        cell.delegateFriend = self
        
       // cell.selectionStyle = .none
        
        cell.contentView.addSubview(cell.profilePhotoImageView)
        cell.contentView.addSubview(cell.nameLabel)
        cell.contentView.addSubview(cell.locationLabel)
        cell.contentView.addSubview(cell.friendButton)
        
        cell.profilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            cell.profilePhotoImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            cell.profilePhotoImageView.heightAnchor.constraint(equalToConstant: 50),
            cell.profilePhotoImageView.widthAnchor.constraint(equalToConstant: 50),
            cell.profilePhotoImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20)
            
            
            ])
        
        cell.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            cell.nameLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
            cell.nameLabel.heightAnchor.constraint(equalToConstant: 50),
            cell.nameLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -100),
            cell.nameLabel.leadingAnchor.constraint(equalTo: cell.profilePhotoImageView.trailingAnchor, constant: 20)
            
            
            ])
        
        cell.locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            cell.locationLabel.topAnchor.constraint(equalTo: cell.nameLabel.bottomAnchor, constant: 0),
            cell.locationLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0),
            cell.locationLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -100),
            cell.locationLabel.leadingAnchor.constraint(equalTo: cell.profilePhotoImageView.trailingAnchor, constant: 20)
            
            
            ])
         
         
        cell.friendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            cell.friendButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            cell.friendButton.heightAnchor.constraint(equalToConstant: 50),
            cell.friendButton.widthAnchor.constraint(equalToConstant: 50),
            cell.friendButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20)
            
            
            ])
        
        cell.friendButton.isHidden = true
            
        cell.contentView.isUserInteractionEnabled = true
         
         
        
    let discoverySetUp = discoveryArray[indexPath.row]
        
        
        let imageUrl = URL(string: discoverySetUp.ava)
        
        
        
        
        cell.profilePhotoImageView.kf.setImage(with: imageUrl)
        
        
        cell.friend_id = discoverySetUp.uid
        
        
        cell.profilePhotoImageView.tag = indexPath.row
        
        cell.profilePhotoImageView.layer.cornerRadius = cell.profilePhotoImageView.frame.size.width/2
        
        cell.profilePhotoImageView.layer.masksToBounds = true
        
        cell.profilePhotoImageView.clipsToBounds = true
        
        cell.friendButton.isUserInteractionEnabled = true
        
        
    cell.nameLabel.text = discoverySetUp.firstName//"TableViewCell programtically"
    cell.nameLabel.textAlignment = .center
    cell.nameLabel.textColor  = .black
        
    cell.locationLabel.text = discoverySetUp.place
    cell.nameLabel.textAlignment = .center
    cell.nameLabel.textColor  = .red
        
    return cell
}
    
/*
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = .lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = .orange
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = .blue
        
        return [share, favorite, more]
    }
 */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let discoverySetUp = discoveryArray[indexPath.row]
        
        let discoverySetUp2 = DiscoveryStruct(firstName: discoverySetUp.firstName, email: discoverySetUp.email, ava: discoverySetUp.ava, uid: discoverySetUp.uid, place: "", token: discoverySetUp.token)
        print("check that correct user is selected \(discoverySetUp.firstName) \(discoverySetUp.uid)")
        /*
        let vc = ChatController(discoverySetUp: discoverySetUp2) //your view controller
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
         */
        //deleteMessages(discoveryStruct: discoverySetUp2)
        
        //deleteImage(discoveryStruct: discoverySetUp2)
        
        gotoChat(discoveryStruct: discoverySetUp2)
        
        //navigationController?.pushViewController(vc, animated: true)
        
        //delegate?.controller(self, wantsToStartChatWith: discoverySetUp)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
}
    
    
    func deleteMessages(discoveryStruct: DiscoveryStruct) {
       
   print("featureviewcontroller")
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        
        let parameters: [String:Any] = ["userId": currentUid, "messengerId": discoveryStruct.uid]
        
                let url = "https://us-central1-datingapp-80400.cloudfunctions.net/scrape"
                
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
                    
            
                    
                    switch response.result {
                        case .success(let dict):
                            
                       
                        let successDict: [String: Any?] = dict as? [String: Any?] ?? [:]
                        
                        var refreshAlert = UIAlertController(title: "Chat", message: "Would you like to chat with this user?", preferredStyle: UIAlertController.Style.alert)

                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                          
                            
                            let vc = ChatViewController(recipientId: discoveryStruct.uid, recipientName: discoveryStruct.firstName)//ChatController(discoverySetUp: matchInfo) //your view controller
                            vc.discoverySetUp = discoveryStruct
                            vc.hidesBottomBarWhenPushed = true
                            //self.navigationController?.pushViewController(vc, animated: true)
                            vc.modalPresentationStyle = .overFullScreen
                            self.present(vc, animated: true, completion: nil)
                            
                          }))

                        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                          print("Handle Cancel Logic here")
                            
                            
                          }))

                        self.present(refreshAlert, animated: true, completion: nil)
                           
                        case .failure(let error):
                        print("delete here5 \(error.localizedDescription)")
                           
                            print(error.localizedDescription)
                            //completion(nil, error.localizedDescription)
                    }
                }
        
        
    }
     
    
    func gotoChat(discoveryStruct: DiscoveryStruct) {
        
        let vc = ChatViewController(recipientId: discoveryStruct.uid, recipientName: discoveryStruct.firstName)//ChatController(discoverySetUp: matchInfo) //your view controller
        vc.discoverySetUp = discoveryStruct
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    func deleteImage(discoveryStruct: DiscoveryStruct) {
       
   
        print("I go here 1st")
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        
        let parameters: [String:Any] = ["userId": currentUid, "messengerId": discoveryStruct.uid]
        
                let url = "https://us-central1-datingapp-80400.cloudfunctions.net/scrapeImage"
                
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
                    
            print("delete here32 \(parameters) \(response)")
                    
                    switch response.result {
                        case .success(let dict):
                        
                        self.deleteMessages(discoveryStruct: discoveryStruct)
                            
                        print("delete here4 \(response)")
                           
                           
                         
                        case .failure(let error):
                        print("delete here5 \(error.localizedDescription)")
                        
                        self.presentAlertController(withTitle: "Error", message: error.localizedDescription)
                           
                            print(error.localizedDescription)
                            //completion(nil, error.localizedDescription)
                    }
                }
        
        
    }
     
    
    
}




