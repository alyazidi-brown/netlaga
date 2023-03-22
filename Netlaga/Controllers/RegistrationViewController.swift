//
//  ViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/2/22.
//

import UIKit

class RegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //http://localhost/dating_app/register.php?email=leonidas@yahoo.com&firstName=Leonidas&phoneNumber=+3000121234&birthday=31-02-85&gender=male&Interested_In=women&Facebook_link=something
        
        //STEP 1. Declaring URL of the request; declaring the body to the url; declaring request with the safest methid - POST, that no one can grab our info.
     
        let url:URL = URL(string: "https://netlaga.net/register2.php")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        
        
        let paramString: String = "email=leonidas12@yahoo.com&firstName=Leonidas&phoneNumber=number&birthday=31-02-84&gender=male&Interested_In=women&Interests=women&Looking_For=women&Facebook_link=something3"//"email=johnwick@yahoo.com&firstName=Leonidas8&phoneNumber=3000121235&gender=male&Interested_In=women&Facebook_link=something2"
            
            
            //"email=leonidas3@yahoo.com" email, $firstName, $phoneNumber, $gender, $Interested_In, $Facebook_link //"email=leonidas2@yahoo.com&firstName=Leonidas2&phoneNumber=+3000121235&birthday=31-02-84&gender=male&Interested_In=women&Facebook_link=something2"
        
        //print("parameter string\(paramString)")
        
        
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
                            helper.showAlert(title: "Data Error", message: error!.localizedDescription, from: self)
                            return
                        }
                  
                        //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                        
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
    
    


}

