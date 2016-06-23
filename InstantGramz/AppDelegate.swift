//
//  AppDelegate.swift
//  InstantGramz
//
//  Created by Olivia Gregory on 6/20/16.
//  Copyright © 2016 Olivia Gregory. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
//        let homeNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("InstaNavigationController") as! UINavigationController
//        let homeViewController = homeNavigationController.topViewController
//        
//
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "instantgramz"
                configuration.clientKey = "adfsiho;fhawe;eiohfw"  // set to nil assuming you have not set clientKey
                configuration.server = "https://quiet-island-66437.herokuapp.com/parse"
            })
        )
        
        
//        // check if user is logged in.
        if PFUser.currentUser() != nil {
            // if there is a logged in user then load the home view controller

           let homeViewController: HomeViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
            
            self.window?.rootViewController = homeViewController
     
            let tabBarController: UITabBarController = mainStoryboard.instantiateViewControllerWithIdentifier("InstaTabBarController") as! UITabBarController
            self.window?.rootViewController = tabBarController
           
            self.window?.makeKeyAndVisible()
            
            print("user logged in")
        }
        
        else {
            // if there is not a logged in user then load the login view controller
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController: LoginViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            
            self.window?.rootViewController = loginViewController
            
            self.window?.makeKeyAndVisible()
            
            print("user not logged in")
        }
        
        return true
        // Override point for customization after application launch.
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

