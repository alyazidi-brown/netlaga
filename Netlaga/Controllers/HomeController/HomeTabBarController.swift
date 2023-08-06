//
//  HomeTabBarController.swift
//  DatingApp
//
//  Created by Scott Brown on 9/12/22.
//
import UIKit
class HomeTabBarController: UITabBarController, UITabBarControllerDelegate, TinderDelegate, OriginalDelegate, PeopleFinderDelegate, postEventDelegate {
    
    
    
    
    
    
    
    var fromPost: Bool = false
    /*
    var fromPost: Bool? {
            didSet {
                debugPrint("TabBarViewController.set:str", fromPost ?? "value is nil")
                
                fromPost = fromPost
                
            }
    }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        defaultSettings()
        
        
        //UIApplication.shared.windows.first?.rootViewController = self
         //UIApplication.shared.windows.first?.makeKeyAndVisible()
   
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
            
       
         }
    
    func postEvent(discoverySetUp: DiscoveryStruct, event: Bool) {
      
        print("invite 3")
            //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
            self.delegate = self
            
                // Create Tab one
                let tabOneNav = UINavigationController(rootViewController: HomeViewController())//
                let tabOne = HomeViewController()
                let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "friend.png"), selectedImage: UIImage(named: "friend.png"))
                tabOneBarItem.image = UIImage(named: "friend.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                tabOne.tabBarItem = tabOneBarItem
                
                
                // Create Tab two
        
                let tabTwoNav = UINavigationController(rootViewController: PulseViewController())//
                let tabTwo = PulseViewController()//PreDiscoveryViewController()//DiscoveryViewController()
                let tabTwoBarItem2 = UITabBarItem(title: "", image: UIImage(named: "network"), selectedImage: UIImage(named: "network"))
                tabTwoBarItem2.image = UIImage(named: "network")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                tabTwo.tabBarItem = tabTwoBarItem2
        tabTwo.delegate = self
            
            // Create Tab three
            let tabThreeNav = UINavigationController(rootViewController: FeaturesViewController())//
            let tabThree = FeaturesViewController()
            let tabThreeBarItem3 = UITabBarItem(title: "", image: UIImage(named: "friend.png"), selectedImage: UIImage(named: "friend.png"))
            tabThreeBarItem3.image = UIImage(named: "friend.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
               
        tabThree.postDelegate = self
        
        tabThree.discoverySetUp = discoverySetUp
        tabThree.event = event
            tabThree.tabBarItem = tabThreeBarItem3
            
            // Create Tab three
        
            let tabFourNav = UINavigationController(rootViewController: TimeLineViewController())//
            let tabFour = TimeLineViewController()
            let tabFourBarItem4 = UITabBarItem(title: "", image: UIImage(named: "hourglass"), selectedImage: UIImage(named: "hourglass"))
            tabFourBarItem4.image = UIImage(named: "hourglass")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
            tabFour.tabBarItem = tabFourBarItem4
            
           
    /*
                for tabBarItem in tabBar.items! {
                    tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
                }
                
             */
                     self.viewControllers = [tabOne, tabTwo, tabThree, tabFour]
        
       
            
