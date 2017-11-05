//
//  LoginViewController.swift
//  TwitterMe
//
//  Created by my mac on 10/31/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    
//    let baseu

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func onLoginTapped(_ sender: Any) {
        //Give information about base url and consumer secret and key to be placed in request header
        let twitterClient = TwitterClient.sharedInstance
        
        twitterClient?.login(success: { 
            //Segue to next view controller now that we are loggged in.
            print("I am logged in!")
            
        }) { (error: Error) in
            print("[ERROR]: \(error)")
        }
        
        

       
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
