//
//  User.swift
//  TwitterMe
//
//  Created by my mac on 11/1/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

//Models used also for persistence

class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary){
        
        //Deserialization code
        self.name = dictionary["name"] as? String
        
        self.dictionary = dictionary
        
        self.screenname = dictionary["screen_name"] as? String
        
        if   let profileUrlString = dictionary["profile_image_url_https"] as? String {
            self.profileUrl = URL(string: profileUrlString)
        }
        
        
        self.tagline = dictionary["description"] as? String
        
    }
    
    
    static var _currentUser: User?
    
    class var currentUser: User?{
        get {
            if (_currentUser == nil){
                let defaults = UserDefaults.standard
                
                let jsonUserData =  defaults.object(forKey: "currentUser")
                
                if let jsonUserData = jsonUserData{
                    let dictionary = try! JSONSerialization.data(withJSONObject: jsonUserData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
                
            }
           
            
           
            
            return _currentUser
        }
        
        set(user){
            let defaults = UserDefaults.standard
            _currentUser = user
            
            
            if let user = user {
                let jsonData  = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.set(jsonData, forKey: "currentUser")
            }else {
                defaults.set(nil, forKey:"currentUser")
            }
            
            
            defaults.synchronize()
        }
    }

}