            self.selectedIndex = 2
        
    }
    
    
    func defaultSettings() {
        print("order 2 \(fromPost)")
        
        print("order 1")
            //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
            self.delegate = self
            
                // Create Tab one
                let tabOneNav = UINavigationController(rootViewController: HomeViewController())//
                let tabOne = HomeViewController()
                let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "friend.png"), selectedImage: UIImage(named: "friend.png"))
                tabOneBarItem.image = UIImage(named: "friend.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                tabOne.tabBarItem = tabOneBarItem
                
                
                // Create Tab two
        
                let tabTwoNav = UINavigationController(rootViewController: PulseViewController())//
                let tabTwo = PulseViewController()//PreDiscoveryViewController()//DiscoveryViewController()
                let tabTwoBarItem2 = UITabBarItem(title: "", image: UIImage(named: "network"), selectedImage: UIImage(named: "network"))
                tabTwoBarItem2.image = UIImage(named: "network")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                tabTwo.tabBarItem = tabTwoBarItem2
        tabTwo.delegate = self
            
            // Create Tab three
            let tabThreeNav = UINavigationController(rootViewController: FeaturesViewController())//
            let tabThree = FeaturesViewController()
            let tabThreeBarItem3 = UITabBarItem(title: "", image: UIImage(named: "friend.png"), selectedImage: UIImage(named: "friend.png"))
            tabThreeBarItem3.image = UIImage(named: "friend.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
        tabThree.postDelegate = self
            tabThree.tabBarItem = tabThreeBarItem3
            
            // Create Tab three
        
            let tabFourNav = UINavigationController(rootViewController: TimeLineViewController())//
            let tabFour = TimeLineViewController()
            let tabFourBarItem4 = UITabBarItem(title: "", image: UIImage(named: "hourglass"), selectedImage: UIImage(named: "hourglass"))
            tabFourBarItem4.image = UIImage(named: "hourglass")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
            tabFour.tabBarItem = tabFourBarItem4
            
           
    /*
                for tabBarItem in tabBar.items! {
                    tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
                }
                
             */
                     self.viewControllers = [tabOne, tabTwo, tabThree, tabFour]
        
        if fromPost == true {
        
            print("order 3")
            
        self.selectedIndex = 3
            
        } else {
            
            self.selectedIndex = 1
        }
        
        
    }
    
    
    func switchToPersons() {
        
        
            //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
            self.delegate = self
            
                // Create Tab one
                let tabOneNav = UINavigationController(rootViewController: HomeViewController())//
                let tabOne = HomeViewController()
                let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "friend.png"), selectedImage: UIImage(named: "friend.png"))
                tabOneBarItem.image = UIImage(named: "friend.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                tabOne.tabBarItem = tabOneBarItem
                
                
                // Create Tab two
                let tabTwoNav = UINavigationController(rootViewController: PeopleFinderController())//
                let tabTwo = PeopleFinderController()//PulseViewController()//TinderViewController()
                let tabTwoBarItem2 = UITabBarItem(title: "", image: UIImage(named: "network"), selectedImage: UIImage(named: "network"))
                tabTwoBarItem2.image = UIImage(named: "network")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                tabTwo.tabBarItem = tabTwoBarItem2
                tabTwo.delegate = self
                
            
                    // Create Tab three
        
                    let tabThreeNav = UINavigationController(rootViewController: FeaturesViewController())//
                    let tabThree = FeaturesViewController()
                    let tabThreeBarItem3 = UITabBarItem(title: "", image: UIImage(named: "friend.png"), selectedImage: UIImage(named: "friend.png"))
                    tabThreeBarItem3.image = UIImage(named: "friend.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tabThree.postDelegate = self
                    tabThree.tabBarItem = tabThreeBarItem3
            
                // Create Tab three
                let tabFourNav = UINavigationController(rootViewController: TimeLineViewController())//
                let tabFour = TimeLineViewController()
                let tabFourBarItem4 = UITabBarItem(title: "", image: UIImage(named: "hourglass"), selectedImage: UIImage(named: "hourglass"))
            tabFourBarItem4.image = UIImage(named: "hourglass")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
            tabFour.tabBarItem = tabFourBarItem4
            
           
            self.viewControllers = [tabOne, tabTwo, tabThree, tabFour]
        
        if fromPost == true {
        
            print("order 3")
            
        self.selectedIndex = 3
            
        } else {
            
            self.selectedIndex = 1
        }
        
        
    }
    
    func peopleFinder() {
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
            // Create Tab one
        
       
            let tabOneNav =  UINavigationController(rootViewController: HomeViewController())//
            let tabOne = HomeViewController()
            let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "friend.png"), selectedImage: UIImage(named: "friend.png"))
            tabOneBarItem.image = UIImage(named: "friend.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            tabOne.tabBarItem = tabOneBarItem
            
            
            // Create Tab two
            let tabTwoNav = UINavigationController(rootViewController: PreDiscoveryViewController())//
            let tabTwo = PreDiscoveryViewController()//PeopleFinderController()//TinderViewController()
            let tabTwoBarItem2 = UITabBarItem(title: "", image: UIImage(named: "network"), selectedImage: UIImage(named: "network"))
            tabTwoBarItem2.image = UIImage(named: "network")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            tabTwo.tabBarItem = tabTwoBarItem2
            tabTwo.delegate = self
            
        
                // Create Tab three
                let tabThreeNav = UINavigationController(rootViewController: FeaturesViewController())//
                let tabThree = FeaturesViewController()
                let tabThreeBarItem3 = UITabBarItem(title: "", image: UIImage(named: "friend.png"), selectedImage: UIImage(named: "friend.png"))
                tabThreeBarItem3.image = UIImage(named: "friend.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                tabThree.postDelegate = self
                tabThree.tabBarItem = tabThreeBarItem3
        
            // Create Tab three
            let tabFourNav = UINavigationController(rootViewController: TimeLineViewController())//
            let tabFour = TimeLineViewController()
            let tabFourBarItem4 = UITabBarItem(title: "", image: UIImage(named: "hourglass"), selectedImage: UIImage(named: "hourglass"))
        tabFourBarItem4.image = UIImage(named: "hourglass")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
        tabFour.tabBarItem = tabFourBarItem4
        
       
        self.viewControllers = [tabOne, tabTwo, tabThree, tabFour]
    
    if fromPost == true {
    
        print("order 3")
        
    self.selectedIndex = 3
        
    } else {
        
        self.selectedIndex = 1
    }
    
    
    }
    
    
    
         
         // UITabBarControllerDelegate method
         func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            // print("Selected \(viewController.title!)")
         }
     }
