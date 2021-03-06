//
//  FeedViewController.swift
//  TwitterMe
//
//  Created by my mac on 11/6/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit
import AVKit
import ImageViewer

class FeedViewController: UIViewController {
    
   
    @IBOutlet weak var tableView: UITableView!
    
    let feedViewCellReuseId = "FeedViewTableViewCell"
    let profileSegue = "ProfileSegue"
    let tweetDetailSegue = "TweetDetailSegue"
    let composeTweetSegue = "ComposeTweetSegue"
    let reusableFeedCellId = "com.ecarrillo.FeedCell"
    //Tweet data
    var tweets: [Tweet] = []
    //Gallery data (images for when use taps media)
    var currentGalleryItems: [GalleryItem] = []
    //For knowing which cell to get tweet data from
    var lastPressedCell: FeedCell?
    //For loading effect
    var refreshControl: UIRefreshControl?
    
    var isMoreDataLoading: Bool = false
    
    
    @IBOutlet weak var retweetViewTopConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.register(UINib(nibName: "FeedCell", bundle: Bundle.main), forCellReuseIdentifier: reusableFeedCellId)
        
        //Turn off cell highlighting
        
        //Init UIRefreshControl
        let refreshControl = UIRefreshControl()
        
        //Bind action to the refresh control
        refreshControl.addTarget(self, action: #selector(refreshTimeline
            ), for: UIControlEvents.valueChanged)
        
        //add refresh to table view
        self.tableView.insertSubview(refreshControl, at: 0)
        
        //Add initial data to feed
        self.refreshData(success: {}, failureBlock: {})
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Add autolayout
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        //Have to access parent view controller (tab bar controller) because this view controller is nested in
        self.parent?.title = "Home"
        
         transparentBar()
        
        setupNavigationBar()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupNavigationBar()
        self.refreshData(success: {}, failureBlock: {})

        //self.refreshData(success: {}, failureBlock: {})
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Should notify cells to stop playing videos
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopVideos"), object: nil)
        
    }
    

    @IBAction func didTapProfilePicture(_ sender: UITapGestureRecognizer) {
        print("Profile picture tapped.")
        lastPressedCell = sender.view?.superview?.superview as! FeedCell?
        self.performSegue(withIdentifier: profileSegue, sender: nil)
        
    }
    
    
    @IBAction func didTapName(_ sender: UITapGestureRecognizer) {
        print("Profile name tapped")
        
        lastPressedCell = sender.view?.superview?.superview as! FeedCell?
        

         let tabBarController = self.parent as! HomeTabBarController
        //Bug fix open retweeted tweet's owner's profile
        tabBarController.profilePictureTapped?((lastPressedCell?.displayedTweet?.owner)!)
        
        
    }
    
    
    
    
    @objc func refreshTimeline(){
        let twitterClient = TwitterClient.sharedInstance
        
        let successBlock: () -> () = {
            if let refreshControl = self.refreshControl{
                refreshControl.endRefreshing()

            }
        }
        
        let failure: ()->() = {
            if let refreshControl = self.refreshControl{
                refreshControl.endRefreshing()
                
            }
        }
        
        if let refreshControl = self.refreshControl{
            refreshControl.beginRefreshing()
        }
        
        refreshData(success: successBlock, failureBlock: failure)
        
        
    }
    
    func refreshData(success: @escaping()->(), failureBlock: @escaping () -> ()){
        let twitterClient = TwitterClient.sharedInstance
        
        twitterClient?.homeTimeline(success: { (tweets: [Tweet]) in
            //Default behavior
                self.tweets = tweets
                self.tableView.reloadData()
            self.isMoreDataLoading = false
            //Injectable behavior
            success()
                
        }, failure: { (error: Error) in
            print("[ERROR]: \(error)")
            self.isMoreDataLoading = false
            //Injectible behavior
            failureBlock()
        })
        
    }
    
    func setupNavigationBar(){
        
        
        
        //Set up left button
        let defaultProfileImage: UIImage = UIImage(named: "profile-Icon")! //Use default image
//        let profileButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        profileButton.titleLabel?.text = nil
        
        let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        
        if let currentUser = User.currentUser {
//            profileButton.setImageFor(.normal, with: currentUser.profileUrl!, placeholderImage: defaultProfileImage)
//            profileButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
//            
            profileImageView.setImageWith(currentUser.profileUrl!, placeholderImage: defaultProfileImage)
            profileImageView.contentMode = UIViewContentMode.scaleAspectFit
            
        }
        
        profileImageView.gestureRecognizers = []
        
        profileImageView.gestureRecognizers?.append(UITapGestureRecognizer(target: self, action: #selector(didTapProfileBar)))
        
        profileImageView.isUserInteractionEnabled = true
        
//        profileButton.addTarget(self, action: #selector(didTapProfileBar), for: .touchUpInside)
        
        //Set up right button
        
        let composeTweetButton = UIButton(type: .system)
        let composeTweetImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        
        composeTweetImageView.image = UIImage(named: "edit-icon")
        //Add Action
        composeTweetImageView.gestureRecognizers = []
        composeTweetImageView.gestureRecognizers?.append(UITapGestureRecognizer(target: self, action: #selector(onComposeTweetButtonTapped)))
        
       
        
        //We don't want title appearing for profile screen.
        if let tabBarController = self.parent{ // If this is true this means that it is nested in tab bar
            tabBarController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
            tabBarController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: composeTweetImageView)
            tabBarController.navigationItem.title = "Home"
          
        }
        
        composeTweetButton.addTarget(self, action: #selector(FeedViewController.onComposeTweetButtonTapped), for: UIControlEvents.touchUpInside)
        
        
        
        
    }
    
    @objc func didTapProfileBar(){
        guard let centralNavigationController = self.parent?.parent as? CentralNavigationController else {
            print("Could not get the central navigationc controller")
            return
        }
        
        centralNavigationController.navBarButtonTapped?()
        
        
    }
    
    @objc func onComposeTweetButtonTapped(){
        print("Compose tweet button tapped")
        self.performSegue(withIdentifier: self.composeTweetSegue, sender: nil)
    }
    
    func transparentBar() {
        let transparentPixel = UIImage(named: "TransparentPixel")
        
        let navigationBar = self.navigationController?.navigationBar
        
        navigationBar?.setBackgroundImage(transparentPixel, for: UIBarMetrics.default)
        
        navigationBar?.shadowImage = transparentPixel
        
        navigationBar?.backgroundColor  = UIColor.clear
        
        navigationBar?.isTranslucent  = true
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == profileSegue {
            if let profileViewController = segue.destination as? ProfileViewController{
                let lastPresed = lastPressedCell
                
                profileViewController.user = lastPresed?.tweet?.owner
            }
        }else if segue.identifier == tweetDetailSegue {
            if let  tweetDetailViewController = segue.destination as? TweetDetailViewController{
                let lastPressed = lastPressedCell
                tweetDetailViewController.tweet = lastPressed?.tweet
            }
        }else if segue.identifier == composeTweetSegue {
            if let composeTweetViewController  = segue.destination as? ComposeTweetViewController{
                composeTweetViewController.user = User.currentUser!
                composeTweetViewController.finished = {
                        self.navigationController?.popViewController(animated: true)
                      }
                }
            }
            
        }
    }

extension FeedViewController {
    

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //To prevent a billion requests!
        if (!isMoreDataLoading){
            let contentHeight = tableView.contentSize.height
            //Point at which we should reload the data
            //We are defining this to be one screeen scroll length away
            let offsetThreshold = contentHeight - tableView.bounds.height
            
            let offset = scrollView.contentOffset.y
            //When the user has scrolled past the threshold
            if (offset > offsetThreshold && tableView.isDragging){
                //Actual code to load the data
                isMoreDataLoading = true
                refreshTimeline()
            }
            
        }
      
    }
    
}




extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableFeedCellId) as!FeedCell
        
        //Turn off highlighting for cell selection
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.videoPlayTriggered = { (playerViewController: AVPlayerViewController, videoPlayer: AVPlayer) in
            //Modally present the view controller and call the player's play() method when complete.
            self.present(playerViewController, animated: true) {
                videoPlayer.play()
            }
            
        }
        
        cell.imageViewTapped = { (index: Int, images: [UIImage]) in
            
            self.currentGalleryItems = self.imagesToGallery(images: images)
            
            //Need to set gallery items before initializing view controller
            let galleryViewController = GalleryViewController(startIndex: index, itemsDatasource: self, displacedViewsDatasource: nil, configuration: self.galleryConfiguration())
            
            self.present(galleryViewController, animated: true, completion: {
                print("[SHOWING GVC]")
            })
        }
        
        
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        //Duct tape bug fix.
        cell.mediaView.frame = CGRect(x: cell.mediaView.frame.origin.x, y: cell.mediaView.frame.origin.y, width: cell.mediaView.frame.width, height: CGFloat(cell.defaultMediaViewHeight))
        
        let tweet = tweets[indexPath.row]
        
        cell.pressedUserHandle = { (handle: String) in
            
            guard let entities = tweet.entities else {
                print("Could not return the entitites")
                return
            }
            
            guard let userMentions = entities.userMentions else {
                print("Could not get the user mentions")
                return
            }
            
            
            var userId: Int?
            for mention in userMentions {
                if let name = mention.screenName {
                    if (handle == name){
                        userId = mention.id
                    }
                }
            }
            //If we actually were to find a match with the mention object...
            if let userId = userId {
                let api = TwitterClient.sharedInstance
                api?.getUser(with: userId, success: { (user) in
                    self.goToUserProfile(user: user)
                }, failure: { (error) in
                    print("[ERROR] SUM TING WONG")
                })
            }
        }
        
        let tapGestureNameLabel = UITapGestureRecognizer(target: self, action: #selector(FeedViewController.didTapName(_:)))
        cell.nameLabel.addGestureRecognizer(tapGestureNameLabel)
        cell.pressedTwitterLink = {(url: URL) in
            //  self.launchWebView(with: url)
            let options: [String: Any] = [:]
            UIApplication.shared.open(url, options: options, completionHandler: { (success) in
                if success {
                    print("successfully opened link")
                }else {
                    print("Could not open url")
                }
            })
        }
        
        
        let tapGestureProfilePicture = UITapGestureRecognizer(target: self, action: #selector (FeedViewController.didTapName(_:)))
        cell.profilePictureImageView.addGestureRecognizer(tapGestureProfilePicture)
        
        
        
        cell.tweet = tweet
        
        
        return cell
        
        
    }
    
    func goToUserProfile(user: User){
        let tabBarController = self.parent as! HomeTabBarController
        tabBarController.profilePictureTapped?((user))

    }
    
    func galleryConfiguration() -> GalleryConfiguration {
        return [GalleryConfigurationItem.closeLayout(ButtonLayout.pinLeft(0, 0)),
                GalleryConfigurationItem.itemFadeDuration(0.2)]
    }
    
    
    func imagesToGallery(images: [UIImage]) -> [GalleryItem] {
        var items: [GalleryItem] = []
        for image in images {
            
          let galleryItem = GalleryItem.image(fetchImageBlock: {
                $0(image)
            })
            
            items.append(galleryItem)
        }
        
        return items
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.lastPressedCell = cell as! FeedCell
        
        
        self.performSegue(withIdentifier: tweetDetailSegue, sender: nil)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}






extension FeedViewController: GalleryItemsDatasource{
    
    func itemCount() -> Int {
        return currentGalleryItems.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return currentGalleryItems[index]
    }
    
    
}
    


