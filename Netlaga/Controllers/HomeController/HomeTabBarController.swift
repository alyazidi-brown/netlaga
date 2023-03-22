//
//  HomeTabBarController.swift
//  DatingApp
//
//  Created by Scott Brown on 9/12/22.
//
import UIKit
class HomeTabBarController: UITabBarController, UITabBarControllerDelegate {
    
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
        
        print("order 2 \(fromPost)")
        
        print("order 1")
            //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
            self.delegate = self
            
                // Create Tab one
                let tabOne = HomeViewController()
                let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "Female.png"), selectedImage: UIImage(named: "Female.png"))
                tabOneBarItem.image = UIImage(named: "Female.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                tabOne.tabBarItem = tabOneBarItem
                
                
                // Create Tab two
                let tabTwo = PreDiscoveryViewController()//DiscoveryViewController()
                let tabTwoBarItem2 = UITabBarItem(title: "", image: UIImage(named: "Female.png"), selectedImage: UIImage(named: "Female.png"))
                tabTwoBarItem2.image = UIImage(named: "Female.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                tabTwo.tabBarItem = tabTwoBarItem2
                
            
                    // Create Tab three
                    let tabThree = FeaturesViewController()
                    let tabThreeBarItem3 = UITabBarItem(title: "", image: UIImage(named: "Female.png"), selectedImage: UIImage(named: "Female.png"))
                    tabThreeBarItem3.image = UIImage(named: "Female.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                    
                    tabThree.tabBarItem = tabThreeBarItem3
            
                // Create Tab three
                let tabFour = TimeLineViewController()
                let tabFourBarItem4 = UITabBarItem(title: "", image: UIImage(named: "Female.png"), selectedImage: UIImage(named: "Female.png"))
            tabFourBarItem4.image = UIImage(named: "Female.png")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
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
            
        }
   
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        
        /*
        // Create Tab one
        let tabOne = HomeViewController()
        let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "Female.png"), selectedImage: UIImage(named: "Female.png"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let tabTwo = DiscoveryViewController()
        let tabTwoBarItem2 = UITabBarItem(title: "", image: UIImage(named: "Female.png"), selectedImage: UIImage(named: "Female.png"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
    
            // Create Tab three
            let tabThree = FeaturesViewController()
            let tabThreeBarItem3 = UITabBarItem(title: "", image: UIImage(named: "Female.png"), selectedImage: UIImage(named: "Female.png"))
            
            tabThree.tabBarItem = tabThreeBarItem3
        
             
             self.viewControllers = [tabOne, tabTwo, tabThree]
         
         */
         }
    
    
    
    
         
         // UITabBarControllerDelegate method
         func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            // print("Selected \(viewController.title!)")
         }
     }
