//
//  TwitterClient.swift
//  TwitterMe
//
//  Created by my mac on 10/31/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import Foundation
import UIKit
import BDBOAuth1Manager



class TwitterClient: BDBOAuth1SessionManager{
    
    
    static let consumerKey = "hVQQ9kHseRNEOhVOsOqPeTXfY"
    static let consumerSecret = "6oHbCoKAZsz64CGSisAwZyQShq4TXomNupeBh3wk0jQMWXP1EW"
   
    static let sharedInstance =  TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    
    var loginSucess: (()->())?
    var failure:  ((Error) -> ())?

    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
    
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
          
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    
    }
    
    
    func saveTweet(user: User, tweetText: String, success: @escaping()->(), failure: @escaping (Error)->()){
        
        var queryParameters: [String: Any] = [:]
        queryParameters["status"]  = tweetText
        
        post("/1.1/statuses/update.json", parameters: queryParameters, progress: { (progess: Progress) in
            
        }, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print("[ERROR] \(error)")
            failure(error)
        }
        
    }
    
    
    func loadTweets(user: User, sucess: @escaping (([Tweet]) -> ()), failure : @escaping (Error) -> ()){
        let twitterClient = TwitterClient.sharedInstance
        twitterClient?.get("/1.1/statuses/user_timeline.json?screen_name=\(user.screenname!)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> () in
            let dictionary = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionary)
            
            sucess(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            failure (error)
        })
        
    }
    
    
//    func loadTweets(for user: User, success: @escaping([Tweet]) -> (), failure: @escaping(Error) -> ()){
//        
//        var queryParams: [String: Any] = [:]
//        queryParams["screen_name"]  = user.name!
//        queryParams["user_id"] = user.dictionary?["id"] 
//        
//        
//       
//        get("1.1/statuses/user_timeline.json", parameters: queryParams, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
//            print("RESPONSE: \(response) \n\n\n\n\n\n\n")
//            
//            guard let tweetDictionaries = response as? [NSDictionary] else {
//                 print("Could not extract dictionaries from data.")
//                return
//            }
//            let tweets = Tweet.tweetsWithArray(dictionaries: tweetDictionaries)
//            success(tweets)
//        }) { (task : URLSessionDataTask?, error: Error) in
//            print("An error has occurred. \(error)")
//            failure(error)
//        }
//    
//    }
    
    
    func currentAccount( success: @escaping (User) -> (), failure: @escaping (Error) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //  print("response: \(response)")
            
            
            let userDictionary = response as? NSDictionary
            
            let user = User(dictionary: userDictionary!)
    
            success(user)
    
            print("[NAME]: \(user.name)")
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("[ERROR]: \(error)")
            failure(error)
        })
    }
    
    func handleOpenUrl(url: URL){
        
        let requestToken =  BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print("received the access token")
            
            self.currentAccount(success: { (user: User) in
                User.currentUser  = user // Save the current user
                self.loginSucess!()

            }, failure: { (error: Error) in
                self.failure?(error)
            })
            
            
            
        }, failure: { (error: Error?) in
            print("[ERROR] \(error?.localizedDescription)")
            self.failure!(error!)
        })
        
        
    
    }
    
    
//    func loadPicture(url: URL){
//        
//    
//    
//    
//    }
    
    
    func login(success: @escaping () -> (), failure: @escaping (Error)->()){
        //Make sure to logout first....
        
        
     //   TwitterClient.sharedInstance?.deauthorize()
        self.loginSucess = success
        self.failure = failure
        
        
        //Now we need a request token so we can show twitter that we are the actual app not some random 3rd party app or loser who lives with his mom
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil
            , success: { (reqToken: BDBOAuth1Credential?) in
                guard let requestToken = reqToken?.token else {
                    print("No token received ::")
                    return;
                }
                print ("I got a token!")
                print("request token: \(requestToken)")
                //Go to url where user will be able to login
                guard  let authorizeUrl = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken)") else {
                    print("Could not create URL.")
                    return
                }
                
                
                UIApplication.shared.open(authorizeUrl, options: [:], completionHandler: { (success: Bool) in
                    if (success){
                        print("Successfully finished opening the url")
                    }
                })
                
                
                
        }, failure: { (error: Error?) in
            if let error = error{
                self.failure?(error)
                print("[ERROR]: \(error.localizedDescription)")
            }
            
        })
    }
    
}
