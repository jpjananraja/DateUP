//
//  LoginViewController.swift
//  DateUp
//
//  Created by Janan Rajaratnam on 7/13/15.
//  Copyright (c) 2015 Janan Rajaratnam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func pressedFBLogin(sender: UIButton)
    {
        PFFacebookUtils.logInWithPermissions(["public_profile", "user_about_me", "user_birthday"], block: {
            user, error in
            if user == nil
            {
                println("Uh oh. The user cancelled the Facebook login")
                
                //Add UIALertController before pushing to app store
                
                return
                
            }
            else if user.isNew
            {
                println("User signed up and logged in through Facebook!")
                
                FBRequestConnection.startWithGraphPath("/me?fields=picture,first_name,birthday,gender", completionHandler: {
                    connection, result, error in
                    var resultDictionary = result as NSDictionary
                    user["firstName"] = resultDictionary["first_name"]
                    user["gender"] = resultDictionary["gender"]
//                    user["picture"] = ((resultDictionary["picture"] as NSDictionary) ["data"] as NSDictionary)["url"]
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    user["birthday"] = dateFormatter.dateFromString(resultDictionary["birthday"] as String)
                    
                    //Get the profile picture's URL in the form of a string from the resultsDictionary Dictionary
                    let pictureURL:String  = ((resultDictionary["picture"] as NSDictionary) ["data"] as NSDictionary)["url"] as String
                    
                    //format the url using the string value obtained above
                    let url = NSURL(string: pictureURL)
                    
                    //Make a NSURL Request
                    let request = NSURLRequest(URL: url!)
                    
                    //An alternative to NSURLSession.sharedSession() and using dataTaskWithRequest(....) on it
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
                        response, data, error in
                        
                        let imageFile = PFFile(name: "avatar.jpg", data: data)
                        
                        user["picture"] = imageFile
                        
                        user.saveInBackgroundWithBlock(nil)
                        
                        
                    })
                    
                   
//                    user.saveInBackgroundWithBlock({
//                        success , error in
//                        println(success)
//                        println(error)
//                        
//                    })
                    
                })
            }
            else
            {
                println("User logged in through Facebook!")
            }
            
            //If the user is not nill and he/she exits and is either new or not new then do the following
            
// **********************************************************************************
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardsNavController") as? UIViewController
//            
//            self.presentViewController(vc!, animated: true, completion: nil)
// **********************************************************************************
            
            //the above lines of code will cause a crash when navigating between the cardsVC and profileVC since pageController was not initialised and would thus produce an array index out of bounds error.
//            Use the code below instead of the above two lines of code
            
            self.presentViewController(pageController, animated: true, completion: nil)
        })
    }

}
