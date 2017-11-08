//
//  FeedViewTableViewCell.swift
//  TwitterMe
//
//  Created by Eduardo Carrillo on 11/7/17.
//  Copyright © 2017 ecproductions. All rights reserved.
//

import UIKit

class FeedViewTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var replyImageView: UIImageView!
    
    @IBOutlet weak var replyNumberLabel: UILabel!
    
    @IBOutlet weak var retweetImageView: UIImageView!
    
    @IBOutlet weak var retweetNumberLabel: UILabel!
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    @IBOutlet weak var favoriteNumberLabel: UILabel!
    
    @IBOutlet weak var privateMessageImageView: UIImageView!
    
    
    
    
    var tweet: Tweet?{
        
        didSet{
            guard let tweet = self.tweet else {
                print("Woah, some weirdness just happened.")
                return;
            }
            
            
            
            //Update the UI.
        
        }
    
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
