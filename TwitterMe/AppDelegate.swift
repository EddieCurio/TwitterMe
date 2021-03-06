//
//  AppDelegate.swift
//  TwitterMe
//
//  Created by my mac on 10/31/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let navigationControllerId: String = "TweetsNavigationController"
    let containerViewControllerId : String = "MenuBarContainerController"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        
        catch {
            
            print("Setting category to AVAudioSessionCategoryPlayback failed")
        }
        
      //  TwitterClient.sharedInstance?.deauthorize()
      //  User.currentUser = nil
      //  User._currentUser = nil
        if User.currentUser != nil {
             print("There is a current user")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: containerViewControllerId)

            window?.rootViewController = vc
            
            return true

        }else {
           print("There is not a current user.")
        }
        
        //Notification observing logout sequence
        NotificationCenter.default.addObserver(forName: NSNotification.Name("didLogout"), object: nil, queue: OperationQueue.main) { (notification: Notification) in
            print("Notification receiveds")
            //Load and show the login view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let loginViewController = storyboard.instantiateViewController(withIdentifier: LoginViewController.storyboardIdString)
            
            self.window?.rootViewController = loginViewController
        }
        return true
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    /*This function is called by the app whenerver the app is opened from the URL*/
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
            
        print("url: \(url.description)") // twitterdemo://oauth?oauth_token=<requesttoken>&oauth_verifier=<other thing>
        
        let twitterClient = TwitterClient.sharedInstance
        twitterClient?.handleOpenUrl(url: url)
        
       
        
                

        
        return true
    }


}

